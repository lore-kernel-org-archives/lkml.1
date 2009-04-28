Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbZD1LJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbZD1LJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZD1LJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:09:40 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:46083 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbZD1LJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:09:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=fRmX769u2PSXGT0d0BJitqa7kq+3qUgKZaE3BKpyp/Of+MowQtjJsIaIq7fwqkKkrw
         83KqOc3iOhWl2ByqtC2UvfXFlfGIwZWl2r+MkzYpJZJi+xCyYAhy2ncPrVeeA6CXWqAn
         VK7HKArbJuhE2f9nTFGxsEjeGrreIha8UVpt0=
MIME-Version: 1.0
In-Reply-To: <20090428105603.GB25347@elte.hu>
References: <20090428093621.GD21085@elte.hu>
	 <84144f020904280257j57b5b686k91cc4096a8e5ca29@mail.gmail.com>
	 <20090428190822.EBED.A69D9226@jp.fujitsu.com>
	 <84144f020904280321u4be9fb10t6f0123b589752b80@mail.gmail.com>
	 <20090428105603.GB25347@elte.hu>
Date: Tue, 28 Apr 2009 20:09:38 +0900
X-Google-Sender-Auth: 45ae0949b8f795ec
Message-ID: <2f11576a0904280409h4dedc04u43a5b68ef492e56d@mail.gmail.com>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-2022-JP?B?RnIbJEJxRXFTGyhCaWMgV2Vpc2JlY2tlcg==?= 
	<fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/28 Ingo Molnar <mingo@elte.hu>:
>
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
>> Hi!
>>
>> 2009/4/28 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>> >> I guess the main question here is whether this approach will scale to
>> >> something like kmalloc() or the page allocator in production
>> >> environments. For any serious workload, the frequency of events is
>> >> going to be pretty high.
>> >
>> > Immediate Values patch series makes zero-overhead to tracepoint
>> > while it's not used.
>> >
>> > So, We have to implement to stop collect stastics way. it restore
>> > zero overhead world.
>> > We don't lose any performance by trace.
>>
>> Sure but I meant the _enabled_ case here. kmalloc() (and the page
>> allocator to some extent) is very performance sensitive in many
>> workloads so you probably don't want to use tracepoints if you're
>> collecting some overall statistics (i.e. tracing all events) like
>> we do here.
>
> That's where 'collect current state' kind of tracepoints would help
> - they could be used even without enabling any of the other
> tracepoints. And they'd still be in a coherent whole with the
> dynamic-events tracepoints.
>
> So i'm not arguing against these techniques at all - and we can move
> on a wide scale from zero-overhead to lots-of-tracing-enabled models
> - what i'm arguing against is the splintering.

umm.
I guess Pekka and you talk about different thing.

if tracepoint is ON, tracepoint makes one function call. but few hot spot don't
have patience to one function call overhead.

scheduler stat and slab stat are one of good example, I think.

I really don't want convert slab_stat and sched_stat to ftrace base stastics.
currently it don't need extra function call and it only touch per-cpu variable.
So, a overhead is extream small.

Unfortunately, tracepoint still don't reach this extream performance.
