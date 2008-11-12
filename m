Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbYKLTsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbYKLTsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 14:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYKLTs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 14:48:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35887 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636AbYKLTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 14:48:29 -0500
Date: Wed, 12 Nov 2008 11:48:24 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Add PR_PREFIX to pr_xyz macros.
In-Reply-To: <1226511327.23498.3.camel@localhost>
Message-ID: <alpine.LFD.2.00.0811121144400.3468@nehalem.linux-foundation.org>
References: <1226511327.23498.3.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 12 Nov 2008, Martin Schwidefsky wrote:
>
> +#ifndef PR_PREFIX
> +#define pr_fmt(format) format 
> +#else
> +#define pr_fmt(format) PR_PREFIX ": " format
> +#endif
> +
> +#define pr_emerg(fmt, ...) \
> +        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)

So, why can't people just define their pr_fmt() macro directly, something 
like

	#define pr_fmt(fmt) \
		"%s:%d " fmt, __FILE__, __LINE__

which seems to be much more useful and generic than forcing them to use 
"PR_PREFIX"?

			Linus
