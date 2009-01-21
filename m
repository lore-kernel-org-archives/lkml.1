Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZAURVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZAURVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZAURVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:21:07 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33358 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZAURVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:21:06 -0500
Date: Wed, 21 Jan 2009 18:22:48 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Getting out-of-kernel modules compiled
Message-ID: <20090121172248.GA3661@uranus.ravnborg.org>
References: <Pine.LNX.4.61.0901211052020.16591@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0901211052020.16591@chaos.analogic.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 10:57:25AM -0500, linux-os (Dick Johnson) wrote:
> 
> Back in 2004, we make the following to compile
> out-of-kernel modules. It worked.
> 
> Now, the kernel build doesn't "know" how to handle "asm.S"
> files and always thinks a "name.o" file is the result of
> a "name.c" file, so I can't buld them no  matter how hard
> I try!
> 
> What do I need to do????
> 
> #
> #	Project Makefile for kernel versions over 6 
> #	Created 05-OCT-2004	Richard B. Johnson
> #
> 
> VER	:=	$(shell uname -r)
> PWD	:=	$(shell pwd)
> 
> all:		driver
> 
> driver:
>  		make V=1 -C /usr/src/linux-$(VER) SUBDIRS=$(PWD) modules
> 
> rtc_hwr.o:	rtc_hwr.S
>  		as -o $@ $<
> 
> obj-m		= 	rtc.o
> obj-m		+= 	rtc_hwr.o

kbuild has never (at least for a very long time) not
supported to implement a module only in assembler.

So you will have no luck trying to build the
module rtc_hrw.ko

What you can do is to define a module like htis:
obj-m := dick.o
dick-y := rtc.o rtc_hwr.o

This will properly build rtc_hwr.S => rtc_hwr.o

	Sam
