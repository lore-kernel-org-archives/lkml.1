Return-Path: <linux-kernel-owner+w=401wt.eu-S932429AbXBWOqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbXBWOqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932431AbXBWOqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:46:24 -0500
Received: from marvin.h-e-r-e-s-y.com ([87.106.62.5]:36808 "EHLO
	marvin.h-e-r-e-s-y.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbXBWOqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:46:23 -0500
From: Andrew Walrond <andrew@walrond.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: (Sparc64) 2.6.20 seems to ignore initramfs
Date: Fri, 23 Feb 2007 14:46:20 +0000
User-Agent: KMail/1.9.5
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200702231108.10185.andrew@walrond.org> <45DEECEE.6070108@wpkg.org>
In-Reply-To: <45DEECEE.6070108@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702231446.20929.andrew@walrond.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 February 2007 13:32, Tomasz Chmielewski wrote:
> Andrew Walrond schrieb:
> > On a Sun T1000 I am trying to boot 2.6.20 using initramfs. (I use the
> > same procedure successfully on x86_64 and itanium2 servers).
> >
> > The relevent silo section looks like this:
> >
> > image=/boot/2.6.20.image
> >         label=2.6.20
> >         initrd=/boot/2.6.20.initramfs
> >         partition=2
> >         read-only
> >
> > The kernel loads and boots and I see
>
> (...)
>
> > So it knows about the initramfs, but then tries to mount a root
> > filesystem instead...
> >
> > I haven't tried this (initramfs)  with earlier kernels, so I don't know
> > whether this is a regression. Any clues about how to solve this would be
> > greatly appreciated.
>
> Does it make a difference if you embed initramfs directly in the kernel?
>
> CONFIG_INITRAMFS_SOURCE="/path/to/your/initramfs/directory"

Hi Tomasz. I can't tell; The combined kernel+initramfs is bigger than the 8Mb 
silo allocates for the kernel, and it does this:

	boot: chunky
	Allocated 8 Megs of memory at 0x40000000 for kernel
	/
	Fatal error: Image too large to fit in destination
	
	Fatal error: Image too large to fit in destination
	
	Error loading /boot/chunky
	
	Image not found.... try again


I don't see any silo config options to increase this value in the docs.

Good idea though :)

Andrew Walrond
