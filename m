Return-Path: <linux-kernel-owner+w=401wt.eu-S1758628AbXH3I15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628AbXH3I15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 04:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbXH3I1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 04:27:50 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41026 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906AbXH3I1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 04:27:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Hugh Dickins <hugh@veritas.com>
Cc: Daniel Drake <ddrake@brontes3d.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: speeding up swapoff
References: <1188394172.22156.67.camel@localhost>
	<Pine.LNX.4.64.0708291558480.27467@blonde.wat.veritas.com>
Date: Thu, 30 Aug 2007 02:27:29 -0600
In-Reply-To: <Pine.LNX.4.64.0708291558480.27467@blonde.wat.veritas.com> (Hugh
	Dickins's message of "Wed, 29 Aug 2007 16:36:37 +0100 (BST)")
Message-ID: <m1d4x52zri.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> writes:

> The speedups I've imagined making, were a need demonstrated, have
> been more on the lines of batching (dealing with a range of pages
> in one go) and hashing (using the swapmap's ushort, so often 1 or
> 2 or 3, to hold an indicator of where to look for its references).

There is one other possibility.  Typically the swap code is using
compatibility disk I/O functions instead of the best the kernel
can offer.  I haven't looked recently but it might be worth just
making certain that there isn't some low-level optimization or
cleanup possible on that path.  Although I may just be thinking
of swapfiles.

I know there were tremendous gains ago when I removed the functions
that wrote pages synchronously to swapfiles.

Eric
