Return-Path: <linux-kernel-owner+w=401wt.eu-S1422665AbXBURvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422665AbXBURvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 12:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422660AbXBURvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 12:51:08 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40092 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422665AbXBURvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 12:51:07 -0500
Date: Wed, 21 Feb 2007 09:51:04 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, mcr@sandelman.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: ensure cache_alloc_refill terminates
In-Reply-To: <Pine.LNX.4.64.0702211029340.9758@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0702210950310.24344@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702211029340.9758@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Pekka J Enberg wrote:

> +		 */
> +		BUG_ON(slabp->inuse < 0 || slabp->inuse >= cachep->num);
> +
>  		while (slabp->inuse < cachep->num && batchcount--) {

I think you only need to check for <0. If slabp->inuse > cachep->num then 
the loop will not be taken.
