Return-Path: <linux-kernel-owner+w=401wt.eu-S1422660AbXBURxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422660AbXBURxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422668AbXBURxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:53:17 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40646 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422660AbXBURxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:53:16 -0500
Date: Wed, 21 Feb 2007 09:53:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
Subject: Re: [PATCH 1/3] slab: introduce krealloc
In-Reply-To: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0702210951580.24344@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Pekka J Enberg wrote:

> +void *krealloc(const void *p, size_t new_size, gfp_t flags)
> +{
> +	void *ret;
> +
> +	if (unlikely(!p))
> +		return kmalloc_track_caller(new_size, flags);
> +
> +	if (unlikely(!new_size)) {
> +		kfree(p);
> +		return NULL;
> +	}
> +
> +	ret = kmalloc_track_caller(new_size, flags);
> +	if (!ret)
> +		return NULL;
> +
> +	memcpy(ret, p, min(new_size, ksize(p)));
> +	kfree(p);
> +	return ret;
> +}
> +EXPORT_SYMBOL(krealloc);

Well could you check ksize for the old object first and if ksize <= new 
size then just skip the copy? I think this may allow you 
to get rid of the ksize callers.


