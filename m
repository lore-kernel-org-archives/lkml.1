Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZLWKx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZLWKx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbZLWKx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:53:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:53983 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbZLWKx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:53:27 -0500
Subject: Re: SCHED: Is task migration necessary in sched_exec().
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <b9df5fa10912230246w4adf160bibc12d7c6480ce058@mail.gmail.com>
References: <b9df5fa10912230214s3815c023g2a7e7ca152eb00e4@mail.gmail.com>
	 <1261563687.4937.120.camel@laptop>
	 <b9df5fa10912230246w4adf160bibc12d7c6480ce058@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 11:53:04 +0100
Message-ID: <1261565584.4937.124.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 16:46 +0600, Rakib Mullick wrote:
> On 12/23/09, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2009-12-23 at 16:14 +0600, Rakib Mullick wrote:
> >
> >
> > Well, if there's an imbalance the 'slow' load-balancer will move it
> >  around eventually anyway, and since it will then have build up a larger
> >  cache footprint it will be even more expensive.
> >
> If there is an imbalance - then the overloaded task will moved. 

There is no overloaded task, its the runqueue that is overloaded wrt to
other runqueues. The load-balancer has to pick a 'random' task and pray.
Current heuristics try to pick a task that hasn't been on the cpu for a
while, because for those the effective cache footprint is minimal.

> Why the _current_ task? 

Because at exec it has effective 0 cache footprint, and is thus an ideal
victim to move about.


