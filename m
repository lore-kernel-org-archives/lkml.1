Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbYKVSyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbYKVSyd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 13:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYKVSyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 13:54:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030AbYKVSyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 13:54:21 -0500
Date: Sat, 22 Nov 2008 10:53:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Miklos Szeredi <miklos@szeredi.hu>,
       arjan@linux.intel.com, torvalds@linux-foundation.org, hch@infradead.org,
       mingo@elte.hu, rminnich@sandia.gov, ericvh@gmail.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH fwd] poll: allow f_op->poll to sleep
Message-Id: <20081122105356.87856d04.akpm@linux-foundation.org>
In-Reply-To: <4927FE87.6050005@gmail.com>
References: <E1L3oK1-0001Pz-J9@pomaz-ex.szeredi.hu>
	<20081122123942.GF5707@parisc-linux.org>
	<4927FE87.6050005@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008 21:43:51 +0900 Tejun Heo <htejun@gmail.com> wrote:

> Matthew Wilcox wrote:
> > On Sat, Nov 22, 2008 at 09:58:33AM +0100, Miklos Szeredi wrote:
> >> +int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
> >> +			  ktime_t *expires, unsigned long slack)
> > 
> > All callers of poll_schedule() and poll_schedule_timeout() pass
> > TASK_INTERRUPTIBLE.  We can elide the 'state' argument.
> 
> Well, I wanted to keep it as to keep it more consistent with other
> schedule() functions but both Miklos and you don't seem to like it, so I
> might as well just drop it.  Andrew, what do you think?

I guess that if any poll/select syscall were to sleep in
uninterruptible state, people would get upset about the effect upon their
load average and we'd have to go in and fix it.

So, yup, I expect that hard-coding TASK_INTERRUPTIBLE would be OK.
