Return-Path: <linux-kernel-owner+w=401wt.eu-S965765AbXCPRVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965765AbXCPRVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965756AbXCPRVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:21:51 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:38256 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965721AbXCPRVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:21:48 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: [PATCH 2.6.18] PCI: Turn pci_fixup_video into generic for embedded VGA
Date: Fri, 16 Mar 2007 11:20:44 -0600
User-Agent: KMail/1.9.5
Cc: eiichiro.oiwa.nm@hitachi.com, akpm@osdl.org, tony.luck@intel.com,
       greg@kroah.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
References: <XNM1$9$0$4$$3$3$7$A$9002686U451b55cd@hitachi.com> <200609280936.02098.jesse.barnes@intel.com>
In-Reply-To: <200609280936.02098.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161120.46123.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 September 2006 10:36, Jesse Barnes wrote:
> On Wednesday, September 27, 2006 9:55 pm, eiichiro.oiwa.nm@hitachi.com 
> wrote:
> > pci_fixup_video turns into generic code because there are many platforms
> > need this fixup for embedded VGA as well as x86. The Video BIOS
> > integrates into System BIOS on a machine has embedded VGA although
> > embedded VGA generally don't have PCI ROM. As a result, embedded VGA
> > need the way that the sysfs rom points to the Video BIOS of System RAM
> > (0xC0000). PCI-to-PCI Bridge Architecture specification describes the
> > condition whether or not PCI ROM forwards VGA compatible memory address.
> > fixup_video suits this specification. Although the Video ROM generally
> > implements in x86 code regardless of platform, some application such as
> > X Window System can run this code by dosemu86. Therefore,
> > pci_fixup_video should turn into generic code.
> ... 
> Thanks a lot, Eiichiro, this patch has been needed for awhile.

Are there really ia64 machines where we need to use the option ROM
copy at 0xC0000?  If so, is this documented somewhere?  I couldn't
find any mention in DIG64, EFI, or internal HP architecture specs.

If we do need to use it, ia64 has a bit of a problem because on some
boxes, the 0xC0000 memory supports only cacheable access, the VGA
frame buffer at 0xA0000 supports only uncacheable access, and the
usual ia64 ioremap mapping is a 16MB page that covers both.

Bjorn
