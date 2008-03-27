Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbYC0DAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbYC0DAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 23:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYC0DAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 23:00:11 -0400
Received: from ozlabs.org ([203.10.76.45]:33461 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbYC0DAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 23:00:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18411.3504.486805.813472@cargo.ozlabs.ibm.com>
Date: Thu, 27 Mar 2008 14:00:00 +1100
From: Paul Mackerras <paulus@samba.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: larger default page sizes...
In-Reply-To: <Pine.LNX.4.64.0803261052550.29859@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
	<20080321.145712.198736315.davem@davemloft.net>
	<Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
	<20080324.133722.38645342.davem@davemloft.net>
	<18408.29107.709577.374424@cargo.ozlabs.ibm.com>
	<87wsnrgg9q.fsf@basil.nowhere.org>
	<18409.56843.909298.717089@cargo.ozlabs.ibm.com>
	<Pine.LNX.4.64.0803261052550.29859@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter writes:

> One should emphasize that this test was a kernel compile which is not 
> a load that gains much from larger pages. 4k pages are mostly okay for 
> loads that use large amounts of small files.

It's also worth emphasizing that 1.5% of the total time, or 21% of the
system time, is pure software overhead in the Linux kernel that has
nothing to do with the TLB or with gcc's memory access patterns.

That's the cost of handling memory in small (i.e. 4kB) chunks inside
the generic Linux VM code, rather than bigger chunks.

Paul.
