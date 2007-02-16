Return-Path: <linux-kernel-owner+w=401wt.eu-S1946254AbXBPXI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946254AbXBPXI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXBPXI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:08:59 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:12643 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbXBPXI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:08:58 -0500
Date: Fri, 16 Feb 2007 17:08:35 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: GPL vs non-GPL device drivers
In-reply-to: <Pine.LNX.4.61.0702161019020.4199@chaos.analogic.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Manu Abraham <abraham.manu@gmail.com>
Message-id: <45D63973.1030806@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GPbYGi2HYDPl2WlRgsq2dPbD6cM@ifi.uio.no>
 <fa.5t0XkAtEpB2nDYFPJKUBce9BKFE@ifi.uio.no>
 <fa.upvZMIS42lj8Tbudh1OdnbDn+Ts@ifi.uio.no>
 <fa.821rWTmf8FgAMnDeO7b6yeUeXYg@ifi.uio.no>
 <fa.+3hIy95KSdtolNz5kNmm6qk4FU8@ifi.uio.no> <45D4ED62.9080702@shaw.ca>
 <Pine.LNX.4.61.0702161019020.4199@chaos.analogic.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) wrote:
> Have you tried it recently? Attached is a compressed session

Yes, I have, most recently in 2.6.20. It works fine.

> showing 2.6.16.24 compiling fine. Then the same thing is attempted
> with 2.6.19. It fails with some "improper configuration" errors.
> This script shows that I execute the demanded commands
> as 'make oldconfig' and 'make prepare'. Then I try to compile
> again resulting, again with the exact same errors.
> This was reported on the Linux kernel list and somebody stated,
> with much authority BTW, "we don't support out of tree
> drivers anymore."

Who told you that? There's documentation in the kernel tree in 
Documentation/kbuild/modules.txt that describes how to set this up properly.

Looking at your output, without knowing what the makefile contents are, 
it's impossible to determine what's going wrong. Likely the makefile is 
trying to do things that the kernel build system should be doing. For a 
simple module called mymodule with files file1.c, file2.c, file3.c you 
need only a makefile like this:

ifneq ($(KERNELRELEASE),)

# kbuild part of makefile
obj-m  := mymodule.o
mymodule-y := file1.o file2.o file3.o

else

# Normal Makefile
KERNELDIR := /lib/modules/`uname -r`/build
all::
         $(MAKE) -C $(KERNELDIR) M=`pwd` $@

endif

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

