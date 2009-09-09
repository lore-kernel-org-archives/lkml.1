Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZIICE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZIICE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbZIICE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:04:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35903 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZIICEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:04:25 -0400
Subject: Re: [PATCH 1/2] tracing: Add sysctl to enable/disable tracing on
 oops
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AA7092C.4070706@cn.fujitsu.com>
References: <4AA70198.9070500@cn.fujitsu.com>
	 <1252460079.11070.1.camel@gandalf.stny.rr.com>
	 <4AA706BE.1090204@cn.fujitsu.com>
	 <1252460523.11070.3.camel@gandalf.stny.rr.com>
	 <4AA7092C.4070706@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 08 Sep 2009 22:04:27 -0400
Message-Id: <1252461867.11070.6.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 09:47 +0800, Li Zefan wrote:
> Steven Rostedt wrote:
> > On Wed, 2009-09-09 at 09:37 +0800, Li Zefan wrote:
> >> Steven Rostedt wrote:
> >>> On Wed, 2009-09-09 at 09:15 +0800, Li Zefan wrote:
> >>>> Currently we always disable tracing on oops, and this patch
> >>>> adds a sysctl so one can choose to enable it.
> >>> Hmm, we already have a way to enable it.
> >>>
> >>> # echo 1 > /debug/tracing/tracing_on
> >>>
> >> What I want is a way to not disable it when an oops happened. :)
> >>
> > 
> > Ah, I misunderstood. May I ask a silly question?
> > 
> > Why?
> > 
> 
> Otherwise we won't get trace output from trae_crash_kexec if
> crash_kexec() is not called by panic(). For example:
> 
>   oops_begin()
> ->trace_off()
> ->panic_on_oops
> ->kexec_should_crash()
> ->crash_kexec()

OK, but I'm not exactly sure what you final goal is here. To have a
something to search for in the ring buffer after the crash? Maybe
instead we can add a "trace_oops" event? Just put it before the
tracing_off call.

-- Steve


