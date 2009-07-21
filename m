Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbZGUBVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbZGUBVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZGUBVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:21:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33540 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZGUBVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:21:21 -0400
Date: Mon, 20 Jul 2009 21:21:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] tracing: use defined fields to print formats
In-Reply-To: <4A651545.60000@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0907202116350.17909@gandalf.stny.rr.com>
References: <4A5F38F9.7060002@cn.fujitsu.com> <alpine.DEB.2.00.0907201319190.7595@gandalf.stny.rr.com> <4A651545.60000@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Jul 2009, Lai Jiangshan wrote:
> 
> There're 4 differences:
> 
> 1) the type of "common_type" is changed.
> It's brought by a bug `__common_field(int, type, 1);`
> It'll be fixed.
> 
> 2) Type Item[Len] ==> Type[Len] Item.
> (There are the same, )But it can't not be recovered as before.
> Because it's brought by `trace_define_field(event_call, #type "[" #len "]", #item,`
> I'll fix trace-cmd and make it supports these two style together.

I'll wait for your next patch and see if I can take a crack at getting it
back to the old way.

> 
> 3) double quotation marks for the format is missing.
> It'll be fixed.
> 
> 4) a line in events/ftrace/print/format is missing.
> It'll be fixed.
> 
> At the end(fixed patch), the only change is "Type Item[Len] ==> Type[Len] Item".
> 
> The values of this patch are:
> 1) A big function ftrace_format_##call() is defined for every event type.
> it waste a lot of memory. this patch saves these memory.

I agree.

> 
> 2) reduce coupling: ftrace_format_##call() and
> ftrace_define_fields_##call() are almost the same.
> We need to maintain them together, it's not good design.

I agree.

> 
> The difference between ftrace_format_##call() and
> ftrace_define_fields_##call() implies a bug.
> 
> Example: `__common_field(int, type, 1);` in
> ftrace_define_fields_##call() is a bug.

The problem is that this will not make it until 32, and 31 already has the 
type item[x] format. Which means tools will be expecting it that way. We 
can make the tools handle both, but I would really like to prevent that.

I totally agree that your patch is a nice clean up, and saves space and 
prevents more bugs. On the other hand, we are changing an API to users 
where all tools that parse this must be able to cope.

I'll wait for your next patch and see if I can't pull something out of my 
CPP magic hat that can save the day ;-)

-- Steve

