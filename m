Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbZGVNOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbZGVNOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZGVNOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:14:23 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:4824 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZGVNOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:14:23 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_counter: Fix throttle/unthrottle event logging
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anton Blanchard <anton@samba.org>
Cc: mingo@elte.hu, paulus@samba.org, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090722130546.GE9029@kryten>
References: <20090722130546.GE9029@kryten>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 15:15:33 +0200
Message-Id: <1248268533.27058.1421.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 23:05 +1000, Anton Blanchard wrote:
> Right now we only print PERF_EVENT_THROTTLE + 1 (ie PERF_EVENT_UNTHROTTLE).
> Fix this to print both a throttle and unthrottle event.

oops, that was supposed to read: PERF_EVEN_THROTTLE + enable, but yeah,
the below works too. Thanks!

> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Index: linux.trees.git/kernel/perf_counter.c
> ===================================================================
> --- linux.trees.git.orig/kernel/perf_counter.c	2009-07-22 22:43:36.000000000 +1000
> +++ linux.trees.git/kernel/perf_counter.c	2009-07-22 22:55:10.000000000 +1000
> @@ -3195,7 +3195,7 @@ static void perf_log_throttle(struct per
>  		u64				stream_id;
>  	} throttle_event = {
>  		.header = {
> -			.type = PERF_EVENT_THROTTLE + 1,
> +			.type = PERF_EVENT_THROTTLE,
>  			.misc = 0,
>  			.size = sizeof(throttle_event),
>  		},
> @@ -3204,6 +3204,9 @@ static void perf_log_throttle(struct per
>  		.stream_id	= counter->id,
>  	};
>  
> +	if (enable)
> +		throttle_event.header.type = PERF_EVENT_UNTHROTTLE;
> +
>  	ret = perf_output_begin(&handle, counter, sizeof(throttle_event), 1, 0);
>  	if (ret)
>  		return;

