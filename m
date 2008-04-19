Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbYDSEN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbYDSEN5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 00:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYDSENu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 00:13:50 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:33453 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYDSENt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 00:13:49 -0400
Date: Fri, 18 Apr 2008 21:13:47 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Joe Perches <joe@perches.com>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Alternative implementation of the generic __ffs
In-Reply-To: <1208573728.11990.14.camel@localhost>
Message-ID: <alpine.DEB.1.10.0804182112360.6108@twinlark.arctic.org>
References: <20080331171506.GA24017@mailshack.com>  <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com>  <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>  <1207507897.18129.1246358115@webmail.messagingengine.com> 
 <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>  <1207563950.7880.1246457209@webmail.messagingengine.com>  <20080418201809.GA5036@mailshack.com>  <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>  <1208563762.10414.19.camel@brick> 
 <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>  <1208566724.4891.25.camel@localhost> <1208567093.10414.20.camel@brick>  <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org> <1208573728.11990.14.camel@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008, Joe Perches wrote:

> On Fri, 2008-04-18 at 18:11 -0700, dean gaudet wrote: 
> > have you benchmarked it?
> 
> I modified Alexander's benchmark:
> http://lkml.org/lkml/2008/4/18/267
> to include 32 and 64 bit variants called smallest.
> 
> On an old ARM:

i'm guessing the 32-bit constants suck :(

the code could be modified to use 16-bit constants only -- it would add 
some dependent operations though (to move the hot bit into the low 
16-bits).

-dean


> 
> $ gcc --version gcc (GCC) 3.4.6
> 
> $ cat /proc/cpuinfo 
> Processor	: Intel StrongARM-110 rev 4 (v4l)
> BogoMIPS	: 262.14
> Hardware	: Rebel-NetWinder
> Revision	: 57ff
> Serial		: 000000000000185c
> 
> $ gcc -Os -fomit-frame-pointer ffs.c
> $ ./a.out
> Original:       3180 tics,  8379 tics
> New:            4280 tics,  8890 tics
> Smallest:       4027 tics,  7835 tics
> Empty loop:     1543 tics,  2260 tics
> 
> $ gcc -O2 -fomit-frame-pointer ffs.c
> $ ./a.out
> Original:       3161 tics,  7843 tics
> New:            4778 tics,  8783 tics
> Smallest:       4408 tics,  7149 tics
> Empty loop:     1515 tics,  2140 tics
> 
> $ gcc -O3 -fomit-frame-pointer ffs.c
> $ ./a.out
> Original:       3078 tics,  7692 tics
> New:            4714 tics,  8671 tics
> Smallest:       4344 tics,  7117 tics
> Empty loop:     1444 tics,  2024 tics
