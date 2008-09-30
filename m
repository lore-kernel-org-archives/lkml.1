Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbYI3D1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbYI3D1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYI3D1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:27:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64673 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYI3D1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:27:03 -0400
Message-ID: <48E1853A.5090001@cn.fujitsu.com>
Date: Tue, 30 Sep 2008 09:47:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH] Markers : marker_synchronize_unregister()
References: <48E08B05.7030802@cn.fujitsu.com> <20080929082722.GB18663@elte.hu> <20080929150513.GC11245@Krystal>
In-Reply-To: <20080929150513.GC11245@Krystal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Create marker_synchronize_unregister() which must be called before the end of
> exit() to make sure every probe callers have exited the non preemptible section
> and thus are not executing the probe code anymore.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: akpm@linux-foundation.org
> CC: "Frank Ch. Eigler" <fche@redhat.com>
> ---
>  include/linux/marker.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> Index: linux-2.6-lttng/include/linux/marker.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/marker.h	2008-07-31 09:12:52.000000000 -0400
> +++ linux-2.6-lttng/include/linux/marker.h	2008-07-31 09:19:31.000000000 -0400
> @@ -142,4 +142,11 @@ extern int marker_probe_unregister_priva
>  extern void *marker_get_private_data(const char *name, marker_probe_func *probe,
>  	int num);
>  
> +/*
> + * marker_synchronize_unregister must be called between the last marker probe
> + * unregistration and the end of module exit to make sure there is no caller
> + * executing a probe when it is freed.
> + */

marker_synchronize_unregister must be called _also_ between unregistration
and destruction the data that unregistration-ed probes need to make sure
there is no caller executing a probe when it's data is destroyed.



> +#define marker_synchronize_unregister() synchronize_sched()
> +
>  #endif


