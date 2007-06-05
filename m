Return-Path: <linux-kernel-owner+w=401wt.eu-S1764542AbXFEN6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764542AbXFEN6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 09:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761575AbXFEN6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 09:58:17 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:56751 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761428AbXFEN6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 09:58:16 -0400
Date: Tue, 5 Jun 2007 09:58:06 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Rene Herman <rene.herman@gmail.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
In-Reply-To: <46655CEC.7070900@gmail.com>
Message-ID: <alpine.DEB.0.99.0706050951210.30666@sigma.j-a-k-j.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
 <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com>
 <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com>
 <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com>
 <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com>
 <20070604155355.bf29a3a8.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com>
 <466523E0.3050605@gmail.com> <alpine.DEB.0.99.0706050804170.27388@sigma.j-a-k-j.com>
 <46655CEC.7070900@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The name says exactly what it is. It's not at all dreadful. If we're going
> > to return a special value in the zero-size case (and in only that case) as a
> > valid pointer instead of actually allocating one byte and treating it as
> > zero, what we have is...a zero-size pointer.
> 
> No, what we have is a sizeof(pointer) sized pointer pointing to an object of
> size zero. ZERO_SIZE_PTR is butt-ugly. With a really ugly butt.

sizeof(pointer) is the object. ZERO_SIZE_PTR is the value stored in that 
object. Would you prefer PTR_TO_ZERO_SIZE_OBJ_VAL?

Maybe you would prefer ZERO_SIZE_OBJ instead. What you have is "a pointer 
object which points to a zero-sized object".

What if there were some construct in the kernel that never got deleted? 
We'll call it "struct foo * bar_ctl". What would you call a pointer to 
this? "bar_ctl_ptr". Or even "foo_ptr". So "ZERO_SIZE_OBJ_PTR" is the most 
correct form, and "ZERO_SIZE_PTR" is a convenient shortening. "ZERO_PTR" 
is too short and also confuses with NULL because NULL is a zero-value 
object, rather than a non-zero--value pointer to a zero-size object.
