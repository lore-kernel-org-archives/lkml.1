Return-Path: <linux-kernel-owner+w=401wt.eu-S932736AbZC0AVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbZC0AVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932953AbZC0AVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:21:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59997 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759451AbZC0AVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:21:15 -0400
Message-ID: <49CC1C0D.1000901@cn.fujitsu.com>
Date: Fri, 27 Mar 2009 08:21:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] blktrace: fix the original blktrace
References: <49C9F700.9070609@cn.fujitsu.com> <49C9F796.9040503@cn.fujitsu.com> <20090325101451.GK2341@elte.hu> <20090325101747.GL27476@kernel.dk> <49CAE4CB.3050000@cn.fujitsu.com> <20090326082939.GF27476@kernel.dk> <20090326133732.GA14822@elte.hu> <20090326151403.GH10928@ghostprotocols.net> <20090326154431.GG27476@kernel.dk>
In-Reply-To: <20090326154431.GG27476@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Yeah. Li, Arnaldo, what do you think?
>>>
>>> Delaying them would be quite painful at this stage though - the 
>>> blktrace plugin conversion was done with (ahem) your initial support 
>>> so the commits got (foolishly, in hindsight ;-) interwoven into 300 
>>> commits of the 2.6.30 tracing tree.
>>>
>>> Delaying them would also be technically baseless - there are no 
>>> known regressions or bugs in this code. (If you know about bugs then 
>>> please speak up so we can fix them! ;-)
>>>

I do know some bugs. ;)

>>> At this last minute stage we can do two things: merge it now or if 
>>> you NAK it then we'll rebase the last ~2 months of the tracing tree 
>>> with hundreds of commits (sigh), destroy its true history in the 
>>> process and eradicate the blktrace bits.
>>>
>>> I'd like to avoid the second option if possible as it destroys real 
>>> value (these changes are really nice improvements, a lot of work 
>>> went into them and there's no open regressions so i can see no 
>>> objective reason why they couldnt go upstream now) but it's your 
>>> choice really, you maintain block/* :-)
>> Well, after this set of fixes by Li the only problem I'm aware of is the
>> __trace_note_message, that is using ftrace_vprintk, that I didn't notice

This was the first issue I saw when I started to use blktrace in -tip tree,
and I made a fix yesterday. I'll post it soon, with some other fixes.

>> because I wasn't using CFQ when developing it, and that gets the output
>> of the _ftrace_ plugin wedged, but that doesn't affect normal blktrace
>> operation.
>>
>> I'll try to get that fixed somehow today, other than that I'm not aware
>> of any other problem, so I think it could get into 2.6.30 on the premise
>> that normal blktrace operation is as stable as before and that the
>> ftrace plugin is recent work and may still need some fixes.
> 
> Well, judging whether it is as stable as before is exactly what is asked
> of you and Li :-). So which is it?
> 

With the fixes I posted and will post, both ioctl-based blktrace and ftrace
-based blktrace should be working fine, and I'll continue to use and test
it.
