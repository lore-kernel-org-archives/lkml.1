Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbYGKVN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbYGKVN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYGKVNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:13:48 -0400
Received: from relay2.sgi.com ([192.48.171.30]:35784 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753309AbYGKVNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:13:48 -0400
From: John Keller <jpk@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, John Keller <jpk@sgi.com>
Message-Id: <20080711211347.6461.68923.91734@attica.americas.sgi.com>
Subject: x86: PCI multi domain/segment config access
Date: Fri, 11 Jul 2008 16:13:47 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86 PCI Config space access to domains/segments > 0 appears to be broken.
The noted patch related to PCI ext config space has all config accesses
to offsets < 256 using conf1 if available, which is most likely the case.

This would force usage of conf1 for non-extended config access (< 256) on
PCI domains > 0.

Am I missing something, or how would a conf1 access reference a domain
other than zero?

John
------------

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b6ce068a1285a24185b01be8a49021827516b3e1




int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
                                                int reg, int len, u32 *val)
{
        if (reg < 256 && raw_pci_ops)
                return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
        if (raw_pci_ext_ops)
                return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
        return -EINVAL;
}

int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
                                                int reg, int len, u32 val)
{
        if (reg < 256 && raw_pci_ops)
                return raw_pci_ops->write(domain, bus, devfn, reg, len, val);
        if (raw_pci_ext_ops)
                return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
        return -EINVAL;
}



