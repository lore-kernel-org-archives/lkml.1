Return-Path: <linux-kernel-owner+w=401wt.eu-S934067AbZJNOvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067AbZJNOvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 10:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933902AbZJNOvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 10:51:10 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:43813 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933501AbZJNOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 10:51:09 -0400
Date: Wed, 14 Oct 2009 10:38:35 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mingo@redhat.com,
       tglx@linutronix.de, akpm@linux-foundation.org, rostedt@goodmis.org,
       hpa@zytor.com, cebbert@redhat.com
Subject: Re: [PATCH 14/16] percpu: make access macros universal
In-Reply-To: <1255500125-3210-15-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.1.10.0910141037210.26476@gentwo.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-15-git-send-email-tj@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Tejun Heo wrote:

> @@ -182,17 +185,19 @@ static inline void *pcpu_lpage_remapped(void *kaddr)
>  #ifndef percpu_read
>  # define percpu_read(var)						\
>    ({									\
> -	typeof(var) __tmp_var__;					\
> -	__tmp_var__ = get_cpu_var(var);					\
> -	put_cpu_var(var);						\
> -	__tmp_var__;							\
> +	typeof(var) *pr_ptr__ = &(var);					\
> +	typeof(var) pr_ret__;						\
> +	pr_ret__ = get_cpu_var(*pr_ptr__);				\
> +	put_cpu_var(*pr_ptr__);						\
> +	pr_ret__;							\
>    })
>  #endif

== this_cpu_read(var) ?

