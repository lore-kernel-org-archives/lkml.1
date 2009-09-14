Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZINPcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZINPcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbZINPcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:32:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:38045 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753421AbZINPcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:32:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+cnzk9TnOc5wdDGi32QWms57e+PkfLcpYm/K4SVX
	z8oxrUoKFWdwim
Subject: Re: Phoronix CFS vs BFS bencharks
From: Mike Galbraith <efault@gmx.de>
To: Marcin Letyns <mletyns@gmail.com>
Cc: Nikos Chantziaras <realnc@arcor.de>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <f42384a10909140727k463ff460q3859892dcb79bcc5@mail.gmail.com>
References: <20090906205952.GA6516@elte.hu> <4AAE10E6.2050403@arcor.de>
	 <1252928133.22740.37.camel@marge.simson.net>
	 <f42384a10909140727k463ff460q3859892dcb79bcc5@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 17:32:15 +0200
Message-Id: <1252942335.12986.58.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 16:27 +0200, Marcin Letyns wrote:
> Hello,
> 
> Disabling NEW_FAIR_SLEEPERS makes a lot of difference here in the
> Apache benchmark:
> 
> 2.6.30.6-bfs: 7311.05
> 
> 2.6.30.6-cfs-fair_sl_disabled: 8249.17
> 
> 2.6.30.6-cfs-fair_sl_enabled: 4894.99

Wow.

Some loads like wakeup preemption (mysql+oltp), and some hate it.  This
load appears to REALLY hate it (as does volanomark, but that thing is
extremely overloaded).  How many threads does that benchmark run
concurrently?

In any case, it's currently disabled in tip.  Time will tell which
benchmarks gain, and which lose.  With it disabled, anything light loses
when competing with hog(s).  There _are_ one heck of a lot of hogs out
there though, so maybe it _should_ be disabled by default.  Dunno.

	-Mike

