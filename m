Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbXFEF1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbXFEF1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 01:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbXFEF13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 01:27:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:52893 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbXFEF13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 01:27:29 -0400
Message-ID: <4664F44C.4040206@cs.helsinki.fi>
Date: Tue, 05 Jun 2007 08:27:40 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 1.5.0.12 (Macintosh/20070509)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <alpine.LFD.0.98.0706041143240.23741@woody.linux-foundation.org> <Pine.LNX.4.64.0706041200140.24550@schroedinger.engr.sgi.com> <84144f020706041213x1d241794u98e9b3ca29865033@mail.gmail.com> <Pine.LNX.4.64.0706041213540.24935@schroedinger.engr.sgi.com> <46646747.2080803@cs.helsinki.fi> <Pine.LNX.4.64.0706041532350.27125@schroedinger.engr.sgi.com> <20070604155355.bf29a3a8.akpm@linux-foundation.org> <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0706041607560.27346@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> SLUB: Return ZERO_SIZE_PTR for kmalloc(0) V3
> 
> Instead of returning the smallest available object return ZERO_SIZE_PTR.
> 
> A ZERO_SIZE_PTR can be legitimately used as an object pointer as long
> as it is not deferenced. The dereference of ZERO_SIZE_PTR causes a
> distinctive fault.
> kfree can handle a ZERO_SIZE_PTR in the same way as NULL.

FWIW, I am happy :-). We should add a comment to kmalloc() that we 
return non-unique pointers for zero-length allocations though.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
