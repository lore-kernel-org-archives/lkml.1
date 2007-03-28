Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbXC1Dna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbXC1Dna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 23:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbXC1Dna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 23:43:30 -0400
Received: from smtp001.indigital.net ([66.249.241.185]:54684 "EHLO
	smtp001.indigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbXC1Dn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 23:43:29 -0400
X-Greylist: delayed 934 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2007 23:43:29 EDT
Message-ID: <4609E0DF.5020508@bnin.net>
Date: Tue, 27 Mar 2007 23:28:31 -0400
From: smitchel <smitchel@bnin.net>
User-Agent: Thunderbird 1.5.0.7 (X11/20060919)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: possible mistake in linux kernel header file -- kernel: 2.6.16.29
 file: mod_devicetable.h
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure where to post this, maybe you can direct me what to do, if 
anything.

We have two computers running slackware for amd64 version 11.0.
Tonight we compiled mplayer on each of the systems.

On the first, everything compiled fine--it has a core 2 duo cpu and is 
running a stock kernel off the install DVD for slackware-amd64.
it is kernel 2.6.16.29.

On the second it would not compile, and it has dual opteron 250 cpus and 
is running a kernel that we compiled to add some things to
for sound, etc.   This was from a kernel source that we downloaded a few 
days ago.
it is kernel 2.6.16.29--same as first machine.

The error is stopping in the file /usr/include/linux/mod_devicetable.h.

It appears that there are 4 extra lines that have been added to the  
mod_devicetable.h that was part of the kernel source that we downloaded.
They are in the first screenful of the file:

#ifdef __KERNEL__
#include <linux/types.h>
typedef unsigned long kernel_ulong_t;
#endif

They are not in the same file in the kernel source from the slackware 
amd-64 install DVD. (<linux/types.h> included somewhere else?)

Googling we found:
__KERNEL__ is defined for programs that run in kernel mode instead of 
user programs (whatever that means).

A few lines later in mod_devicetable.h it uses the type kernel_ulong_t 
(in the same file--what if the ifdef path is not taken?)

We thought that for the header file to be self-consistent, the typedef 
statement should be defined in either case (__Kernel__ defined or not).
So we copied that line out of the ifdef to just below it.
Well that got rid of the type undefined error that occured during make.

We still got a bunch of errors, mostly every word in the 
mod_devicetable.h was individually "not understood" after the 
ifdef-endif lines.

Not wanting to break something somewhere else by defining __KERNEL__ 
when we don't even understand what it does...we copied the
include statement for <linux/types.h> after the endif, so basically both 
lines inside the ifdef are executed all the time.

Now it compiles fine.

Could this be a bug in a kernel header file?  It has to be. if you don't 
have __KERNEL__ defined, then the header file is broken because it uses
the type kernel_ulong_t just a few lines later.

Steve Mitchell
Byrel Mitchell
smitchel@bnin.net


