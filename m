Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0BUXZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 18:25:20 -0500
Received: from www.tglx.de ([62.245.132.106]:45516 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab0BUXZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 18:25:17 -0500
Date: Mon, 22 Feb 2010 00:24:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [ANNOUNCE] 2.6.33-rc8-rt1
In-Reply-To: <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002212322450.2811@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain> <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain> <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
 <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain> <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain> <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain> <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain>
 <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain> <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain>
 <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain> <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain> <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain> <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

    - Forward to 2.6.33-rc8

Finally I managed to get that beast tamed. 

Some folks were already joking, that my dog ate the 33-rt patch. The
truth is that my reject fixup skills were one line off in the mm/*
code which resulted in -rt eating my files :) 

When I fixed the wreckage of my own stupidty I found out that -rt
triggered a nasty and hard to reproduce mainline scheduler bug, which
refused to reproduce with kernel tracing enabled. Thanks to Peter
Zijlstra for helping me to decode the initial mainline problem and the
ones which resulted from fixing the mainline bug!

It's all fixed now and I'm pretty happy about the state of this
release with the following exceptions:

 1) it is only runtime tested on x86_64 (compiles on x86_32, arm,
    powerpc_32/64).

    I'm going to throw it at my testing infrastructure tomorrow, but I
    wanted to release this before .33-final and of course you folks
    are heartely invited to help out with fixing the fallout :)

 2) I broke the histogram tracer stuff simply because I got lost in
    the divergence of -rt and mainline kernel/trace/* changes

    I apologize to Carsten, but I'm sure he will fix that in no time
    as usual

The current state of the patch on x86_64 is: rock stable!

    [rt-tests]# chrt -f 1 ./cyclictest -t -a -n -d0 -p80 -i125
    policy: fifo: loadavg: 509.19 490.53 486.66 364/1055 31899          

    T: 0 (27682) P:80 I:125 C:1170997397 Min: 2 Act: 3 Avg: 3 Max: 34
    T: 1 (27683) P:79 I:125 C:1170997397 Min: 2 Act: 3 Avg: 3 Max: 34
    
    That's an uptime of ~1.6 days with a load of hackbench, recursive
    grep and extensive networking traffic going on.

The merge of the spinlock namespace cleanup and the initial
annotations took a big chunk away from the -rt patch size:

	patch-2.6.31.12-rt21.patch     1680354
	patch-2.6.33-rc8.patch         1179390
	patch-2.6.33-rc8+git.patch     1067064

We are zooming in, but there is still a way to go!

Download locations:
   
   http://rt.et.redhat.com/download/ (temporary out of sync)
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git development branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33

Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33

Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page
 
To build the 2.6.33-rc8-rt1 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.32.tar.bz2
   http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.33-rc8.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33-rc8-rt1.bz2

Enjoy !

      tglx

