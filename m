Return-Path: <linux-kernel-owner+w=401wt.eu-S1752458AbXLVFaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbXLVFaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 00:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbXLVF36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 00:29:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbXLVF35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 00:29:57 -0500
Message-ID: <476CA0CF.3090607@redhat.com>
Date: Sat, 22 Dec 2007 00:29:51 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, prarit@redhat.com,
       tcamuso@redhat.com
Subject: Re: [PATCH 0/5]PCI: x86 MMCONFIG - a couple of corrections to the
 preamble
References: <20071222024044.26026.1461.sendpatchset@dhcp83-188.boston.redhat.com>
In-Reply-To: <20071222024044.26026.1461.sendpatchset@dhcp83-188.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some corrections to the preamble.

> The large amount of text is due to the nature of the
> problem and the discussion it engendered on the lkml.

Should say:

The large amount of text in the explanation below is due to
the nature of the problem and the discussion engendered on
lkml by my first submission.


> This patch-set detects the problem by comparing an MMCONFIG
> read to a Legacy PCI config read of the vendor/device dword
> of every device discovered during the PCI probing sequence.

Actually, the patch doesn't do a pci config read of EVERY device
discovered on every bus. Only on buses above a number defined
by PCI_MMCFG_MAX_CHECK_BUS and whose parent bus's pci_bus.ops
field points to pci_root_ops, which are mmconfig access routines
in systems in which mmconfig is the default mechanism.

In such cases where the parent bus pci_bus.ops field points
to pci_legacy_ops, the current bus does not need to be probed,
since its own pci_bus.ops field will inherit the pointer to
pci_legacy_ops from its parent.

