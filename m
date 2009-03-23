Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbZCWTeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbZCWTeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941AbZCWTdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:33:54 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:56300 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZCWTdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h+4ExCqBjfhd+kCfdMe380uFQ5i4eUcD5dkshXOaoGQvyvVaTIeHHz/82cjEs4t/1B
         +YrTHbdH8IVLGBKmyhwis+ITn3Ng5MtVGZ9yYDQw/jHb0564PD3Q+R5xrI7RK2iHEOWe
         u7cfPCbmZwermUsUBGaN4Y52zVehhmPIZ1IO8=
Date: Mon, 23 Mar 2009 20:33:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/filters] tracing/events: don't use wake up for
	events
Message-ID: <20090323193345.GD5988@nowhere>
References: <1237759847-21025-4-git-send-email-fweisbec@gmail.com> <tip-07edf7121374609709ef1b0889f6e7b8d6a62ec1@git.kernel.org> <alpine.DEB.2.00.0903231520330.3578@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903231520330.3578@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 03:21:55PM -0400, Steven Rostedt wrote:
> 
> On Mon, 23 Mar 2009, Frederic Weisbecker wrote:
> > tracing/events: don't use wake up for events
> > 
> > Impact: fix hard-lockup with sched switch events
> > 
> > Some ftrace events, such as sched wakeup, can be traced
> > while the runqueue lock is hold. Since they are using
> > trace_current_buffer_unlock_commit(), they call wake_up()
> > which can try to grab the runqueue lock too, resulting in
> > a deadlock.
> > 
> > Now for all event, we call a new helper:
> > trace_nowake_buffer_unlock_commit() which do pretty the same than
> 
> Ug, that's an ugly name. It should at least be:
> 
>   trace_buffer_unlock_commit_nowake
> 
> to be more in line with kernel conventions. That is where the derivitive
> has the same name as the original, like preempt_enable_noresched.
> 
> -- Steve


Indeed.

I scratched my head the evening long to find a name that could mean:
trace_current_buffer_unlock_commit_nowake()  ;-)

I think my headache brought me to this silly trace_nowake....

I will fix the name.
Thanks.

> 
> > trace_current_buffer_unlock_commit() except than it doesn't call
> > trace_wake_up().
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > LKML-Reference: <1237759847-21025-4-git-send-email-fweisbec@gmail.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > 

