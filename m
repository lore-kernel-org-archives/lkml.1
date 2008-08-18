Return-Path: <linux-kernel-owner+w=401wt.eu-S934104AbYHRTsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104AbYHRTsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbYHRTn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:43:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:49856 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933577AbYHRTn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:43:57 -0400
Date: Mon, 18 Aug 2008 12:21:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jan Beulich <jbeulich@novell.com>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 46/49] x86: fix spin_is_contended()
Message-ID: <20080818192100.GU10350@suse.de>
References: <20080818191012.663450219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-spin_is_contended.patch"
In-Reply-To: <20080818191834.GA10350@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Beulich <jbeulich@novell.com>

commit 7bc069c6bc4ede519a7116be1b9e149a1dbf787a upstream

The masked difference is what needs to be compared against 1, rather
than the difference of masked values (which can be negative).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-x86/spinlock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/asm-x86/spinlock.h
+++ b/include/asm-x86/spinlock.h
@@ -75,7 +75,7 @@ static inline int __raw_spin_is_contende
 {
 	int tmp = *(volatile signed int *)(&(lock)->slock);
 
-	return (((tmp >> 8) & 0xff) - (tmp & 0xff)) > 1;
+	return (((tmp >> 8) - tmp) & 0xff) > 1;
 }
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
@@ -141,7 +141,7 @@ static inline int __raw_spin_is_contende
 {
 	int tmp = *(volatile signed int *)(&(lock)->slock);
 
-	return (((tmp >> 16) & 0xffff) - (tmp & 0xffff)) > 1;
+	return (((tmp >> 16) - tmp) & 0xffff) > 1;
 }
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)

-- 
