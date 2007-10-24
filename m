Return-Path: <linux-kernel-owner+w=401wt.eu-S1759815AbXJXOoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759815AbXJXOoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXJXOo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:44:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628AbXJXOo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:44:28 -0400
Date: Wed, 24 Oct 2007 07:43:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, bunk@kernel.org
Subject: Re: [PATCH] Define smp_call_function_mask() on uniprocessor builds
Message-Id: <20071024074354.9edd4cee.akpm@linux-foundation.org>
In-Reply-To: <11932158852325-git-send-email-avi@qumranet.com>
References: <11932158852325-git-send-email-avi@qumranet.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 10:51:25 +0200 Avi Kivity <avi@qumranet.com> wrote:

> Rather than #ifdef users of smp_call_function_mask(), define it as an
> empty macro to avoid build errors.  The function explicitly prohibits
> callers from specifying the current cpu, so nothing needs to be done.
> 
> This unbreaks uniprocessor KVM builds.
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>
> 
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index 259a13c..24e2e31 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -108,6 +108,9 @@ static inline void smp_send_reschedule(int cpu) { }
>  	0;			\
>  })
>  
> +#define smp_call_function_mask(mask, func, info, wait) \
> +	do { (void)(mask); (void)(func); (void)(info); (void)(wait); } while (0)
> +
>  #endif /* !SMP */
>  
>  /*

The real smp_call_function_mask() returns int, so this version should do so
also.

An inlined C function will provide the needed references to the arguments -
no need for those funny (void) thingies.  And it will provide typechecking.


