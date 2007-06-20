Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbXFTIfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbXFTIfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 04:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbXFTIfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 04:35:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49453 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbXFTIfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 04:35:41 -0400
Subject: Re: Change in default vm_dirty_ratio
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, tim.c.chen@linux.intel.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070619214407.dfff0ca6.akpm@linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain>
	 <20070618164711.9de1c38e.akpm@linux-foundation.org>
	 <20070620042434.GC12096@redhat.com>
	 <20070619214407.dfff0ca6.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 20 Jun 2007 10:35:36 +0200
Message-Id: <1182328536.21117.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 21:44 -0700, Andrew Morton wrote:

> Anyway, this is all arse-about.  What is the design?  What algorithms
> do we need to implement to do this successfully?  Answer me that, then
> we can decide upon these implementation details.

Building on the per BDI patches, how about integrating feedback from the
full-ness of device queues. That is, when we are happily doing IO and we
cannot possibly saturate the active devices (as measured by their queue
never reaching 75%?) then we can safely increase the total dirty limit.

OTOH, when even with the per BDI dirty limit the device queue is
constantly saturated (contended) we ought to lower the total dirty
limit.

Lots of detail here to work out, but does this sound workable?

