Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYLIWxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYLIWxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYLIWxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:53:23 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:44178 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753841AbYLIWxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:53:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsYEABOGPklMROB9/2dsb2JhbACBbM9rgwc
Date: Tue, 9 Dec 2008 17:53:21 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 29/31] markers: Make static
Message-ID: <20081209225321.GA6034@Krystal>
References: <493EA286.7080500@gmail.com> <493EEFB6.3080901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <493EEFB6.3080901@gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:49:36 up 22 days, 23:30,  3 users,  load average: 0.89, 0.61,
	0.58
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roel Kluin (roel.kluin@gmail.com) wrote:
> Sparse asked whether these could be static.
> 

Yes, I guess they should. But beware that when using trace_mark_tp()
helper within tracepoint probes, the probe functions should *not* be
made static. Making them static would make the compiler thing that
nobody is actually using them, which is false, because they are used
through the declaration made in the marker section. So we should be very
careful when turning probe functions to "static" that an external
reference to that function will be seen.

trace_mark_tp() is the only "weird" case I have seen so far.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  samples/markers/probe-example.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/samples/markers/probe-example.c b/samples/markers/probe-example.c
> index 2dfb3b3..d816aad 100644
> --- a/samples/markers/probe-example.c
> +++ b/samples/markers/probe-example.c
> @@ -20,7 +20,7 @@ struct probe_data {
>  	marker_probe_func *probe_func;
>  };
>  
> -void probe_subsystem_event(void *probe_data, void *call_data,
> +static void probe_subsystem_event(void *probe_data, void *call_data,
>  	const char *format, va_list *args)
>  {
>  	/* Declare args */
> @@ -37,9 +37,9 @@ void probe_subsystem_event(void *probe_data, void *call_data,
>  	/* or count, check rights, serialize data in a buffer */
>  }
>  
> -atomic_t eventb_count = ATOMIC_INIT(0);
> +static atomic_t eventb_count = ATOMIC_INIT(0);
>  
> -void probe_subsystem_eventb(void *probe_data, void *call_data,
> +static void probe_subsystem_eventb(void *probe_data, void *call_data,
>  	const char *format, va_list *args)
>  {
>  	/* Increment counter */
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
