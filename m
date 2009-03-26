Return-Path: <linux-kernel-owner+w=401wt.eu-S1760047AbZCZRHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047AbZCZRHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbZCZRHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:07:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42800 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648AbZCZRHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:07:37 -0400
Date: Thu, 26 Mar 2009 14:07:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] blktrace: fix the original blktrace
Message-ID: <20090326170715.GC25771@ghostprotocols.net>
References: <49C9F700.9070609@cn.fujitsu.com> <49C9F796.9040503@cn.fujitsu.com> <20090325101451.GK2341@elte.hu> <20090325101747.GL27476@kernel.dk> <49CAE4CB.3050000@cn.fujitsu.com> <20090326082939.GF27476@kernel.dk> <20090326133732.GA14822@elte.hu> <20090326151403.GH10928@ghostprotocols.net> <20090326154431.GG27476@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326154431.GG27476@kernel.dk>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Mar 26, 2009 at 04:44:31PM +0100, Jens Axboe escreveu:
> On Thu, Mar 26 2009, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Mar 26, 2009 at 02:37:32PM +0100, Ingo Molnar escreveu:
> > > 
> > > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > > One is introduced by "block: get rid of the manual directory counting in blktrace"
> > > > > (f48fc4d32e24c0b6a18aad30305d819bcc68c049). Two are "blktrace: port to tracepoints"
> > > > > (5f3ea37c7716db4e894a480e0c18b24399595b6b). Both commits are in mainline.
> > > > > 
> > > > > Since 2 of the bugs will rarely happen in real-life, and the 3rd 
> > > > > one is a small issue, and we were so close to the release of 
> > > > > .29, so I sent the fixes for -tip tree but not mainline. But if 
> > > > > we are going merge tip/blktrace to .31, I guess it's better to 
> > > > > merge that 3 fixes to .30?
> > > > 
> > > > Since you are the person that worked on it most lately, your 
> > > > opinion matters the most. What do you think, is it ready for 
> > > > 2.6.30 or should it wait for .31?
> > > 
> > > Yeah. Li, Arnaldo, what do you think?
> > > 
> > > Delaying them would be quite painful at this stage though - the 
> > > blktrace plugin conversion was done with (ahem) your initial support 
> > > so the commits got (foolishly, in hindsight ;-) interwoven into 300 
> > > commits of the 2.6.30 tracing tree.
> > > 
> > > Delaying them would also be technically baseless - there are no 
> > > known regressions or bugs in this code. (If you know about bugs then 
> > > please speak up so we can fix them! ;-)
> > > 
> > > At this last minute stage we can do two things: merge it now or if 
> > > you NAK it then we'll rebase the last ~2 months of the tracing tree 
> > > with hundreds of commits (sigh), destroy its true history in the 
> > > process and eradicate the blktrace bits.
> > > 
> > > I'd like to avoid the second option if possible as it destroys real 
> > > value (these changes are really nice improvements, a lot of work 
> > > went into them and there's no open regressions so i can see no 
> > > objective reason why they couldnt go upstream now) but it's your 
> > > choice really, you maintain block/* :-)
> > 
> > Well, after this set of fixes by Li the only problem I'm aware of is the
> > __trace_note_message, that is using ftrace_vprintk, that I didn't notice
> > because I wasn't using CFQ when developing it, and that gets the output
> > of the _ftrace_ plugin wedged, but that doesn't affect normal blktrace
> > operation.
> > 
> > I'll try to get that fixed somehow today, other than that I'm not aware
> > of any other problem, so I think it could get into 2.6.30 on the premise
> > that normal blktrace operation is as stable as before and that the
> > ftrace plugin is recent work and may still need some fixes.
> 
> Well, judging whether it is as stable as before is exactly what is asked
> of you and Li :-). So which is it?

I just checked out the latest linux-tip tree and will do some tests,
checking the work that Li did and will try various sequences such as
first using ftrace then blktrace, the reverse, trying to do both, trying
to parse the trace_pipe with blkparse -, etc on a 4way Xeon machine and
will report here the results.

- Arnaldo
