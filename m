Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYLGCcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYLGCcA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 21:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYLGCbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 21:31:40 -0500
Received: from ozlabs.org ([203.10.76.45]:52175 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbYLGCbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 21:31:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18747.13668.304923.709761@cargo.ozlabs.ibm.com>
Date: Sun, 7 Dec 2008 13:31:00 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Palix <npalix@diku.dk>, benh@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH linux-next] powerpc/powermac: Add missing of_node_put
In-Reply-To: <20081206163449.60757c4a.akpm@linux-foundation.org>
References: <200812021445.18670.npalix@diku.dk>
	<20081206163449.60757c4a.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> This still misses a path - if that `return 0' is taken, we still leak
> the reference.
> 
> This is reason #345 why sprinkling return statements all over your code
> is bad.
> 
> I fixed it up thusly.  Please check.

I'm really in two minds about applying any of the of_node_put patches
that only affect powermacs.  The reference counts only matter on
platforms where we update the OF device tree at runtime, which is
currently only IBM pSeries machines.  Since we don't have any hotplug
on powermacs, and never will have, the OF device tree is completely
static and we don't actually need refcounts on the nodes at all, so
who cares if they're a bit higher than they might be?

In particular, the VIA whose node we're looking for here is built-in
on the motherboard, and there can never be more than one, and it can
never be removed.

Paul.
