Return-Path: <linux-kernel-owner+w=401wt.eu-S964837AbZKYOIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964837AbZKYOIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934532AbZKYOIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:08:38 -0500
Received: from www.tglx.de ([62.245.132.106]:35377 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933562AbZKYOIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:08:37 -0500
Date: Wed, 25 Nov 2009 15:08:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Liuweni <qingshenlwy@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       xgr178 <xgr178@163.com>, strongzgy <strongzgy@gmail.com>,
       qingshenlwy <qingshenlwy@tom.com>, rusty <rusty@rustcorp.com.au>,
       travis <travis@sgi.com>, adobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH V2]irq/core: Add a length limitation
In-Reply-To: <200911252204173129580@gmail.com>
Message-ID: <alpine.LFD.2.00.0911251503400.24119@localhost.localdomain>
References: <200911252204173129580@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Nov 2009, Liuweni wrote:

>  ---
> In this version, I modify the code by Ingo's suggestion, 
> and less code add. 
> The code will check the irqaction->name's length 
> and avoid Using too long name without any notice.
>
> --- a/kernel/irq/proc.c
> +++ b/kernel/irq/proc.c
> @@ -196,6 +196,8 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
>  	char name [MAX_NAMELEN];
>  	struct irq_desc *desc = irq_to_desc(irq);
>  
> +	WARN_ON(strlen(action->name) < MAX_NAMELEN);
> +

This is going to warn on every action->name which is actually used in
the kernel except for the ones which are too long.

Thanks,

	tglx


