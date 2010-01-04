Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309Ab0ADLOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0ADLOn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 06:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345Ab0ADLOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 06:14:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:46715 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753320Ab0ADLOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 06:14:39 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18yjYtB4NMyFbwZ+kyxbdGBO7V74HoXGa0fYdYn72
	cFqELgvZPKq9Jo
Subject: Re: [RFC][PATCH] sched: avoid huge bonus to sleepers on busy
 machines
From: Mike Galbraith <efault@gmx.de>
To: Suresh Jayaraman <sjayaraman@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1262596842-17392-1-git-send-email-sjayaraman@suse.de>
References: <1262596842-17392-1-git-send-email-sjayaraman@suse.de>
Content-Type: text/plain
Date: Mon, 04 Jan 2010 12:14:35 +0100
Message-Id: <1262603675.9734.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 14:50 +0530, Suresh Jayaraman wrote:
> As I understand the idea of sleeper fairness is to consider sleeping tasks
> similar to the ones on the runqueue and credit the sleepers in a way that it
> would get CPU as if it were running.
> 
> Currently, when fair sleepers are enabled, the task that was sleeping seem to
> get a bonus of cfs_rq->min_vruntime - sched_latency (in most cases). While with
> gentle fair sleepers this effect was reduced to half, there still remains a
> chance that on busy machines with more number of tasks, the sleepers might get
> a huge undue bonus.

There is no bonus.  Sleepers simply get to keep some of their lag, but
any lag beyond sched_latency is trashed in the interest of reasonable
latency for non-sleepers as the sleeper preempts and tries to catch up.

	-Mike

