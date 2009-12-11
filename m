Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbZLKK33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbZLKK33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 05:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756365AbZLKK31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 05:29:27 -0500
Received: from mail.gmx.net ([213.165.64.20]:36096 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755392AbZLKK31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 05:29:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/MgVQkW+vM/UZ4cWS+fX7Hk9bIdT7cKo4uu+WQ/f
	A/V5olvkAvpR2U
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200912111124.18118.kernel@kolivas.org>
References: <200912111124.18118.kernel@kolivas.org>
Content-Type: text/plain
Date: Fri, 11 Dec 2009 11:29:30 +0100
Message-Id: <1260527370.6126.53.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 11:24 +1100, Con Kolivas wrote:

> When choosing an idle CPU for a waking task, the cache locality is determined
> according to where the task last ran and then idle CPUs are ranked from best
> to worst to choose the most suitable idle CPU based on cache locality, NUMA
> node locality and hyperthread sibling business.

The affinity logic still seems to want some loving.  Everything I've
tested that is cache sensitive suffers pretty heavily.

FWIW, mysql+oltp is a nice repeatable affinity testcase.  tbench is
another.  Throughput for both under BFS 311 here are still consistent
with the cost of pairs landing cross-cache on a regular basis.  I'm no
fan of vmark, but it's also highly cache sensitive, and is sensitive to
overly enthusiastic wakeup preemption as well, so is useful to keep an
eye on both (otherwise, 800 threads on 4 cores is silly imho).  Vmark
does not enjoy the BFS experience (understatement squared).

	-Mike

