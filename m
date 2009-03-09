Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZCIIlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZCIIlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbZCIIll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:41:41 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:56049 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbZCIIlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=d3UlOpqluGMZ0VcYp//Jnt8RGlfLeuQUihgDSaNBmxHQR7+ZQioADnMoE9eqPX04Gu
         Ql6HDQCzJnzTcdZUeEl5Yr+oMqUB4vFio5G/PiJW664jV7Tf1B5POiXihA6rgII9KEbm
         KiSXQNdp/3MbbUj2seGQ/qlvvT3zgWednc7MQ=
Date: Mon, 9 Mar 2009 09:41:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [TIP,BISECTED] Negative nice values have become big positive
	numbers
Message-ID: <20090309084132.GA5914@nowhere>
References: <20090308231850.GB24445@silver.sucs.org> <alpine.DEB.2.00.0903081944470.2203@gandalf.stny.rr.com> <20090309070824.GA9516@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309070824.GA9516@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 08:08:24AM +0100, Ingo Molnar wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Sun, 8 Mar 2009, Sitsofe Wheeler wrote:
> > 
> > > (Forgot to cc lkml. Resending...)
> > > 
> > > Formally negative nice values have started become very big in positive
> > > integers in -tip kernels:
> > > 
> > >     2 root      15 2147483647     0    0    0 S  0.0  0.0   0:00.00 kthreadd    
> > 
> > Is this the output of top?
> 
> seems so.
> 
> > > I've just finished bisecting down to this commit:
> > > 
> > > commit 1427cdf0592368bdec57276edaf714040ee8744f
> > > Author: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > Date:   Fri Mar 6 17:21:47 2009 +0100
> > 
> > $ git show 1427cdf0592368bdec57276edaf714040ee8744f  | diffstat
> >  include/linux/ftrace.h       |    3 +
> >  kernel/trace/Kconfig         |    6 ++
> >  kernel/trace/Makefile        |    1 
> >  kernel/trace/trace.c         |   56 +++++++++++++++++++++++++++
> >  kernel/trace/trace.h         |   12 +++++
> >  kernel/trace/trace_bprintk.c |   87 
> > +++++++++++++++++++++++++++++++++++++++++++
> >  kernel/trace/trace_output.c  |   75 +++++++++++++++++++++++++++++++++++++
> >  7 files changed, 240 insertions(+)
> > 
> > I find it hard to believe that this would cause normal nice 
> > values to be messed up. The only file that could could come 
> > close to messing with nice values in top is ftrace.h:
> 
> Correct - maybe it's these two nearby commits that cause the 
> problems:
> 
>  fef20d9: vsprintf: unify the format decoding layer for its 3 users
>  4370aa4: vsprintf: add binary printf
> 
> they do affect generic code. If we broke vsnprintf (which the 
> nice value output code uses) then that might be a plausible 
> explanation.
> 
> 	Ingo


Thanks for this report Sitsofe. I have some ideas about the origin of this bug.
Anyway I'm in the middle of moving to another town. There are very good chances
that I send a fix tomorrow but not today.

Thanks.

