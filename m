Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbZCFANg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbZCFANg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 19:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZCFANX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 19:13:23 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:60986 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025AbZCFANW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 19:13:22 -0500
Message-ID: <49B06A60.5070107@oracle.com>
Date: Thu, 05 Mar 2009 16:12:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: mrubin@google.com, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       "H. Peter Anvin" <hpa@zytor.com>, md@google.com,
       Tom Zanussi <tzanussi@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, ltt-dev@lists.casi.polymtl.ca,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Martin Bligh <mbligh@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [RFC patch 29/41] LTTng menus
References: <20090305224728.947235917@polymtl.ca> <20090305225518.148142886@polymtl.ca> <49B061DA.1010908@oracle.com> <20090305234700.GA17212@Krystal> <49B0658D.1090706@oracle.com> <20090306000155.GA17881@Krystal>
In-Reply-To: <20090306000155.GA17881@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49B06A05.008B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>> Mathieu Desnoyers wrote:
>>> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
>>>> Mathieu Desnoyers wrote:
>>>>
>>>> <<attachment :(>>
>>>>
>>>>
>>>> +menuconfig LTT
>>>> +	bool "Linux Trace Toolkit Next Generation (LTTng)"
>>>> +	depends on EXPERIMENTAL
>>>> +	select MARKERS
>>>> +	select TRACEPOINTS
>>>> +	default y
>>>>
>>>> Not default 'y', please.
>>>>
>>> OK, so default n it is. But I plan to leave the main menu "sub-features" as
>>> default y, given that people get the standard features when they choose
>>> to enable the tracer. Hopefully this is ok ?
>> Sure, as long as it just enables viewing the menu and not adding
>> code to a growing kernel.
>>

I see what you mean now.  Thanks for the details.

> 
> I want to be sure to understand your point. Would be following be OK ?
> 
> Menu [ ] Linux Trace Toolkit Next Generation (LTTng)  --->  (default n)
> 
> Within this menu, the following options enable various tracer modules,
> some of which are typically needed, except in some very specific tracer
> use :
> 
> < >   Linux Trace Toolkit Lock-Protected Data Relay (default n)
>                (default y is planned to be used for the lockless data
>                relay module, which is not posted as part of this patchset)
> [ ]   Debug check for random access in ltt relay buffers (default n)
> <*>   Linux Trace Toolkit Serializer (default y)
> -*-   Linux Trace Toolkit Custom Serializer (default y)
> -*-   Linux Trace Toolkit Trace Controller (default m)
> <*>   Linux Trace Toolkit Tracer (default y)
> [ ]   Align Linux Trace Toolkit Traces (default n, selected of
>         !HAVE_EFFICIENT_UNALIGNED_ACCESS)
> [ ]   Add event size field to LTT events for tracer debugging (default n)
> <M>   Support logging events from userspace (default m)
> [*]   Support trace extraction from crash dump (default y)
> [*]   Linux Trace Toolkit Kprobes Support (default y)
> 
> I understand from your answer above that just enabling the "LTTng"
> submenu should not activate any of these items, am I correct ?

Ideally one wouldn't add bloat to the kernel, but if someone enables
the top-level menu item, I'm OK with enabling others under it.

(not that we all consider the same things to be bloat ;)

-- 
~Randy
