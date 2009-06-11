Return-Path: <linux-kernel-owner+w=401wt.eu-S1760665AbZFKP5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760665AbZFKP5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZFKP5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:57:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbZFKP5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:57:08 -0400
Date: Thu, 11 Jun 2009 08:56:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] init: introduce mm_init()
In-Reply-To: <Pine.LNX.4.64.0906111846590.16970@melkki.cs.Helsinki.FI>
Message-ID: <alpine.LFD.2.01.0906110854450.3573@localhost.localdomain>
References: <Pine.LNX.4.64.0906111846590.16970@melkki.cs.Helsinki.FI>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Pekka J Enberg wrote:
>  
> +static void __init mm_init(void)
> +{
> +	/*
> +	 * Set up kernel memory allocators
> +	 */
> +	mem_init();
> +	kmem_cache_init();
> +	vmalloc_init();
> +}

Please just put the comments at the top of the function in cases like 
this, ie just

	/*
	 * ...
	 */
	static int __init mm_init(void)
	{
		..
	}

also, I'm now terminally confused about the whole series, so I'm wondering 
if you could re-do the series so that (a) I have a clear picture of what 
to take, and (b) preferably so it's also all bisectable (ie the trap_init 
ordering fixes are done in the initial mm/init.c changes).

		Linus
