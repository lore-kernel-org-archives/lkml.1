Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbXJAUfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbXJAUfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:35:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXJAUfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:35:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59310 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751447AbXJAUe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:34:59 -0400
Date: Mon, 1 Oct 2007 13:34:58 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [Patch / 002](memory hotplug) Callback function to create
 kmem_cache_node.
In-Reply-To: <20071001183316.7A9B.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0710011334090.19779@schroedinger.engr.sgi.com>
References: <20071001182329.7A97.Y-GOTO@jp.fujitsu.com>
 <20071001183316.7A9B.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Yasunori Goto wrote:

> +#ifdef CONFIG_MEMORY_HOTPLUG
> +static void __slab_callback_offline(int nid)
> +{
> +	struct kmem_cache_node *n;
> +	struct kmem_cache *s;
> +
> +	list_for_each_entry(s, &slab_caches, list) {
> +		if (s->node[nid]) {
> +			n = get_node(s, nid);
> +			s->node[nid] = NULL;
> +			kmem_cache_free(kmalloc_caches, n);
> +		}
> +	}
> +}

I think we need to bug here if there are still objects on the node that 
are in use. This will silently discard the objects.

