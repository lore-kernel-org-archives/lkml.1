Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXC1XLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXC1XLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 19:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933786AbXC1XLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 19:11:49 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:11376 "EHLO
	pd4mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933699AbXC1XLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 19:11:48 -0400
Date: Wed, 28 Mar 2007 17:09:49 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: possible mistake in linux kernel header file -- kernel: 2.6.16.29
 file: mod_devicetable.h
In-reply-to: <fa.oyzxCetQPxeJg2D2eekG0Gighs4@ifi.uio.no>
To: smitchel <smitchel@bnin.net>
Cc: linux-kernel@vger.kernel.org
Message-id: <460AF5BD.60603@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.oyzxCetQPxeJg2D2eekG0Gighs4@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

smitchel wrote:
> I am not sure where to post this, maybe you can direct me what to do, if 
> anything.
> 
> We have two computers running slackware for amd64 version 11.0.
> Tonight we compiled mplayer on each of the systems.
> 
> On the first, everything compiled fine--it has a core 2 duo cpu and is 
> running a stock kernel off the install DVD for slackware-amd64.
> it is kernel 2.6.16.29.
> 
> On the second it would not compile, and it has dual opteron 250 cpus and 
> is running a kernel that we compiled to add some things to
> for sound, etc.   This was from a kernel source that we downloaded a few 
> days ago.
> it is kernel 2.6.16.29--same as first machine.
> 
> The error is stopping in the file /usr/include/linux/mod_devicetable.h.
> 
> It appears that there are 4 extra lines that have been added to the  
> mod_devicetable.h that was part of the kernel source that we downloaded.
> They are in the first screenful of the file:
> 
> #ifdef __KERNEL__
> #include <linux/types.h>
> typedef unsigned long kernel_ulong_t;
> #endif
> 
> They are not in the same file in the kernel source from the slackware 
> amd-64 install DVD. (<linux/types.h> included somewhere else?)
> 
> Googling we found:
> __KERNEL__ is defined for programs that run in kernel mode instead of 
> user programs (whatever that means).
> 
> A few lines later in mod_devicetable.h it uses the type kernel_ulong_t 
> (in the same file--what if the ifdef path is not taken?)

These compile errors are from compiling mplayer? Something is not right 
here, it shouldn't be including that header file at all - and I'm not 
sure how anything in /usr/include could be ending up trying to do so.

__KERNEL__ is only supposed to be defined when building the kernel 
itself. Current kernels (not sure if 2.6.16 had this though) have a 
process which generates header files suitable for userspace from the 
kernel's header files and strips out everything inside #ifdef __KERNEL__.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

