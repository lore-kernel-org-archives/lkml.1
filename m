Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbXIYIdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbXIYIdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbXIYIdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:33:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:59317 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755610AbXIYIdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:33:31 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+hwHV6TNChnBGpFBwBA2z/C53MhK/DQdUALqRz0y
	l31Hb9xyKp+LGZ
Subject: Re: [git] CFS-devel, latest code
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1190705759.11910.10.camel@Homer.simpson.net>
References: <20070924214537.GA18980@elte.hu>
	 <1190700652.6482.7.camel@Homer.simpson.net>
	 <1190705759.11910.10.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 10:33:27 +0200
Message-Id: <1190709207.11226.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 09:35 +0200, Mike Galbraith wrote:

> Darn, have news: latency thing isn't dead.  Two busy loops, one at nice
> 0 pinned to CPU0, and one at nice 19 pinned to CPU1 produced the
> latencies below for nice -5 Xorg.  Didn't kill the box though.
> 
> se.wait_max              :            10.068169
> se.wait_max              :             7.465334
> se.wait_max              :           135.501816
> se.wait_max              :             0.884483
> se.wait_max              :           144.218955
> se.wait_max              :           128.578376
> se.wait_max              :            93.975768
> se.wait_max              :             4.965965
> se.wait_max              :           113.655533
> se.wait_max              :             4.301075
> 
> sched_debug (attached) is.. strange.

Disabling CONFIG_FAIR_GROUP_SCHED fixed both.  Latencies of up to 336ms
hit me during the recompile (make -j3), with nothing else running.
Since reboot, latencies are, so far, very very nice.  I'm leaving it
disabled for now.

	-Mike 

