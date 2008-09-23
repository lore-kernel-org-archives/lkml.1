Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbYIWPYD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbYIWPYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:24:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYIWPXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:23:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYIWPXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:23:52 -0400
Message-ID: <48D90970.3060409@redhat.com>
Date: Tue, 23 Sep 2008 11:21:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <20080923232239.DC1E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080923232239.DC1E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Motohiro,

KOSAKI Motohiro wrote:
>> By the way, systemtap uses two modes;
>>
>> - single-channel mode
>>  In this mode, all cpus share one buffer channel to write and read.
>>  each writer locks spinlock and write a probe-local data to buffer.
>>
>> - per-cpu buffer mode
>>  In this mode, we use an atomic sequential number for ordering data. If
>>  user doesn't need it(because they have their own timestamps), they can
>>  choose not to use that seq-number.
> 
> I can't imazine a merit of the single-channel mode.
> Could you please explain it?

Actually, single-channel mode is for not-frequently event tracing.
At least systemtap case, sometimes we just want to collect data
and watch it periodically(as like as 'top'). Or, just monitoring
errors as additional printk. in these cases, overhead is not so
important.

I think the main reason of using single-channel mode is simplicity of
userspace reader. We can use 'cat' or 'tail' to read the buffer on-line.
I'm not sure how much overhead ftrace-like buffer merging routine has,
but if kernel provides an interface which gives us single-merged buffer
image(like ftrace buffer), we are grad to use it. :-)

> Because some architecture don't have fine grained timestamp?
> if so, could you explain which architecture don't have it?

I heard that get_cycles always returns 0 on some cpu (ARM, MIPS, etc)...
(I think some of their platforms support variants of get_cycles)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

