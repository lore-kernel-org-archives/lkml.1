Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbXENNhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbXENNhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbXENNgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:36:55 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:29577 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbXENNgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:36:54 -0400
Message-Id: <20070514131904.440041502@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 14 May 2007 15:19:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>
Subject: [PATCH 0/5] make slab gfp fair
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In the interest of creating a reserve based allocator; we need to make the slab
allocator (*sigh*, all three) fair with respect to GFP flags.

That is, we need to protect memory from being used by easier gfp flags than it
was allocated with. If our reserve is placed below GFP_ATOMIC, we do not want a
GFP_KERNEL allocation to walk away with it - a scenario that is perfectly
possible with the current allocators.


