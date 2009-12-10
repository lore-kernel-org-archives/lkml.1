Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbZLJWhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbZLJWhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761998AbZLJWhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:37:42 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:56125 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761989AbZLJWhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:37:41 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz1432R98dNzz1202hz4fhzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B217803.6080407@am.sony.com>
Date: Thu, 10 Dec 2009 14:36:51 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "Bird, Tim" <Timothy.Bird@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>	 <4B216478.3080601@am.sony.com> <1260482698.2146.234.camel@gandalf.stny.rr.com>
In-Reply-To: <1260482698.2146.234.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2009 22:36:52.0725 (UTC) FILETIME=[451B7A50:01CA79E9]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
>> I'm a little worried about this.  ftrace is already an order
>> of magnitude more overhead than the previous tracer I was using.
> 
> Which tracer was that? I know you used the -finstrument-functions for
> tracing before, and that has quite a bit overhead as well. The ring
> buffer has gone through a lot to speed it up.

KFT.  It used -finstrument-functions, which did result in
a few more instructions per call site than mcount does.  However,
the code paths in KFT are much shorter than in ftrace.
And the fact that both function exit and entry are instrumented
meant that I didn't have to do funky trampoline junk, or
manage a separate structure, in order to capture function
exit events.

It is somewhat to be expected that ftrace would have higher
overhead, because ftrace does more. But in the version
of code I was using (which is probably quite old), there
was lots of extraneous code in the hot path.
For example, there are at least 4 checks in the code
to detect whether tracing is active or not.

The ring buffer code was particularly slow.  I was using
a simple fixed-size array in KFT (on a uniprocessor), and
the time to save an event was under 1 microsecond.  With
ftrace on the same hardware, it costs about 6 microseconds
to save an event.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

