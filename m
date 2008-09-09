Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYIIBUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYIIBUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 21:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYIIBUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 21:20:24 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38310 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbYIIBUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 21:20:22 -0400
Message-Id: <20080909003403.836661865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 08 Sep 2008 20:34:03 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>, Joe Perches <joe@perches.com>,
       Wei Weng <wweng@acedsl.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] Priority Sifting Reader-Writer Lock v13
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Tue,  9 Sep 2008 00:55:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the reworked version of what was initially called "Fair rwlock", then
"writer-biased rwlock". Hopefully the naming should now better represent the
innovation in this reader-writer locking scheme.

Thanks to Linus' patient explanations, it uses a single atomic op on a 32 bit
variable in the fast path. The bright side of this is instruction-wise
compactness of the fast path and that there is practically no limitation on the
number of readers or writers. The downside is added memory ordering complexity
between fast and slow path variables in the slow path.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
