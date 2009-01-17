Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbZASNZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbZASNZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbZASNYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:24:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58954 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759850AbZASNYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:24:32 -0500
Date: Sat, 17 Jan 2009 18:08:04 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] ftrace interface for blktrace
Message-ID: <20090117200804.GJ6562@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20090116181611.GE6562@ghostprotocols.net> <20090117190913.GA17722@elte.hu> <20090117191430.GA30821@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117191430.GA30821@kernel.dk>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 17, 2009 at 08:14:30PM +0100, Jens Axboe escreveu:
> On Sat, Jan 17 2009, Ingo Molnar wrote:
> > 
> > * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > 
> > > Hi Jens,
> > > 
> > > 	The patch below adds a ftrace interface for blktrace, allowing 
> > > people to use it without any required userspace tools, using sysfs to 
> > > setup the act_mask, pid, start_lba, end_lba.
> > 
> > Very nice patch!
> > 
> > Jens, i'm wondering what's your take on this direction is. I think the 
> > consolidation effect is great and the built-in IO tracing capabilities are 
> > very nice.
> 
> I like the current patch, from a quick look. I'll look more soonish
> (monday). I've always liked the concept of being able to mix various
> traces into the same stream, since it makes it MUCH easier to see what
> on earth is going wrong. What I didn't like in the patches Acme did was
> the enable part, I'll need to look into that. Again, from a quick look,
> what is the BKL doing in there?!

I'm just trying to keep locking expectations in the previous, similar
path, in block/ioctl.c, blkdev_ioctl, where we setup q->blk_trace:

        case BLKTRACESTART:
        case BLKTRACESTOP:
        case BLKTRACESETUP:
        case BLKTRACETEARDOWN:
                lock_kernel();
                ret = blk_trace_ioctl(bdev, cmd, (char __user *) arg);
                unlock_kernel();
                break;

So I took the safest path and grabbed the big K lock.
 
> > We can still get the raw events too and do user-space post-processing, 
> > when that is desired - so this does not limit anything that blktrace was 
> > able to do before - it only extends on it.
> > 
> > Is there any particular blktrace feature you can think of that is not 
> > present in the blktrace ftrace plugin?
> 
> Can't answer that yet, I'll give it a more thorough look next week.

Looking forward to that. And will get it split into multiple patches,
hopefully by monday.

- Arnaldo
