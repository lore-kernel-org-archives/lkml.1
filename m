Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbZDKJbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbZDKJbC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 05:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZDKJav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 05:30:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:47701 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbZDKJau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 05:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=T+VohbLz6p6xK+MoTEyP6Jc7Tq/HFQmmQxiqz22iKXGoXbNCsdGl1T6tYmmUxLVXsy
         rYPkxFgKtwBGDh9G43wv82t+HX8XwQbdFOUVLl78PYRrWrnm7Pj9YSETPxawC25TvnoJ
         0itJrXN+3lgxH/EvkcWq4vOnxltPKok/2I8dk=
Subject: Re: [PATCH 0/7] tracing: bug fixes for tracing/filters
From: Tom Zanussi <tzanussi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
In-Reply-To: <49E04C22.4040608@cn.fujitsu.com>
References: <49E04C22.4040608@cn.fujitsu.com>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 04:30:48 -0500
Message-Id: <1239442248.8793.65.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2009-04-11 at 15:52 +0800, Li Zefan wrote:
> This patchset fixes some bugs in tracing/filters. Most of the change
> goes to the last patch, and others are small ones.
> 

At first glance, they look good and fix real problems - thanks for
fixing them.  Re patch 7, there's been some discussion about using rcu
for this.  See:

http://lkml.org/lkml/2009/4/5/46

>From that discussion, it seems some non-trivial changes to rcu would be
needed for this.  I'm playing around with a different idea now to
hopefully avoid the need for that, or the other approach mentioned, of
temporarily stopping tracing while removing/changing the filters.

Basically my thought is to avoid the problem by not allocating or
destroying the preds when removing filters but instead switch out the
pred->fns with a nop version while keeping the fields intact for awhile.
I think that will work for removing filters, but I still need to think
about how it would (or would not) work for replacing them.
 
Tom

> Maybe 3rd to 6th patches can be regarded as small enhancements instead
> of bug fixes? But they are behavioural changes.
> 
> 
> [PATCH 1/7] tracing/filters: NUL-terminate user input filter
> [PATCH 2/7] tracing/filters: fix NULL pointer dereference
> [PATCH 3/7] tracing/filters: allow user input integer to be oct or hex
> [PATCH 4/7] tracing/filters: allow user to specify a filter val to be string
> [PATCH 5/7] tracing/filters: disallow newline as delimeter
> [PATCH 6/7] tracing/filters: return proper error code when writing filter file
> [PATCH 7/7] tracing/filters: make filter preds RCU safe
> 
>  kernel/trace/trace.h                |    6 +-
>  kernel/trace/trace_events.c         |   16 +++--
>  kernel/trace/trace_events_filter.c  |  131 ++++++++++++++++++++++++++---------
>  kernel/trace/trace_events_stage_3.h |   10 +++-
>  4 files changed, 121 insertions(+), 42 deletions(-)
> ---

