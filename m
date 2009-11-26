Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbZKZOJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbZKZOJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZKZOJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:09:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:56523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZKZOJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:09:19 -0500
Subject: Re: [patch] sched: fix set_task_cpu() and provide an unlocked
 runqueue variant
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259230578.15079.12.camel@marge.simson.net>
References: <1258891781.14325.34.camel@marge.simson.net>
	 <1259173672.4027.732.camel@laptop>
	 <1259197270.6186.17.camel@marge.simson.net>
	 <1259199068.6186.33.camel@marge.simson.net> <1259228139.4273.6.camel@twins>
	 <1259230578.15079.12.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 15:09:23 +0100
Message-ID: <1259244563.31676.53.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 11:16 +0100, Mike Galbraith wrote:
> > min_vruntime should only ever be poked at when holding the respective
> > rq->lock, even with a barrier a 64bit read on a 32bit machine can go all
> > funny.
> 
> Yeah, but we're looking at an unlocked runqueue.  But never mind...

The patch is also poking at rq->clock without rq->lock held... not very
nice.

Gah, I hate that we're doing migration things without holding both rq's,
this is making live so very interesting ;-)

