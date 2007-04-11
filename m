Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXDKCgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXDKCgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 22:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbXDKCgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 22:36:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:23109 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012AbXDKCgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 22:36:11 -0400
Date: Tue, 10 Apr 2007 19:37:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] markers-doc-update-flags-example
Message-Id: <20070410193757.650f84cc.randy.dunlap@oracle.com>
In-Reply-To: <20070410232620.GG7092@Krystal>
References: <20070410231126.GC7092@Krystal>
	<20070410232620.GG7092@Krystal>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 19:26:20 -0400 Mathieu Desnoyers wrote:


>  ------------------------------ CUT -------------------------------------
>  /* probe-example.c
>   *
> - * Loads a function at a marker call site.
> + * Connects a two functions to marker call sites.

s/a //

>   *
>   * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>   *
> @@ -109,67 +113,83 @@ Flag compatibility is checked before connecting the probe to the marker.
>  
>  #include <linux/sched.h>
>  #include <linux/kernel.h>
> +#include <linux/module.h>
>  #include <linux/marker.h>
> +#include <asm/atomic.h>
> +
> +#define NUM_PROBES (sizeof(probe_array) / sizeof(struct probe_data))

#define NUM_PROBES	ARRAY_SIZE(probe_array)


> -#define SUBSYSTEM_EVENT_FORMAT "%d %s %p[struct task_struct]"
> -void probe_subsystem_event(const char *format, ...)
> +struct probe_data {
> +	const char *name;
> +	const char *format;
> +	marker_probe_func *probe_func;
> +};
> +
>  
> +static struct probe_data probe_array[] =
> +{
> +	{	.name = "subsystem_event",
> +		.format = "%d %s",
> +		.probe_func = probe_subsystem_event },
> +	{	.name = "subsystem_eventb",
> +		.format = MARK_NOARGS,
> +		.probe_func = probe_subsystem_eventb },
> +};
> +

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
