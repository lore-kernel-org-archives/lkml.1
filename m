Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbZAHUul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbZAHUul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZAHUuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:50:32 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:55528 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZAHUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:50:32 -0500
Message-ID: <496666CE.3050205@caviumnetworks.com>
Date: Thu, 08 Jan 2009 12:49:18 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] cpumask fallout: Initialize irq_default_affinity earlier.
References: <1231446081-8448-1-git-send-email-ddaney@caviumnetworks.com> <alpine.LFD.2.00.0901081227360.3283@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901081227360.3283@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2009 20:49:18.0545 (UTC) FILETIME=[9351C410:01C971D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
[...]
> In fact, I think it already is a no-op in the UP case, and you can 
> literally just do
> 
> 	static inline void __init init_irq_default_affinity(void)
> 	{
> 	 	alloc_cpumask_var(&irq_default_affinity, GFP_KERNEL);
> 	 	cpumask_setall(irq_default_affinity);
> 	}
> 
> and be done with it. I think it should all compile away to nothing if 
> CONFIG_SMP isn't set.

The 'inline' seems gratuitous to me.  Since it is static GCC should do 
the Right Thing.  However since you suggested it, I am testing it that way.

David Daney
