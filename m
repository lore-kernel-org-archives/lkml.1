Return-Path: <linux-kernel-owner+w=401wt.eu-S935757AbXGTPXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935757AbXGTPXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762408AbXGTPW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:22:58 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:38662 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756186AbXGTPW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:22:57 -0400
Date: Fri, 20 Jul 2007 11:22:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] [15/58] i386: Rewrite sched_clock
Message-ID: <20070720152255.GB511@Krystal>
References: <200707191154.642492000@suse.de> <200707201027.46532.ak@suse.de> <20070720141210.GA29979@Krystal> <200707201714.16811.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200707201714.16811.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:18:07 up 3 days,  9:52,  3 users,  load average: 0.17, 0.14, 0.17
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> 
> > So if, after this, we run tsc_sched_clock() with an unstable TSC, we
> > read a last_val containing the interrupt's MSB and the last_val LSB. It
> > can particularity hurt if we are around a 32 bits overflow, because time
> > could "jump" forward of about 1.43 seconds on a 3 GHz system.
> > 
> > So I guess we need synchronization on the fast path, and therefore using
> > cmpxchg_local on x86_64
> 
> On x86-64 the 64bit write is atomic against interrupts.
> 
> You're right 32bit has a problem though. I'm not too happy about 
> cmpxchg though because that wouldn't work on some CPUs.
> 

Which CPUs ? 386 ? do they even have a cycle counter ?

Please have a look at my reply to this email for the x86_64 problematic
case. This problematic case also applies to i386 (non atomicity of tsc
read vs write to memory).

> I wonder if we can just get away with using a 32bit value on i386.
> Just for the purpose of keeping the value monotonic it should be good
> enough. Will think about it.
> 

Yes, it could work. In this case you have to be aware that the 32 LSBs
of the TSC will overflow every ~ 1s and, in order to be sure to be able
to detect the overflow, you have to do at least 1 TSC read per second
(more precisely per 32 LSB overflow period).

> Thanks for the review.
> 

YW,

Mathieu

> -Andi
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
