Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYGMLzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYGMLzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 07:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904AbYGMLzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 07:55:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:43848 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbYGMLzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 07:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kV4HP5CpRskzcDIR7KFv/xfPc8kDNdyXwNBTCcuU17ZJtVyYvexnNK1EzYCR3xZxYz
         rzWqcMJLYA05pY9sWouW3nFGHKIZkFXe/NnOdEhGIyEV2joUQZDwKQErnQ6C5g0RJTuj
         y7grPXKipTk0lzcavxPy1utPY+o3z3o/+4hpA=
Message-ID: <19f34abd0807130455w516d73cfi80161c345564464@mail.gmail.com>
Date: Sun, 13 Jul 2008 13:55:22 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: per-cpu related?
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Mike Travis" <travis@sgi.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <86802c440807130116u3b850485jec220bc15892873e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440807130116u3b850485jec220bc15892873e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 13, 2008 at 10:16 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> calling  pcie_portdrv_init+0x0/0x77
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff802557de>] hrtick_start_fair+0x8e/0x178
> PGD 0
> Oops: 0000 [1] SMP
> CPU 4
> Modules linked in:
> Pid: 103, comm: events/4 Not tainted 2.6.26-rc9-tip-01834-g99e624f-dirty #354
> RIP: 0010:[<ffffffff802557de>]  [<ffffffff802557de>]
> hrtick_start_fair+0x8e/0x178

I find that this corresponds to timer->base being NULL:

static inline int hrtimer_is_hres_active(struct hrtimer *timer)
{
        return timer->base->cpu_base->hres_active;
}

Apparently timer->base can legitimately be NULL in some cases:

/*
 * [...]
 * When the timer's base is locked, and the timer removed from list, it is
 * possible to set timer->base = NULL and drop the lock: the timer remains
 * locked.
 */

I don't know any more than this yet, I hope I didn't waste your time.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
