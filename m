Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZGJUIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZGJUIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZGJUIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:08:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbZGJUIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:08:23 -0400
Date: Fri, 10 Jul 2009 13:07:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] dma-debug: Fix the overlap() function to be correct and
 readable
In-Reply-To: <20090710195157.GA31361@elte.hu>
Message-ID: <alpine.LFD.2.01.0907101306000.3352@localhost.localdomain>
References: <20090710162848.GA26862@elte.hu> <alpine.LFD.2.01.0907101206120.3352@localhost.localdomain> <20090710193110.GA28281@elte.hu> <20090710195157.GA31361@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Jul 2009, Ingo Molnar wrote:
> 
> How about the patch below? Lightly tested.
>  
>  	if (!PageHighMem(page)) {
> -		void *addr = ((char *)page_address(page)) + offset;
> +		void *addr = (void *)page_address(page) + offset;
> +

Why is that 'void *' cast there? page_address() is already a void *.

Other than that it obviously looks good to me. But I never see my own 
bugs.

		Linus
