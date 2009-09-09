Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbZIICCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbZIICCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZIICCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:02:39 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33690 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZIICCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:02:39 -0400
To: rostedt@goodmis.org
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <4AA70198.9070500@cn.fujitsu.com> <4AA701B3.704@cn.fujitsu.com>
	<m1pra0hppp.fsf@fess.ebiederm.org>
	<1252460366.11070.2.camel@gandalf.stny.rr.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Sep 2009 19:02:37 -0700
In-Reply-To: <1252460366.11070.2.camel@gandalf.stny.rr.com> (Steven Rostedt's message of "Tue\, 08 Sep 2009 21\:39\:26 -0400")
Message-ID: <m163bsho3m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: rostedt@goodmis.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu, lizf@cn.fujitsu.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;rostedt@goodmis.org
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 2/2] tracing/events: Add kexec tracepoints
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Tue, 2009-09-08 at 18:27 -0700, Eric W. Biederman wrote:
>> Li Zefan <lizf@cn.fujitsu.com> writes:
>> 
>> > When panic, save in ring buffer the time when crash happened,
>> > the panic message, etc. And the data can be retrieved from
>> > core dump file using flight-recorder, which is going to be a
>> > module of the crash utility.
>> >
>> > Also if we implement flight-recorder in perf tool, those trace
>> > outputs can be used by perf tool.
>> 
>> Please let's keep dynamic code out of crash_kexec if we can.
>
> What dynamic code? It's a tracepoint not something like the function
> tracer. It is activated via a bit test and a jmp. Not very dynamic.

The philosophy of the crash dump code is that the kernel is broken
trust as little as possible.

Within a few seconds we should be able to get the time from the kernel
that saves the crash dump so I don't see how adding a trace point
adds anything into that code path except an unnecessary dependency
that might have broken.

Or in short you have a full user space to add features to.  Please
don't features to the critical kernel magic that gets you to userspace.

Eric

