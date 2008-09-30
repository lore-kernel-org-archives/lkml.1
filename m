Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbYI3Dls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbYI3Dls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYI3Dlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:41:40 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:59256 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbYI3Dlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:41:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEACM94UhMQWq+/2dsb2JhbACBZLlzgWc
Date: Mon, 29 Sep 2008 23:41:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: let marker_debug as module parameter
Message-ID: <20080930034137.GB12733@Krystal>
References: <48E19CE8.8070006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48E19CE8.8070006@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:40:12 up 117 days,  8:20, 10 users,  load average: 5.03, 2.70,
	1.40
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> 
> if we want to enable marker debug output, we have to modify
> the code and remake/reinstall the kernel in current code.
> 
> this patch enable marker_debug to be set when kernel start.
> 

Given it's only called at probe registration/unregistration and never
put in the critical path of an executed marker, it makes sense to make
this a kernel arg debug option. I like this patch :)

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/marker.c b/kernel/marker.c
> index 9f76c4a..5d8404f 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -28,8 +28,9 @@
>  extern struct marker __start___markers[];
>  extern struct marker __stop___markers[];
>  
> -/* Set to 1 to enable marker debug output */
> -static const int marker_debug;
> +static int marker_debug;
> +module_param(marker_debug, bool, 0);
> +MODULE_PARM_DESC(marker_debug, "Set to 1 to enable marker debug output");
>  
>  /*
>   * markers_mutex nests inside module_mutex. Markers mutex protects the builtin
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
