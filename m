Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYJZXLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYJZXLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 19:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbYJZXLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 19:11:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58959 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYJZXK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 19:10:59 -0400
Date: Sun, 26 Oct 2008 19:10:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] ftrace: Add a script to produce a hierarchical
 view of a function trace
In-Reply-To: <4904DF39.9070203@gmail.com>
Message-ID: <alpine.DEB.1.10.0810261903110.26269@gandalf.stny.rr.com>
References: <4904DF39.9070203@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Oct 2008, Frederic Weisbecker wrote:

> This script parses a function trace and then produces a hierarchical view of the 
> function call stack after processing it into a tree.
> 
> You can see the result on attachment. You will find the raw trace and the hierarchical view.

Very nice and useful tool!

Just one thing...

> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/scripts/draw_functrace.py b/scripts/draw_functrace.py
> new file mode 100755
> index 0000000..e6496bd
> --- /dev/null
> +++ b/scripts/draw_functrace.py
> @@ -0,0 +1,119 @@
> +#!/usr/bin/python
> +
> +"""
> +Copyright 2008 (c) Frederic Weisbecker <fweisbec@gmail.com>
> +Licensed under the terms of the GNU GPL License version 2
> +
> +This script parses a trace provided by the function tracer in
> +kernel/trace/trace_functions.c
> +The resulted trace is processed into a tree to produce a more human
> +view of the call stack by drawing textual but hierarchical tree of
> +calls. Only the functions's names and the the call time are provided.
> +
> +Usage:
> +	Be sure that you have CONFIG_FUNCTION_TRACER
> +	# mkdir /debugfs
> +	# mount -t debug debug /debug
> +	# echo function > /debug/tracing/current_tracer
> +	# cat /debug/tracing/current_tracer > ~/raw_trace_func

Do you really mean to write "function" into ~/raw_trace_func?

Also, I just tried this out (replacing current_tracer with trace) and I 
just get ---Root (Nowhere)

-- Steve

> +	Wait some times but not too much, the scripts is a bit slow.
> +	Break the pipe (Ctrl + Z)
> +	$ scripts/draw_functrace.py < raw_trace_func > draw_functrace
> +	Then you have your drawn trace in draw_functrace
> +"""
> +
