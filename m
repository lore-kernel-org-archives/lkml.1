Return-Path: <linux-kernel-owner+w=401wt.eu-S1754217AbZLTOaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbZLTOaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 09:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753147AbZLTOaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 09:30:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:35517 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752915AbZLTOaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 09:30:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/N44ZcUWnNk53SEpZcdnlVxYBvlbZwSscQTnZHON
	V1ix5cKObcaCz2
Subject: Re: [stable] Regression in 2.6.32.2: segfault on halt
From: Mike Galbraith <efault@gmx.de>
To: Holger =?ISO-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       stable@vger.kernel.org
In-Reply-To: <4B2E264E.4090805@googlemail.com>
References: <pan.2009.12.19.15.10.48.851500@googlemail.com>
	 <20091220054847.GF32739@1wt.eu> <4B2E10C6.7050304@googlemail.com>
	 <20091220130616.GC9719@1wt.eu>  <4B2E264E.4090805@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 15:30:00 +0100
Message-Id: <1261319400.6105.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 14:27 +0100, Holger Hoffstätte wrote:

> Took me some time (still learning git - I usually use hg) but I just
> managed to fix it by reverting not the bisected revision (won't compile
> any longer), but the follow-up "cleanup & fix":
> 
> >From 35c1ee3e78766d5666f418af638def9c67e63ecb Mon Sep 17 00:00:00 2001
> From: Mike Galbraith <efault@gmx.de>
> Date: Tue, 10 Nov 2009 03:50:02 +0100
> Subject: [PATCH] sched: Fix and clean up rate-limit newidle code
> 
> commit eae0c9dfb534cb3449888b9601228efa6480fdb5 upstream.
> 
> Commit 1b9508f, "Rate-limit newidle" has been confirmed to fix
> the netperf UDP loopback regression reported by Alex Shi.
> 
> This is a cleanup and a fix:
> 
>  - moved to a more out of the way spot
> 
>  - fix to ensure that balancing doesn't try to balance
>    runqueues which haven't gone online yet, which can
>    mess up CPU enumeration during boot.
> 
> Reported-by: Alex Shi <alex.shi@intel.com>
> Reported-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1257821402.5648.17.camel@marge.simson.net>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> aka:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=commit;h=35c1ee3e78766d5666f418af638def9c67e63ecb
> 
> Reverting this from a clean 32.2 tree results in a kernel with newidle
> fix, but still working halt/reboot. The only difference between this and
> the bisected one is the additional change in cpumask handling.
> 
> That was more fun than expected :)

Egad.  Reverting the cpumask bit alone cures the problem?

	-Mike

