Return-Path: <linux-kernel-owner+w=401wt.eu-S1764957AbYD1DvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764957AbYD1DvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 23:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762149AbYD1Duv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 23:50:51 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57914 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763572AbYD1Duu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 23:50:50 -0400
Message-Id: <20080428033415.303000651@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 27 Apr 2008 23:34:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 0/2] Immediate Values - jump patching update
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 28 Apr 2008 03:50:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here is the update to the jump patching optimization taking care of Peter's
comments about register liveliness and instruction re-use by gcc optimizations.
A good thing : it actually simplifies the code. Unfortunately, it adds 3 bytes
to the instructions in i-cache because I now have to use a 5-bytes mov
instruction so I can replace it with a 5-bytes jump. Therefore, 9 bytes are
added to rather small functions (5-bytes mov + 2-bytes test + 2 bytes
conditional branch) and 13 bytes are added to larger functions which needs a 6
bytes conditional branch at the branch site.

Instead of having to execute a sequence of nop, nop and jump, we now only have
to execute the near jump, which jumps either at the address following the
conditional branch or at the target address of the conditional branch, depending
on the immediate value variable state.

Thanks to Peter for the review.

Those two patches apply on top of sched-devel.git.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
