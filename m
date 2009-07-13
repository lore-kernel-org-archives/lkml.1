Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZGMSUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZGMSUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbZGMSUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:20:51 -0400
Received: from mail-01.cse.ucsc.edu ([128.114.48.32]:57991 "EHLO
	mail-01.cse.ucsc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587AbZGMSUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:20:51 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 14:20:50 EDT
In-Reply-To: <1247505941.7500.39.camel@twins>
References: <200907102350.47124.henrik@austad.us> <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu> <1247412708.6704.105.camel@laptop>  <1247499843.8107.548.camel@Palantir> <1247505941.7500.39.camel@twins>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5B78D181-E446-4266-B9DD-AC0A2629C638@soe.ucsc.edu>
Cc: Raistlin <raistlin@linux.it>, Douglas Niehaus <niehaus@ittc.ku.edu>,
       Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Transfer-Encoding: 7bit
From: Noah Watkins <jayhawk@soe.ucsc.edu>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
Date: Mon, 13 Jul 2009 11:14:30 -0700
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think you can extend PIP to include things like bandwidth  
> inheritance
> too. Instead of simply propagating the priority through the waitqueue
> hierarchy, you can pass the actual task around, and having this  
> task you
> can indeed consume its bandwidth etc..

I think I understand what you are suggesting by "pass the actual task  
around". If not, this message might seem out of place.

Consider this locking chain/graph:

A-->L1-->B-->L2-->C
D-->L3-->E-->L2

The way I understand what you are suggesting is that tasks A,B,D,E  
(or some representation of them) can be passed around such that when  
C executes it consumes some resource associated with the the tasks it  
is blocking (A,B,D,E). Obviously which tasks and what quantities are  
dependent on scheduling semantics and configuration.

The biggest implementation hurdle we have encountered is that as  
tasks are passed forward along a locking chain knowledge about the  
structure of the locking chain is lost. For example, as C releases  
L2, C must be able to distinguish between A and D as having been  
passed to C's location through B or E, respectively.

Keeping a representation of the locking chain as a full graph is the  
solution we have used. Another solution is to allow A and D to re- 
block and walk the locking chain again, but obviously some thundering- 
hurd issues arise.

noah




