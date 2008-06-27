Return-Path: <linux-kernel-owner+w=401wt.eu-S1764108AbYF0Wrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764108AbYF0Wrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 18:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbYF0Wrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 18:47:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbYF0Wri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 18:47:38 -0400
Message-ID: <48656D9A.8000602@redhat.com>
Date: Fri, 27 Jun 2008 18:45:46 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal> <486403F0.4020801@redhat.com> <20080627131442.GA13751@Krystal>
In-Reply-To: <20080627131442.GA13751@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Hi Mathieu,
>>
>> Thank you for making this so soon!
>>
> 
> Hi Masami,
> 
> Thanks for the comments, I will rework the patch accordingly.
> 
> Also, one thing I thought about yesterday which I dislike is that if we
> have two modules declaring the same tracepoint in different headers with
> different prototypes, each declaration will be valid but the
> registration will try to connect a probe expecting wrong parameters to
> the other tracepoint.
> 
> It would be the case if someone does :
> 
> drivers/somedrivera/mydriver1-trace.h
> 
> DECLARE_TRACE(really_generic_name, TPPTOTO(void), TPARGS()));
> 
> 
> drivers/somedriverb/mydriver2-trace.h
> 
> DECLARE_TRACE(really_generic_name, TPPTOTO(struct somestruct *s), TPARGS(s)));
> 
> Do you think it's worth it to append the prototype string to the
> tracepoint name ? I think it should fix the problem.

Hmm, I think we'd better send a fix patch to them in that case.
(I hope we can find that kind of conflicts soon)
I think we can make an external tool which detect those conflicts.
Anyway, signature based checking idea is good to me. I think ":" is
better delimiter.


Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

