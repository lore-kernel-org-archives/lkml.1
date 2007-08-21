Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbXHUXV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbXHUXV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 19:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbXHUXVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 19:21:36 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:48968 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370AbXHUXVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 19:21:35 -0400
Date: Tue, 21 Aug 2007 19:21:33 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070821232133.GB29691@Krystal>
References: <20070820201822.597720007@polymtl.ca> <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com> <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com> <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com> <20070821173849.GA8360@Krystal> <20070821174424.GB8360@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070821174424.GB8360@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:12:54 up 22 days, 23:31,  3 users,  load average: 0.24, 0.25, 0.26
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reformatting...

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> Hi Christoph,
> 
> If you are interested in the raw numbers:
> 
> The (very basic) test module follows. Make sure you change get_cycles()
> for get_cycles_sync() if you plan to run this on x86_64.
> 
> (tests taken on a 3GHz Pentium 4)
> 

(Note: test 1 uses the kfree slow path, as figured out by
instrumentation)

SLUB Performance testing
========================
1. Kmalloc: Repeatedly allocate then free test

* slub HEAD, test 1
kmalloc(8) = 201 cycles	    kfree = 351 cycles
kmalloc(16) = 198 cycles	  kfree = 359 cycles
kmalloc(32) = 200 cycles	  kfree = 381 cycles
kmalloc(64) = 224 cycles	  kfree = 394 cycles
kmalloc(128) = 285 cycles	  kfree = 424 cycles
kmalloc(256) = 411 cycles	  kfree = 546 cycles
kmalloc(512) = 480 cycles	  kfree = 619 cycles
kmalloc(1024) = 623 cycles	kfree = 750 cycles
kmalloc(2048) = 686 cycles	kfree = 811 cycles
kmalloc(4096) = 482 cycles	kfree = 538 cycles
kmalloc(8192) = 680 cycles	kfree = 734 cycles
kmalloc(16384) = 713 cycles	kfree = 843 cycles

* Slub HEAD, test 2
kmalloc(8) = 190 cycles	    kfree = 351 cycles
kmalloc(16) = 195 cycles	  kfree = 360 cycles
kmalloc(32) = 201 cycles	  kfree = 370 cycles
kmalloc(64) = 245 cycles	  kfree = 389 cycles
kmalloc(128) = 283 cycles	  kfree = 413 cycles
kmalloc(256) = 409 cycles	  kfree = 547 cycles
kmalloc(512) = 476 cycles	  kfree = 616 cycles
kmalloc(1024) = 628 cycles	kfree = 753 cycles
kmalloc(2048) = 684 cycles	kfree = 811 cycles
kmalloc(4096) = 480 cycles	kfree = 539 cycles
kmalloc(8192) = 661 cycles	kfree = 746 cycles
kmalloc(16384) = 741 cycles	kfree = 856 cycles

* cmpxchg_local Slub test
kmalloc(8) = 83 cycles	    kfree = 363 cycles
kmalloc(16) = 85 cycles	    kfree = 372 cycles
kmalloc(32) = 92 cycles	    kfree = 377 cycles
kmalloc(64) = 115 cycles	  kfree = 397 cycles
kmalloc(128) = 179 cycles	  kfree = 438 cycles
kmalloc(256) = 314 cycles	  kfree = 564 cycles
kmalloc(512) = 398 cycles	  kfree = 615 cycles
kmalloc(1024) = 573 cycles	kfree = 745 cycles
kmalloc(2048) = 629 cycles	kfree = 816 cycles
kmalloc(4096) = 473 cycles	kfree = 548 cycles
kmalloc(8192) = 659 cycles	kfree = 745 cycles
kmalloc(16384) = 724 cycles	kfree = 843 cycles



2. Kmalloc: alloc/free test

* slub HEAD, test 1
kmalloc(8)/kfree = 322 cycles
kmalloc(16)/kfree = 318 cycles
kmalloc(32)/kfree = 318 cycles
kmalloc(64)/kfree = 325 cycles
kmalloc(128)/kfree = 318 cycles
kmalloc(256)/kfree = 328 cycles
kmalloc(512)/kfree = 328 cycles
kmalloc(1024)/kfree = 328 cycles
kmalloc(2048)/kfree = 328 cycles
kmalloc(4096)/kfree = 678 cycles
kmalloc(8192)/kfree = 1013 cycles
kmalloc(16384)/kfree = 1157 cycles

* Slub HEAD, test 2
kmalloc(8)/kfree = 323 cycles
kmalloc(16)/kfree = 318 cycles
kmalloc(32)/kfree = 318 cycles
kmalloc(64)/kfree = 318 cycles
kmalloc(128)/kfree = 318 cycles
kmalloc(256)/kfree = 328 cycles
kmalloc(512)/kfree = 328 cycles
kmalloc(1024)/kfree = 328 cycles
kmalloc(2048)/kfree = 328 cycles
kmalloc(4096)/kfree = 648 cycles
kmalloc(8192)/kfree = 1009 cycles
kmalloc(16384)/kfree = 1105 cycles

* cmpxchg_local Slub test
kmalloc(8)/kfree = 112 cycles
kmalloc(16)/kfree = 103 cycles
kmalloc(32)/kfree = 103 cycles
kmalloc(64)/kfree = 103 cycles
kmalloc(128)/kfree = 112 cycles
kmalloc(256)/kfree = 111 cycles
kmalloc(512)/kfree = 111 cycles
kmalloc(1024)/kfree = 111 cycles
kmalloc(2048)/kfree = 121 cycles
kmalloc(4096)/kfree = 650 cycles
kmalloc(8192)/kfree = 1042 cycles
kmalloc(16384)/kfree = 1149 cycles

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
