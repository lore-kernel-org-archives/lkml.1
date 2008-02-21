Return-Path: <linux-kernel-owner+w=401wt.eu-S1765509AbYBULip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765509AbYBULip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760247AbYBULih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:38:37 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:56714 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001AbYBULig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:38:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALbxvEdMQWRV/2dsb2JhbACBWa4/
Date: Thu, 21 Feb 2008 06:38:34 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] markers: fix sparse warnings in markers.c
Message-ID: <20080221113834.GA13150@Krystal>
References: <1203578514.20345.2.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1203578514.20345.2.camel@brick>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 06:38:06 up 10 days,  7:38,  1 user,  load average: 0.45, 0.46,
	0.44
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Harvey Harrison (harvey.harrison@gmail.com) wrote:
> char can be unsigned
> kernel/marker.c:64:20: error: dubious one-bit signed bitfield
> kernel/marker.c:65:14: error: dubious one-bit signed bitfield
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Yep, it makes sense.

Thanks!

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
> Introduced between -rc1 and -rc2
>  kernel/marker.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/marker.c b/kernel/marker.c
> index c4c2cd8..50effc0 100644
> --- a/kernel/marker.c
> +++ b/kernel/marker.c
> @@ -61,8 +61,8 @@ struct marker_entry {
>  	int refcount;	/* Number of times armed. 0 if disarmed. */
>  	struct rcu_head rcu;
>  	void *oldptr;
> -	char rcu_pending:1;
> -	char ptype:1;
> +	unsigned char rcu_pending:1;
> +	unsigned char ptype:1;
>  	char name[0];	/* Contains name'\0'format'\0' */
>  };
>  
> -- 
> 1.5.4.2.200.g99e75
> 
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
