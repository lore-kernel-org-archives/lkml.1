Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671Ab0AUGCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0AUGCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 01:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638Ab0AUGCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 01:02:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:40321 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752636Ab0AUGCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 01:02:39 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19+wxBawDd+My3X/j8tIvxjrz4e22qzRAxfe3F8Z3
	P2ISR208W4oRvN
Subject: Re: perf top: losing events?
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1264052528.26323.13.camel@marge.simson.net>
References: <1264052528.26323.13.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 21 Jan 2010 07:02:36 +0100
Message-Id: <1264053756.26323.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.69999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yup, definitely a booboo in there somewhere.

Step 1.

oinker running, perf top -C 3 -z


------------------------------------------------------------------------------------------------------------------------------
   PerfTop:    1001 irqs/sec  kernel: 0.0% [1000Hz cycles],  (all, cpu: 3)                                                    
------------------------------------------------------------------------------------------------------------------------------

             samples  pcnt func DSO
             _______ _____ ____ ______________

             2003.00 100.0% main /root/bin/pert

perfect (off by one is beauty mark, not wart;)

Step 2.

taskset -c 3 ./massive_intr 3 999


  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
 7133 root      20   0  7928  232  128 R   25  0.0   0:09.68 3 massive_intr
 7134 root      20   0  7928  232  128 R   25  0.0   0:09.68 3 massive_intr
25932 root      20   0  7920  584  476 R   25  0.0  42:03.07 3 pert
 7132 root      20   0  7928  232  128 R   25  0.0   0:09.68 3 massive_intr

------------------------------------------------------------------------------------------------------------------------------
   PerfTop:     252 irqs/sec  kernel: 0.8% [1000Hz cycles],  (all, cpu: 3)
------------------------------------------------------------------------------------------------------------------------------

             samples  pcnt func DSO
             _______ _____ ____ ______________

              500.00 99.2% main /root/bin/pert


massive_intr appeared briefly, then poof, gone (likely when it forked
off worker-bees), leaving this.

	-Mike

