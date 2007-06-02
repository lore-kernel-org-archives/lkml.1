Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbXFBCKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbXFBCKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 22:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759276AbXFBCKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 22:10:31 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:55686 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877AbXFBCKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 22:10:30 -0400
Date: Fri, 1 Jun 2007 22:09:35 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Christoph Lameter <clameter@sgi.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.0.99.0706012205080.1305@sigma.j-a-k-j.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	 * The behavior for zero sized allocs changes. We no longer
> +	 * allocate memory but return ZERO_SIZE_PTR.
> +	 * WARN so that people can review and fix their code.

I don't see why people have so much opposition to zero-size memory 
allocations. There's all sorts of situations where you want a resizeable 
array that may have zero objects, especially in these days of 
hotpluggability.

Not only is it simpler (and therefore less likely to be buggy) to write 
code to simply resize to current number of objects, but not having to make 
additional code for checking the special case of count==0 leading to 
different function calls (instead of always reallocating, you might have 
to allocate instead, and instead of reallocating to zero you might have to 
free instead) will very slightly increase the object-text size.

The standard-C behavior of valid zero-size allocation has a very good 
reason.
