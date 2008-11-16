Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYKPPB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYKPPB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYKPPBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:01:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYKPPBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:01:49 -0500
Date: Sun, 16 Nov 2008 10:01:46 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: walimis <walimisdev@gmail.com>, linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH 1/1] ftrace: fix wrong pos computing when read buffer
 has been fulfilled.
In-Reply-To: <20081116073354.GF19646@elte.hu>
Message-ID: <alpine.DEB.1.10.0811160959520.2919@gandalf.stny.rr.com>
References: <1226733546-23190-1-git-send-email-walimisdev@gmail.com> <20081116073354.GF19646@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 16 Nov 2008, Ingo Molnar wrote:
> * walimis <walimisdev@gmail.com> wrote:
> 
> > hi Steven,
> > 
> > Could you help me to review this patch?
> > 
> > Thanks.
> > 
> > Impact: make output of available_filter_functions complete
> > 
> > phenomenon:
> > 
> > The first value of dyn_ftrace_total_info is not equal with
> > `cat available_filter_functions | wc -l`, but they should be equal.
> > 
> > root cause:
> > 
> > When printing functions with seq_printf in t_show, if the read 
> > buffer is just overflowed by current function record, then this 
> > function won't be printed to user space through read buffer, it will 
> > just be dropped. So we can't see this function printing. So, every 
> > time the last function to fill the read buffer, if overflowed, will 
> > be dropped. This also applies to set_ftrace_filter if 
> > set_ftrace_filter has more bytes than read buffer.
> > 
> > fix:
> > 
> > Through checking return value of seq_printf, if less than 0, we know 
> > this function doesn't be printed. Then we decrease position to force 
> > this function to be printed next time, in next read buffer.
> > 
> > another little fix is to show correct allocating pages count.
> > 
> > Signed-off-by: walimis <walimisdev@gmail.com>
> > ---
> >  kernel/trace/ftrace.c |   26 +++++++++++++++-----------
> >  1 files changed, 15 insertions(+), 11 deletions(-)
> 
> looks sane - applied to tip/tracing/urgent. Steve, any objections?

I'm actually still reviewing it. I was busy with the PPC work, so I did 
not finish my review. Weekends are family time, so my activity now is 
minimal. Pull it in, and if I find any problems with it, I'll just submit 
a patch on top, or have walimis fix it ;-)

-- Steve

