Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbZHFOXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbZHFOXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZHFOXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:23:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56904 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZHFOXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:23:53 -0400
Date: Thu, 6 Aug 2009 10:23:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <f.weisbecker@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] tracing/filters: Support specifying filter hook to
 a TRACE_EVENT field
In-Reply-To: <4A7A72BD.5030201@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0908061022490.9870@gandalf.stny.rr.com>
References: <4A7A72BD.5030201@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 6 Aug 2009, Li Zefan wrote:

> Currently only static strings and dynamic strings have their
> own filter functions, other types of field are treated as
> integers.
> 
> This patchset allows assigning a specific filter type to a
> field, so a field which is defined as:
> 
> 	__field_ext(const char *, str, FILTER_PTR_STR)
> 
> will be treated as a string but not a plain pointer, and then
> we can set the filter like this:
> 
> 	# echo 'str == foo' > filter
> 
> And it's easy to add more filter functions for different types
> to turn these into valid operations:
> 
> 	(dev is of type dev_t)
> 	# echo 'dev == 8:0' > filter
> 
> 	(callsite is of type void * or unsigned long)
> 	# echo 'callsite == skb_free' > filter
> 
> [PATCH 1/3] tracing/filters: Add filter_type to struct ftrace_event_field
> [PATCH 2/3] tracing/filters: Add __field_ext() to TRACE_EVENT
> [PATCH 3/3] tracing/filters: Support filtering for char * strings

I like the first two patches, but would like to see a V2 with the updates 
I've mentioned. The last patch I do not fully understand its purpose.

I'll wait for V2 to pull it in.

Thanks!

-- Steve


> ---
>  include/linux/ftrace_event.h       |   12 +++++++-
>  include/trace/ftrace.h             |   28 ++++++++++++++++----
>  kernel/trace/trace.h               |    2 +
>  kernel/trace/trace_events.c        |    9 ++++++-
>  kernel/trace/trace_events_filter.c |   47 +++++++++++++++++++++++++----------
>  kernel/trace/trace_export.c        |    7 +++--
>  6 files changed, 79 insertions(+), 26 deletions(-)
> 
> 
