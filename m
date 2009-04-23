Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbZDWWPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbZDWWPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759888AbZDWWPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:15:25 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:60481 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560AbZDWWPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=nAkwJFPKIA6t0FmijwuChqd7KKv+7u00++YiY8jXEDv4VWA3kxpbEz72n/nvnD4WET
         8rY2cZqoTQRUh0fgrOmppLKKJ28TwXlzXUQ5rTUnyxY+7b8uFStoqMTsT91A3ekbOVlZ
         XLaq5U1rLVYPyKkoA3B4AftsFYvwDdFcWyinI=
Date: Fri, 24 Apr 2009 00:15:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Uwe =?utf-8?B?77+9?= <u.kleine-koenig@pengutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] Add function graph tracer support for ARM
Message-ID: <20090423221516.GB5976@nowhere>
References: <49F0AEA2.5010309@am.sony.com> <20090423183905.GA8383@pengutronix.de> <49F0E284.2080104@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49F0E284.2080104@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 02:49:56PM -0700, Tim Bird wrote:
> Uwe � wrote:
> >> Signed-off-by: <tim.bird@am.sony.com>
> > According to Documentation/SubmittingPatches you need to provide your
> > real name in the S-o-b line.
> 
> OK -that's embarrassing - I'll fix this.
> scripts/checkpatch.pl didn't catch this.  I may look at adding
> something to checkpatch.pl to catch empty names.
> 
> > For the lazy of us, can you point me^Uus to some documentation how to
> > use the graph tracer?
> 
> It looks like Documentation/ftrace.txt is missing anything about
> function graph tracing.
> 
> Should I add a section?



There is already a section in Documentation/frace.txt as well in 2.6.30 :-)



> 
> Here are some quick steps:
> 
> $ mount -t debugfs none /debug
> $ cd /debug/tracing/
> $ cat available_tracers
> function_graph function sched_switch nop
> $ echo function_graph >current_tracer
> $ cat trace
> # tracer: function_graph
> #
> # CPU OVERHEAD/DURATION            FUNCTION CALLS
> # |   |        |                   |   |   |   |
>  ------------------------------------------
>  0)      --1       =>   events/-5
>  ------------------------------------------
> 
>  0)               |                activate_task() {
>  0)               |                  enqueue_task() {
>  0)               |                    enqueue_task_fair() {
>  0)               |                      update_curr() {
>  0)   0.000 us    |                        calc_delta_mine();
>  0)   0.000 us    |                        update_min_vruntime();
>  0) + 61.035 us   |                      }
>  0)   0.000 us    |                      place_entity();
>  0)   0.000 us    |                      __enqueue_entity();
>  0) + 91.552 us   |                    }
>  0) ! 122.070 us  |                  }
>  0) ! 152.588 us  |                }
>  0)               |                check_preempt_wakeup() {
>  0)   0.000 us    |                  update_curr();
>  0)   0.000 us    |                  wakeup_preempt_entity();
>  0) + 61.035 us   |                }
> 
> Clearly, my clock stinks, but that's a separate issue.


Oh, that's the first function graph trace from Arm I can see.
/me feels a bit moved...

Just one childish caprice...it would be nice to see a part of a
trace which shows specific Arm arch functions in the next changelog :-)


Thanks,
Frederic.

