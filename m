Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbYCCHSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbYCCHSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 02:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYCCHSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 02:18:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbYCCHSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 02:18:00 -0500
Date: Sun, 2 Mar 2008 23:17:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] mempolicy: convert MPOL constants to enum
Message-Id: <20080302231737.f5b68b0c.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.00.0802291640570.30883@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802291640570.30883@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 16:44:59 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> The mempolicy mode constants, MPOL_DEFAULT, MPOL_PREFERRED, MPOL_BIND,
> and MPOL_INTERLEAVE, are better declared as part of an enum since they
> are sequentially numbered and cannot be combined.
> 
> The policy member of struct mempolicy is also converted from type short
> to type unsigned short.  A negative policy does not have any legitimate
> meaning, so it is possible to change its type in preparation for adding
> optional mode flags later.
> 
> The equivalent member of struct shmem_sb_info is also changed from int
> to unsigned short.
> 
> For compatibility, the policy formal to get_mempolicy() remains as a
> pointer to an int:
> 
> 	int get_mempolicy(int *policy, unsigned long *nmask,
> 			  unsigned long maxnode, unsigned long addr,
> 			  unsigned long flags);
> 
> although the only possible values is the range of type unsigned short.

The collisions between this work and Mel's

mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch

are more than I'm comfortable with fixing, sorry.
