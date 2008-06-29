Return-Path: <linux-kernel-owner+w=401wt.eu-S1760894AbYF2OQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760894AbYF2OQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 10:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759106AbYF2OQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 10:16:05 -0400
Received: from [194.117.236.238] ([194.117.236.238]:52692 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758308AbYF2OQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 10:16:04 -0400
Date: Sun, 29 Jun 2008 17:15:28 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] block: GFP_ATOMIC is __GFP_HIGH
Message-ID: <20080629171528.5590b78b@linux360.ro>
In-Reply-To: <Pine.LNX.4.64.0806290700160.7279@blonde.site>
References: <Pine.LNX.4.64.0806290052350.18327@blonde.site>
	<20080629043827.135f39d7@linux360.ro>
	<Pine.LNX.4.64.0806290700160.7279@blonde.site>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 07:16:49 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> but it is not
> accidental that GFP_ATOMIC includes __GFP_HIGH - it's precisely when
> we're atomic that we need access to those extra reserves; and where
> we don't actually want them then we do say GFP_NOWAIT not GFP_ATOMIC.

I would expect GFP_ATOMIC just prevents sleeping, while it _could_ fail
(in theory) unless it is allowed to touch the emergency pools.

Actually, in many/most atomic contexts bail-out paths are possible for
allocation failures. And many/most of these atomic contexts have no
special reason to require emergency memory. Think about the usual
allocations enclosed within spinlocks.

> I expect the gfp flags will change in the future; but unless I missed
> somewhere, amongst all the places which specify GFP_ATOMIC throughout
> the kernel, this is the only one which ors in __GFP_HIGH too.  I don't
> believe it expected access to extra extra reserves!  So I thought we'd
> do best to remove the anomaly.

Yes, it seems this is the only place where this occurs.

Although I did not read all the code and resolved its implications, it
seems like it actually needs something like __GFP_NOFAIL (?) instead of
__GFP_HIGH. The slab itself is created with SLAB_PANIC.

> (But what I'd actually intended to grep for was __GFP_HIGHMEM.)
> 
> Hugh


	Eduard
