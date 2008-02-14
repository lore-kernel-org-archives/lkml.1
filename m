Return-Path: <linux-kernel-owner+w=401wt.eu-S933218AbYBNBby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218AbYBNBby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbYBNBbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:31:44 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:37082 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756018AbYBNBbn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:31:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FABsps0dMQWYv/2dsb2JhbACBWax1
Date: Wed, 13 Feb 2008 20:26:41 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@kernel.org>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fix module_update_markers() compile error
Message-ID: <20080214012641.GA29304@Krystal>
References: <20080214010851.GI12383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080214010851.GI12383@cs181133002.pp.htv.fi>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:25:53 up 2 days, 21:26,  3 users,  load average: 0.02, 0.13,
	0.24
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> This patch fixes the following compile error with CONFIG_MODULES=n 
> caused by commit fb40bd78b0f91b274879cf5db8facd1e04b6052e:
> 
> <--  snip  -->
> 
> ...
>   CC      kernel/marker.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/marker.c: In function ‘marker_update_probes’:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/marker.c:627: error: too few arguments to function ‘module_update_markers’
> make[2]: *** [kernel/marker.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Thanks for spotting this.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
> 8d811a4160c6e2cb92391076e0e0b500e1b4a8a2 diff --git a/include/linux/module.h b/include/linux/module.h
> index 330bec0..819c4e8 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -567,8 +567,7 @@ static inline void print_modules(void)
>  {
>  }
>  
> -static inline void module_update_markers(struct module *probe_module,
> -		int *refcount)
> +static inline void module_update_markers(void)
>  {
>  }
>  
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
