Return-Path: <linux-kernel-owner+w=401wt.eu-S932562AbYBGPQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbYBGPQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbYBGPQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:16:34 -0500
Received: from v813.rev.tld.pl ([195.149.226.213]:32912 "EHLO
	smtp.host4.kei.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118AbYBGPQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:16:33 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Feb 2008 10:16:32 EST
X-clamdmail: clamdmail 0.18a
From: Marcin Juszkiewicz <openembedded@haerwu.biz>
To: linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Date: Thu, 7 Feb 2008 16:09:34 +0100
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, Christoph Hellwig <hch@infradead.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20080207133805.13f092ff@dilbert.local> <20080207125824.GB7111@infradead.org> <20080207130117.GA18750@uranus.ravnborg.org>
In-Reply-To: <20080207130117.GA18750@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802071609.36960.openembedded@haerwu.biz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia Thursday, 7 of February 2008, Sam Ravnborg napisa³:
> On Thu, Feb 07, 2008 at 07:58:24AM -0500, Christoph Hellwig wrote:

> > Any chance to make arm finally use drivers/Kconfig?  It's a bit silly
> > that arm still is crapping around while even s390 uses it.

> rmk said that it should be easy to check the amount of work needed to
> do so. But I have not had time to look into it yet - hopefully someone
> in ARM land could fix it.

I looked at it and 'arch/arm/Kconfig' does not source few entries: 

- of - does not appear on ARM if enabled
- macintosh - does not appear on ARM if enabled
- telephony - drivers for ISA/PCI/PCMCIA so can probably be used on some
              ARM platforms
- infiniband - like above(?)
- edac - does not appear on ARM if enabled
- auxdisplay - basically it is for one LCD controller connected to x86
               parallel port - safe to have it sourced on ARM
- uio

Including of 'drivers/mtd' depends on "ALIGNMENT_TRAP || !CPU_CP15_MMU".

Including of 'drivers/ide' depends on "PCMCIA || ARCH_CLPS7500 || 
ARCH_IOP32X || ARCH_IOP33X || ARCH_IXP4XX || ARCH_L7200 || 
ARCH_LH7A40X || ARCH_PXA || ARCH_RPC || ARCH_S3C2410 || ARCH_SA1100 || 
ARCH_SHARK || FOOTBRIDGE || ARCH_IXP23XX" but 'drivers/ata' (which can be 
used instead on PCMCIA enabled platforms) does not depend on such set.

Does it look like 'drivers/mtd' require extra check 'if ARM then check for 
ALIGNMENT_TRAP || !CPU_CP15_MMU' and probably extra check 
in 'drivers/ide'?

I hope this info will help (test in 2.6.24-git 
488b5ec871191359b9b79262a3d48456dae7ea5f).

-- 
JID: hrw-jabber.org
OpenEmbedded developer/consultant

        "To be or not to be that is the question.":
         every programmer knows the answer $2b or (not $2b) is $ff.


