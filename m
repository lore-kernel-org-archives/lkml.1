Return-Path: <linux-kernel-owner+w=401wt.eu-S1161140AbXCVWLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161140AbXCVWLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161142AbXCVWLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:11:06 -0400
Received: from graphe.net ([209.204.138.32]:44968 "EHLO graphe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161140AbXCVWLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:11:05 -0400
Date: Thu, 22 Mar 2007 15:10:29 -0700 (PDT)
From: Christoph Lameter <christoph@lameter.com>
X-X-Sender: christoph@graphe.net
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: non-NUMA cache_free_alien() (was Re: [RFC] SLAB : NUMA
 cache_free_alien() very expensive because of virt_to_slab(objp); nodeid =
 slabp->nodeid;)
In-Reply-To: <20070322212831.GA25665@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0703221510080.9678@graphe.net>
References: <20070320181235.77d28864.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org>
 <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org>
 <Pine.LNX.4.64.0703202006230.20568@graphe.net> <20070322212831.GA25665@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007, Siddha, Suresh B wrote:

> @@ -1394,6 +1394,9 @@ void __init kmem_cache_init(void)
>  	int order;
>  	int node;
>  
> +	if (num_online_nodes() == 1)
> +		use_alien_caches = 0;
> +

What happens if you bring up a second node?

