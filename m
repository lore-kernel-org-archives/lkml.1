Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZANKQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZANKQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbZANKPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:15:07 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:49807 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753981AbZANKPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:15:05 -0500
Message-ID: <496DBB25.9040101@rsk.demon.co.uk>
Date: Wed, 14 Jan 2009 10:15:01 +0000
From: richard kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: kzalloc mod->ref
References: <20090114033533.GL25103@bombadil.infradead.org>
In-Reply-To: <20090114033533.GL25103@bombadil.infradead.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> From: Kyle McMartin <kyle@redhat.com>
> 
> Dynamically allocate mod->ref instead of fixing it in the struct module.
> Reduces on disk space wasted in the module .ko, and kills a loop
> initializing the local_t it contains since we can just kzalloc it.
> 
> This matters when we're talking about large NR_CPUS.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> ---
> The patch removing cacheline_aligned from struct module_ref should be
> applied as well to cut down on the amount of memory we allocate. This
> patch makes a nice stopgap until we have per_cpu module references.
> 
> cheers, Kyle
> 
Hi Kyle,

As module_get/ put use module_ref as a per_cpu variable won't removing
the cacheline_aligned be a performance hit due to cacheline sharing on
machines with reasonable or small number of cpus?

(some of the network code seems to call module_get/put a lot!)

regards
Richard
