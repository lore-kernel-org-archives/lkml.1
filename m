Return-Path: <linux-kernel-owner+w=401wt.eu-S1761613AbXHHKCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761613AbXHHKCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 06:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbXHHKCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 06:02:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:42451 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbXHHKCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 06:02:03 -0400
From: Andi Kleen <ak@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 4/25] [PATCH] Add debugreg/load_rsp native hooks
Date: Wed, 8 Aug 2007 11:16:41 +0200
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       Steven Rostedt <rostedt@goodmis.org>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com>
In-Reply-To: <11865467702103-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081116.43237.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>
> @@ -264,13 +270,64 @@ struct thread_struct {
>  	set_fs(USER_DS);							 \
>  } while(0)
>
> -#define get_debugreg(var, register)				\
> -		__asm__("movq %%db" #register ", %0"		\
> -			:"=r" (var))
> -#define set_debugreg(value, register)			\
> -		__asm__("movq %0,%%db" #register		\
> -			: /* no output */			\
> -			:"r" (value))
> +static inline unsigned long native_get_debugreg(int regno)
> +{
> +	unsigned long val;

It would be better to have own functions for each debug register I think

-Andi
