Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbXJJRjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbXJJRjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 13:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbXJJRje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 13:39:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56368 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754724AbXJJRjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 13:39:33 -0400
Date: Wed, 10 Oct 2007 10:39:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH -mm] slub: fix cpu hotplug offline/online path
In-Reply-To: <20071010121853.GA3911@APFDCB5C>
Message-ID: <Pine.LNX.4.64.0710101037210.7158@schroedinger.engr.sgi.com>
References: <20071009161328.GA6470@APFDCB5C>
 <Pine.LNX.4.64.0710091144020.32162@schroedinger.engr.sgi.com>
 <20071010121853.GA3911@APFDCB5C>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007, Akinobu Mita wrote:

> I couldn't use get_cpu_slab() for that check. But I reviced the patch to do
> what you said.

Why would get_cpu_slab not work?

> +	if (per_cpu(kmem_cache_cpu_free, cpu)) {
> +		/* Already initialized once */
> +		return;
> +	}
> +

kmem_cache_cpu_free is not only NULL if the cpu is not up yet but it is 
also NULL if the per cpu pool of kmem_cache_cpu structures was 
exhausted.
