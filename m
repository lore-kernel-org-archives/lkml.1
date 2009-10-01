Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbZJAIrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbZJAIrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZJAIra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:47:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:57239 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbZJAIr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:47:29 -0400
Date: Thu, 1 Oct 2009 10:47:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       jeff@garzik.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed
	workqueue
Message-ID: <20091001084733.GO14918@kernel.dk>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <20091001084040.GA15345@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001084040.GA15345@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01 2009, Ingo Molnar wrote:
> My main worry is that in practice workqueues arent all that performance 
> critical - so we are shooting to optimize something that doesnt 
> necessarily use all the potential goodness inherent in this approach.

Well, the main problem with the current code is that per-cpu workqueues
are way abused. I don't look at this patchset from a performance point
of view, but rather a way to limit this huge number of idle and
pointless threads. Another issue are specific workqueues to deal with
slowly executing work, or dependency issues. The end result is just
hundreds of pointless kernel threads. I have two 64-thread boxes here, I
dare not think what the 128 or 256 thread (and even bigger) boxes look
like when booted. The latter would be safely into the thousands of
useless threads.

If we get this right, we'll have a leaner kernel and far fewer threads.
On the source side, we'll potentially get rid of specialized workqueue
akin implementations.

It's a win-win as far as I'm concerned.

-- 
Jens Axboe

