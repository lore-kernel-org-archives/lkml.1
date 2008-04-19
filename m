Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbYDSC4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbYDSC4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 22:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYDSC4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 22:56:23 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3841 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYDSC4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 22:56:22 -0400
Subject: Re: Alternative implementation of the generic __ffs
From: Joe Perches <joe@perches.com>
To: dean gaudet <dean@arctic.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org>
References: <20080331171506.GA24017@mailshack.com>
	 <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com>
	 <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>
	 <1207507897.18129.1246358115@webmail.messagingengine.com>
	 <alpine.DEB.1.10.0804061320470.7751@twinlark.arctic.org>
	 <1207563950.7880.1246457209@webmail.messagingengine.com>
	 <20080418201809.GA5036@mailshack.com>
	 <alpine.DEB.1.10.0804181642150.6108@twinlark.arctic.org>
	 <1208563762.10414.19.camel@brick>
	 <alpine.DEB.1.10.0804181719390.6108@twinlark.arctic.org>
	 <1208566724.4891.25.camel@localhost> <1208567093.10414.20.camel@brick>
	 <alpine.DEB.1.10.0804181810500.6108@twinlark.arctic.org>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 19:55:28 -0700
Message-Id: <1208573728.11990.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-18 at 18:11 -0700, dean gaudet wrote: 
> have you benchmarked it?

I modified Alexander's benchmark:
http://lkml.org/lkml/2008/4/18/267
to include 32 and 64 bit variants called smallest.

On an old ARM:

$ gcc --version
gcc (GCC) 3.4.6

$ cat /proc/cpuinfo 
Processor	: Intel StrongARM-110 rev 4 (v4l)
BogoMIPS	: 262.14
Hardware	: Rebel-NetWinder
Revision	: 57ff
Serial		: 000000000000185c

$ gcc -Os -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3180 tics,  8379 tics
New:            4280 tics,  8890 tics
Smallest:       4027 tics,  7835 tics
Empty loop:     1543 tics,  2260 tics

$ gcc -O2 -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3161 tics,  7843 tics
New:            4778 tics,  8783 tics
Smallest:       4408 tics,  7149 tics
Empty loop:     1515 tics,  2140 tics

$ gcc -O3 -fomit-frame-pointer ffs.c
$ ./a.out
Original:       3078 tics,  7692 tics
New:            4714 tics,  8671 tics
Smallest:       4344 tics,  7117 tics
Empty loop:     1444 tics,  2024 tics

On my old laptop:

$ cat /proc/cpuinfo 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 Mobile CPU 1.60GHz
stepping        : 4
cpu MHz         : 1200.000
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm up
bogomips        : 2400.03
clflush size    : 64

$ gcc --version
gcc (GCC) 4.3.0

$ gcc -Os -fomit-frame-pointer ffs.c
$ ./a.out
Original:        901 tics,  1426 tics
New:             862 tics,  1244 tics
Smallest:        911 tics,  1331 tics
Assembly:        208 tics,   402 tics
Empty loop:      208 tics,   304 tics

$ gcc -O2 -fomit-frame-pointer ffs.c
$ ./a.out
Original:        918 tics,  1386 tics
New:             872 tics,  1193 tics
Smallest:        906 tics,  1309 tics
Assembly:        202 tics,   396 tics
Empty loop:      207 tics,   299 tics

$ gcc -O3 -fomit-frame-pointer ffs.c
$ ./a.out
Original:        865 tics,  1389 tics
New:             852 tics,  1183 tics
Smallest:        907 tics,  1296 tics
Assembly:        200 tics,   390 tics
Empty loop:      211 tics,   296 tics


