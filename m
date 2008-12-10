Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbYLJUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbYLJUMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 15:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbYLJUME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 15:12:04 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:55374 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbYLJUMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 15:12:03 -0500
Date: Wed, 10 Dec 2008 14:11:23 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] Do not pass the SLAB flags as GFP in slob kmem_cache_create
In-Reply-To: <20081210193421.GA2215@localhost>
Message-ID: <Pine.LNX.4.64.0812101411020.15262@quilx.com>
References: <20081210173632.19697.67688.stgit@pc1117.cambridge.arm.com>
 <20081210193421.GA2215@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008, Cyrill Gorcunov wrote:

> this would make the following line in slob_alloc
>
> 	...
> 	if (unlikely((gfp & __GFP_ZERO) && b))
> 		memset(b, 0, size);
>  	...
>
> useless. Not sure if it will be good :)

No. GFP_ZERO is set when kmalloc etc is called. Its not set on
kmem_cache_create.

