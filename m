Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZJSURQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZJSURQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 16:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbZJSURO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 16:17:14 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:38173 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbZJSURJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 16:17:09 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86/pci: intel bus root res with IOH reading -v2
Date: Mon, 19 Oct 2009 14:17:09 -0600
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <4AC97C00.7090503@kernel.org> <200910061133.27546.bjorn.helgaas@hp.com> <4ACB839A.2060800@kernel.org>
In-Reply-To: <4ACB839A.2060800@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200910191417.10995.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 October 2009 11:51:22 am Yinghai Lu wrote:
> > What is the specific problem solved by this patch?  Does "pci=use_crs"
> > address any of that problem?  (I know "pci=use_crs" breaks some machines,
> > and I know it's unacceptable to require users to use it.  But I want to
> > understand whether the concept is related, and whether you've tripped
> > over a BIOS defect or a Linux pci_root.c defect.)
> 
> BIOS doesn't allocate resource to some pci devices when too many devices. and need kernel to allocate resource ( 32bit mmio, 64 mmio)
> to those devices.
> current only known fw that can allocate mmio 64 ( with correct setting) is LinuxBIOS.
> 
> also could help os to fend off some range that is wrongly allocated by BIOS that is cross the boundary between different peer root bus.
> 
> _CRS doesn't report any MMIO 64 range, even HW does have that set.

This discussion got derailed into "BIOS bad, Linux good" before I
could learn more about the specific problem you're solving.

Can you tell us what machine this fixes?  Can you include logs, e.g.,
dmesg/lspci/iomem, that show the problem, and corresponding ones
with your patch applied that show the fix?

Has the machine been released?  Does Windows work on it?

I'd also like to know more about the "range that is wrongly allocated
by BIOS that is cross the boundary between different peer root bus."
Does this mean the BIOS programmed the host bridges wrong, or does it
mean it reported something invalid in the host bridge _CRS, or something
else?

Thanks,
  Bjorn
