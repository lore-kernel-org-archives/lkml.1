Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbZD1J53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbZD1J53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZD1J5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:57:19 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:37297 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZD1J5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=REPaOmTdqDJJeUcez3kzmM6sqkp4THk/ZVO2dOI2TTWtHcRs/DvAipAsfmWHcqCvfw
         RDt4/ovkbbdedTRv0oqFtVz4mgdRo7Q0wsbU0ytHrccQ5n8abjKtt2b8Mh0pR5WtKECd
         o1l5McJkigDsUTL/k9C/40PYKVIxxPcGDTgRw=
MIME-Version: 1.0
In-Reply-To: <20090428093621.GD21085@elte.hu>
References: <20090428010907.912554629@intel.com>
	 <20090428014920.769723618@intel.com> <20090428065507.GA2024@elte.hu>
	 <20090428074031.GK27382@one.firstfloor.org>
	 <1240909484.1982.16.camel@penberg-laptop>
	 <20090428091508.GA21085@elte.hu>
	 <84144f020904280219p197d5ceag846ae9a80a76884e@mail.gmail.com>
	 <84144f020904280225h490ef682p8973cb1241a1f3ea@mail.gmail.com>
	 <20090428093621.GD21085@elte.hu>
Date: Tue, 28 Apr 2009 12:57:16 +0300
X-Google-Sender-Auth: c9c6a1668093f733
Message-ID: <84144f020904280257j57b5b686k91cc4096a8e5ca29@mail.gmail.com>
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

Hi Ingo,

On Tue, Apr 28, 2009 at 12:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> I 'integrate' traces all the time to get summary counts. This series
> of dynamic events:
>
>  allocation
>  page count up
>  page count up
>  page count down
>  page count up
>  page count up
>  page count up
>  page count up
>
> integrates into: "page count is 6".
>
> Note that "integration" can be done wholly in the kernel too,
> without going to the overhead of streaming all dynamic events to
> user-space, just to summarize data into counts, in-kernel. That is
> what the ftrace statistics framework and various ftrace plugins are
> about.
>
> Also, it might make sense to extend the framework with a series of
> 'get current object state' events when tracing is turned on. A
> special case of _that_ would in essence be what the /proc hack does
> now - just expressed in a much more generic, and a much more usable
> form.

I guess the main question here is whether this approach will scale to
something like kmalloc() or the page allocator in production
environments. For any serious workload, the frequency of events is
going to be pretty high.

                                            Pekka
