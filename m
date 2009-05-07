Return-Path: <linux-kernel-owner+w=401wt.eu-S1762811AbZEGV6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762811AbZEGV6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZEGV6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:58:39 -0400
Received: from sous-sol.org ([216.99.217.87]:38500 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752187AbZEGV6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:58:38 -0400
Date: Thu, 7 May 2009 14:57:12 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Message-ID: <20090507215712.GI3036@sequoia.sous-sol.org>
References: <4A031471.7000406@novell.com> <20090507192145.GF3036@sequoia.sous-sol.org> <4A033685.7070802@gmail.com> <200905072254.06982.arnd@arndb.de> <4A034F0E.6010603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A034F0E.6010603@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (gregory.haskins@gmail.com) wrote:
> Arnd Bergmann wrote:
> > pci_iomap could look at the bus device that the PCI function sits on.
> > If it detects a PCI bridge that has a certain property (config space
> > setting, vendor/device ID, ...), it assumes that the device itself
> > will be emulated and it should set the address flag for IO_COND.
> >
> > This implies that all pass-through devices need to be on a different
> > PCI bridge from the emulated devices, which should be fairly
> > straightforward to enforce.

Hmm, this gets to the grey area of the ABI.  I think this would mean an
upgrade of the host would suddenly break when the mgmt tool does:

(qemu) pci_add pci_addr=0:6 host host=01:10.0

> Thats actually a pretty good idea.
> 
> Chris, is that issue with the non ioread/iowrite access of a mangled
> pointer still an issue here?  I would think so, but I am a bit fuzzy on
> whether there is still an issue of non-wrapped MMIO ever occuring.

Arnd was saying it's a bug for other reasons, so perhaps it would work
out fine.

thanks,
-chris
