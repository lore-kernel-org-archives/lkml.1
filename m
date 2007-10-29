Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbXJ2C7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbXJ2C7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbXJ2C7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:59:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36984 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752267AbXJ2C7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:59:32 -0400
Date: Sun, 28 Oct 2007 19:59:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: Matthew Wilcox <matthew@wil.cx>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 08/10] SLUB: Optional fast path using cmpxchg_local
In-Reply-To: <Pine.LNX.4.64.0710281502480.4207@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0710281957470.28636@schroedinger.engr.sgi.com>
References: <20071028033156.022983073@sgi.com> <20071028033300.240703208@sgi.com>
 <Pine.LNX.4.64.0710281502480.4207@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007, Pekka J Enberg wrote:

> Can you please write a comment of the locking rules when cmpxchg_local() 
> is used? Looks as if we could push that local_irq_save() to slub_lock() 
> and local_irq_restore() to slub_unlock() and deal with the unused flags 
> variable for the non-CONFIG_FAST_CMPXCHG_LOCAL case with a macro, no?

Hmmmm... Maybe .. The locking rules are not changed at all by this patch. 
The cmpxchg_local is only used for the per cpu object list. The per cpu 
slabs are frozen.

