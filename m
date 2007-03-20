Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXCTH5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXCTH5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932440AbXCTH5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:57:43 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:48039 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbXCTH5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:57:42 -0400
Message-ID: <45FF93C8.4070602@cosmosbay.com>
Date: Tue, 20 Mar 2007 08:56:56 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       Christoph Lameter <clameter@sgi.com>, "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
References: <20070319141038.212d4ac9.akpm@linux-foundation.org>  <az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi>  <20070319144100.8a87f288.akpm@linux-foundation.org> <84144f020703200014j1ec8a6feq9828fd8739beff18@mail.gmail.com> <45FF8FB2.3060601@cosmosbay.com> <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 20 Mar 2007 08:57:05 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg a écrit :
> Thanks for the profile. I still wonder where exactly thouse super-hot 
> call-sites are...
> 

In this case, it's a typical network server

Each time a packet is sent to or received from network, network stack has to 
allocate/free a skb (kmem_cache_alloc()/kmem_cache_free() and its data 
(kmalloc/kfree)

Other paths are for example dentries allocations, file allocations, ... really 
  many spots for some workloads.

