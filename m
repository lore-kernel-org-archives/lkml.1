Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbZIICds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbZIICds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZIICdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:33:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34772 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZIICdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:33:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: rostedt@goodmis.org
Subject: Re: [PATCH 1/2] tracing: Add sysctl to enable/disable tracing on oops
Cc: kosaki.motohiro@jp.fujitsu.com, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1252461867.11070.6.camel@gandalf.stny.rr.com>
References: <4AA7092C.4070706@cn.fujitsu.com> <1252461867.11070.6.camel@gandalf.stny.rr.com>
Message-Id: <20090909113231.0CE6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Sep 2009 11:33:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2009-09-09 at 09:47 +0800, Li Zefan wrote:
> > Steven Rostedt wrote:
> > > On Wed, 2009-09-09 at 09:37 +0800, Li Zefan wrote:
> > >> Steven Rostedt wrote:
> > >>> On Wed, 2009-09-09 at 09:15 +0800, Li Zefan wrote:
> > >>>> Currently we always disable tracing on oops, and this patch
> > >>>> adds a sysctl so one can choose to enable it.
> > >>> Hmm, we already have a way to enable it.
> > >>>
> > >>> # echo 1 > /debug/tracing/tracing_on
> > >>>
> > >> What I want is a way to not disable it when an oops happened. :)
> > >>
> > > 
> > > Ah, I misunderstood. May I ask a silly question?
> > > 
> > > Why?
> > > 
> > 
> > Otherwise we won't get trace output from trae_crash_kexec if
> > crash_kexec() is not called by panic(). For example:
> > 
> >   oops_begin()
> > ->trace_off()
> > ->panic_on_oops
> > ->kexec_should_crash()
> > ->crash_kexec()
> 
> OK, but I'm not exactly sure what you final goal is here. To have a
> something to search for in the ring buffer after the crash? Maybe
> instead we can add a "trace_oops" event? Just put it before the
> tracing_off call.

I have another silly question.
Why should we call tracing_off() in oops_enter()?

1. Oops behavior depend on panic_on_oops sysctl.
   Should we disable trace both case?
2. Can I think the code treat to save oops in tracing code?
   or it have more deeper intention?


Can anyone please explain it?




