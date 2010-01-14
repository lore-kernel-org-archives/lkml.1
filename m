Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790Ab0ANPCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0ANPCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:02:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898Ab0ANPCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:02:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:48083 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab0ANPC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:02:27 -0500
Message-ID: <4B4F31D4.1000707@windriver.com>
Date: Thu, 14 Jan 2010 09:01:40 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: linux-next: manual merge of the tip tree with the kgdb tree
References: <20100114161302.285ebe27.sfr@canb.auug.org.au> <20100114092600.GA13503@elte.hu>
In-Reply-To: <20100114092600.GA13503@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2010 15:01:44.0085 (UTC) FILETIME=[7C58F450:01CA952A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>   
>> Hi all,
>>
>> Today's linux-next merge of the tip tree got a conflict in
>> kernel/trace/trace.c between commit
>> d304af88a0105ff5b64cffc9108636ecad1fdd78 ("ftrace,kdb: Extend kdb to be
>> able to dump the ftrace buffer") from the kgdb tree and commit
>> 7e53bd42d14c75192b99674c40fcc359392da59d ("tracing: Consolidate
>> protection of reader access to the ring buffer") from the tip tree.
>>     
>
> Hm, Jason, what is that large commit to kernel/trace/ doing in the KGDB tree, 
> without any apparent acks from the affected people?
>   

I had been corresponding with Steven Rostedt directly.  This is actually
the 3rd iteration of the patch (the first two never got checked in
anywhere) and there is still an outstanding question, which I will
inline at the bottom of this email.  The ftdump patch is at the very end
of the kdb series, because this patch will get nuked if Steven or anyone
else has a problem with it.

As for what the patch does, it is routine for dumping the ftrace buffer
while in the kernel debugger context.

> I dont see it anywhere on lkml nor in my mbox. Please submit it to the 
> affected maintainers - for the Cc: line see the output of:
>   

The v2 version of the kdb  series was supposed to go out yesterday
morning (also known as kdb_prototype11).   The new patch is included in
the post, look for: "[PATCH 40/40] ftrace,kdb: Extend kdb to be able to
dump the ftrace buffer"

-- prior inlined correspondence --

Steven Rostedt wrote:

> > On Tue, 2010-01-05 at 23:57 -0600, Jason Wessel wrote:
>   
>> >> Here is another try at adding a dump function for kdb.  I had to
>> >> changes some of the static -> global scope in kernel/trace/trace.c in
>> >> order to be able to reference other semi-private via "trace.h".
>>     
> > 
> > Actually, could you write access functions instead. If we make these
> > items global in scope, then others will just start accessing them
> > directly. I've had this issue before because others have tried to make
> > the global_trace visible by all. But that variable may disappear and
> > break all that use it.
> > 
>   

Thanks for the insight.

Here is v3.

I added a function called trace_init_global_iter().  I'll rename it if
you like.  I also changed the ftrace_dump() to make use of it as well
so we are more likely to see an issue when it changes if there are
more consumers of the function.

The other question it brings up is if you want a helper function for
the atomic_inc / atomic_dec of the tracing cpus.  That would move that
for_each_tracing_cpu macro back into trace.c.

Thanks,
Jason.

[..patch clipped..]


