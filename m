Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZD1JZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZD1JZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZD1JZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:25:10 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:65053 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbZD1JZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:25:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=a7uVuMlSoBxDIY1wCCBo6KuHqLEw3i1sUagANGBddbk8cVe3a2LGyT56F/aKhXHyq9
         5h12MWXJTawEY4JinzRxm3gVXs3kBC7owWnxC43KxXA/T90+6dHPKCOV2BVUxIpiHQG0
         eqVqhnu+BzbmYtZgefX2rh1E1dHYcNSJnuGL4=
MIME-Version: 1.0
In-Reply-To: <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com>
References: <20090428010907.912554629@intel.com>
	 <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu>
	 <20090428074031.GK27382@one.firstfloor.org>
	 <1240909484.1982.16.camel@penberg-laptop>
	 <20090428091508.GA21085@elte.hu>
	 <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com>
Date: Tue, 28 Apr 2009 12:25:06 +0300
X-Google-Sender-Auth: d7436f7223628c81
Message-ID: <84144f020904280225h490ef682p8973cb1241a1f3ea@mail.gmail.com>
Subject: Re: [PATCH 5/5] proc: export more page flags in /proc/kpageflags
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 09:40 +0200, Andi Kleen wrote:
>>> > > I think i have to NAK this kind of ad-hoc instrumentation of kernel
>>> > > internals and statistics until we clear up why such instrumentation

* Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>> > I think because it has zero fast path overhead and can be used
>>> > any time without enabling anything special.
>
> On Tue, Apr 28, 2009 at 12:15 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> ( That's a dubious claim in any case - tracepoints are very cheap.
>>  And they could be made even cheaper and such efforts would benefit
>>  all the tracepoint users so it's a prime focus of interest.
>>  Andi is a SystemTap proponent, right? I saw him oppose pretty much
>>  everything built-in kernel tracing related. I consider that a
>>  pretty extreme position. )

On Tue, Apr 28, 2009 at 12:19 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> I have no idea how expensive tracepoints are but I suspect they don't
> make too much sense for this particular scenario. After all, kmemtrace
> is mainly interested in _allocation patterns_ whereas this patch seems
> to be more interested in "memory layout" type of things.

That said, I do foresee a need to be able to turn on more detailed
tracing after you've identified problematic areas from kpageflags type
of overview report. And for that, you almost certainly want
kmemtrace/tracepoints style solution with pid/function/whatever regexp
matching ftrace already provides.

                        Pekka
