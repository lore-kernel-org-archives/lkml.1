Return-Path: <linux-kernel-owner+w=401wt.eu-S935642AbXHGUwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935642AbXHGUwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935381AbXHGUsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:48:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56043 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935234AbXHGUsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:48:06 -0400
Date: Tue, 7 Aug 2007 13:44:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 15/84] Sparc64 bootup assembler bug
Message-ID: <20070807204403.GP23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-bootup-assembler-bug.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David S. Miller <davem@davemloft.net>

[SPARC64]: Fix two year old bug in early bootup asm.

We try to fetch the CIF entry pointer from %o4, but that
can get clobbered by the early OBP calls.  It is saved
in %l7 already, so actually this "mov %o4, %l7" can just
be completely removed with no other changes.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/head.S |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/sparc64/kernel/head.S
+++ b/arch/sparc64/kernel/head.S
@@ -458,7 +458,6 @@ tlb_fixup_done:
 	or	%g6, %lo(init_thread_union), %g6
 	ldx	[%g6 + TI_TASK], %g4
 	mov	%sp, %l6
-	mov	%o4, %l7
 
 	wr	%g0, ASI_P, %asi
 	mov	1, %g1

-- 
