Return-Path: <linux-kernel-owner+w=401wt.eu-S1758483AbXKAH0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483AbXKAH0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 03:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbXKAH0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 03:26:15 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:38862 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbXKAH0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 03:26:13 -0400
Message-ID: <47297F83.9080300@cosmosbay.com>
Date: Thu, 01 Nov 2007 08:25:55 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 3/7] Allocpercpu: Do __percpu_disguise() only if CONFIG_DEBUG_VM
 is set
References: <20071101000211.970501947@sgi.com> <20071101000310.217429212@sgi.com>
In-Reply-To: <20071101000310.217429212@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [172.16.8.80]); Thu, 01 Nov 2007 08:26:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> Disguising costs a few cycles in the hot paths. So switch it off if
> we are not debuggin.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  include/linux/percpu.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6/include/linux/percpu.h
> ===================================================================
> --- linux-2.6.orig/include/linux/percpu.h	2007-10-31 16:40:14.892121256 -0700
> +++ linux-2.6/include/linux/percpu.h	2007-10-31 16:41:00.907621059 -0700
> @@ -33,7 +33,11 @@
>  
>  #ifdef CONFIG_SMP
>  
> +#ifdef CONFIG_DEBUG_VM
>  #define __percpu_disguise(pdata) ((void *)~(unsigned long)(pdata))
> +#else
> +#define __percpu_disguide(pdata) ((void *)(pdata))
> +#endif

Yes good idea, but a litle typo here :)
