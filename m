Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYIVVB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYIVVB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYIVVBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:01:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbYIVVBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:01:48 -0400
Message-ID: <48D80508.6070002@redhat.com>
Date: Mon, 22 Sep 2008 16:50:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Martin Bligh <mbligh@google.com>, prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, od@novell.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hch@lst.de,
       David Wilder <dwilder@us.ibm.com>, zanussi@comcast.net
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>	 <1221869279.8359.31.camel@lappy.programming.kicks-ass.net>	 <20080922140740.GB5279@in.ibm.com>	 <1222094724.16700.11.camel@lappy.programming.kicks-ass.net>	 <33307c790809220929l32427a1as3d6d6bc08ce3173b@mail.gmail.com> <1222101401.16700.48.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1222101401.16700.48.camel@lappy.programming.kicks-ass.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-09-22 at 09:29 -0700, Martin Bligh wrote:
>>>> In conjunction with the previous email on this thread
>>>> (http://lkml.org/lkml/2008/9/22/160), may I suggest
>>>> the equivalent interfaces in -mm tree (2.6.27-rc5-mm1) to be:
>>>>
>>>> relay_printk(<some struct with default filenames/pathnames>, <string>,
>>>> ....) ;
>>>> relay_dump(<some struct with default filenames/pathnames>, <binary
>>>> data>);
>>>> and
>>>> relay_cleanup_all(<the struct name>); - Single interface that cleans up
>>>> all files/directories/output data created under a logical entity.
>>> Dude, relayfs is such a bad performing mess that extending it seems like
>>> a bad idea. Better to write something new and delete everything relayfs
>>> related.
>> There did seem to be pretty universal agreement that we'd rather not
>> use relayfs.
>>
>>> Also, it seems prudent to separate the ring-buffer implementation from
>>> the event encoding/decoding facilities.
>> Right - in conversation I had with Mathieu later, he suggested cleaning up
>> relayfs - I fear this will delay us far too long, and get bogged down.
>> If we can get one clean circular buffer implementation, then both
>> relayfs and the tracing could share that common solution,
> 
> Currently only blktrace and kvmtrace use relayfs, and I've heard people
> talk about converting both to use lttng/ftrace infrastructure. At which
> point relayfs is orphaned and ready for removal.

Hi Peter,
Systemtap is still a heavy user of relayfs. :-)
Anyway, if new buffering mechanism is enough for us, I think
we're happy to move on it.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

