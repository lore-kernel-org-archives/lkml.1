Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667Ab0AYLpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0AYLpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 06:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596Ab0AYLpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 06:45:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:53616 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752128Ab0AYLpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 06:45:18 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19rfcYFMQhrNVo7Aaeq3vcvQFQ8EfRBgMmR2ZurAt
	R/iKxl1genRbiL
Subject: Re: netperf ~50% regression with 2.6.33-rc1, bisect to 1b9508f
From: Mike Galbraith <efault@gmx.de>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264419342.5888.42.camel@marge.simson.net>
References: <1264413826.3642.88.camel@minggr.sh.intel.com>
	 <1264419342.5888.42.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 25 Jan 2010 12:45:13 +0100
Message-Id: <1264419913.5888.49.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.70999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 12:35 +0100, Mike Galbraith wrote:

> So.  Rummaging around doing absolutely _nothing_ useful, there being
> zero movable tasks in this load, prevents us switching to the idle
> thread before the scheduling task is requeued.  Oh joy.

Wait a minute.  The only way that can work is if we hit contended lock,
and drop our rq lock (and where would busiest->nr_running > 1 come from
with a 2 task load?)

Puzzled.

	-Mike

