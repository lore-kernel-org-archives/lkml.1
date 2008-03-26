Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbYCZXVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbYCZXVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYCZXVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:21:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39030
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbYCZXVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:21:43 -0400
Date: Wed, 26 Mar 2008 16:21:43 -0700 (PDT)
Message-Id: <20080326.162143.244048620.davem@davemloft.net>
To: clameter@sgi.com
Cc: paulus@samba.org, andi@firstfloor.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0803261052550.29859@schroedinger.engr.sgi.com>
References: <87wsnrgg9q.fsf@basil.nowhere.org>
	<18409.56843.909298.717089@cargo.ozlabs.ibm.com>
	<Pine.LNX.4.64.0803261052550.29859@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Wed, 26 Mar 2008 10:56:17 -0700 (PDT)

> One should emphasize that this test was a kernel compile which is not 
> a load that gains much from larger pages.

Actually, ever since gcc went to a garbage collecting allocator, I've
found it to be a TLB thrasher.

It will repeatedly randomly walk over a GC pool of at least 8MB in
size, which to fit fully in the TLB with 4K pages reaquires a TLB with
2048 entries assuming gcc touches no other data which is of course a
false assumption.

For some compiles this GC pool is more than 100MB in size.

GCC does not fit into any modern TLB using it's base page size.
