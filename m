Return-Path: <linux-kernel-owner+w=401wt.eu-S1422771AbXBUS1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422771AbXBUS1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422775AbXBUS1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:27:09 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39624 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422771AbXBUS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:27:08 -0500
Date: Wed, 21 Feb 2007 10:27:06 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
Subject: Re: [PATCH 1/3] slab: introduce krealloc
In-Reply-To: <45DC8DA1.6030100@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0702211023300.24719@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702211003290.8172@sbz-30.cs.Helsinki.FI>
 <Pine.LNX.4.64.0702210951580.24344@schroedinger.engr.sgi.com>
 <45DC8DA1.6030100@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Pekka Enberg wrote:

> Christoph Lameter wrote:
> > Well could you check ksize for the old object first and if ksize <= new size
> > then just skip the copy? I think this may allow you to get rid of the ksize
> > callers.
> 
> And not reallocate at all, right? I thought about that but then you wouldn't
> be able to use realloc() to make the buffer smaller.

I think there are two ways to address that:

1. Just do not allow shrinking via realloc. Probably no big loss and best 
performance.

2. Check if the size specified is larger than the next smallest general 
cache and only copy if we would really would allocate from a different 
cache.

