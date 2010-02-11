Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab0BKVoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:44:12 -0500
Received: from smtp-out.google.com ([216.239.33.17]:46732 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab0BKVoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:44:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=aVI3XuPFIKyNIpGlcF2T1FQPtPysbLJEZ5is+TKP3v2c8YiWh3bTs8kLtseYXqnYs
	EMWwhDeLDtUN4RpihjHkg==
Date: Thu, 11 Feb 2010 13:44:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       haicheng.li@intel.com
Subject: Re: [PATCH] [2/4] SLAB: Separate node initialization into separate
 function
In-Reply-To: <20100211205402.02E7EB1978@basil.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002111341590.8809@chino.kir.corp.google.com>
References: <20100211953.850854588@firstfloor.org> <20100211205402.02E7EB1978@basil.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Andi Kleen wrote:

> Index: linux-2.6.32-memhotadd/mm/slab.c
> ===================================================================
> --- linux-2.6.32-memhotadd.orig/mm/slab.c
> +++ linux-2.6.32-memhotadd/mm/slab.c
> @@ -1158,19 +1158,9 @@ free_array_cache:
>  	}
>  }
>  
> -static int __cpuinit cpuup_prepare(long cpu)
> +static int slab_node_prepare(int node)

I still think this deserves a comment saying that slab_node_prepare() 
requires cache_chain_mutex, I'm not sure people interested in node hotadd 
would be concerned with whether the implementation needs to iterate slab 
caches or not.

Otherwise:

Acked-by: David Rientjes <rientjes@google.com>
