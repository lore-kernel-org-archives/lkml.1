Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYEYTQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYEYTQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbYEYTQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:16:46 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:54188 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbYEYTQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:16:45 -0400
Date: Sun, 25 May 2008 21:16:36 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: tglx@linutronix.de
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Remove obsolete LOCK macro from include/asm-x86/atomic_64.h
Message-ID: <Pine.LNX.4.64.0805252114420.25477@titan.stealer.net>
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -0.6
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sun, 25 May 2008 19:16:44 +0000
	Bayes: 0.1500 Tokens: new, 172; hammy, 2; neutral, 4; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1500]
X-Spam-Signature: d2ecc056e3593932e18b22ed0767045e266b57f3
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d167a518 "[PATCH] x86_64: x86_64 version of the smp alternative patch."
has left the LOCK macro in include/asm-x86_64/atomic.h, which is now
include/asm-x86/atomic_64.h. Its scope should be local to the file, other
architectures don't provide it, I couldn't find an in-tree user of it and
allyesconfig, allmodconfig and allnoconfig build fine without it, so this patch
removes it.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
  include/asm-x86/atomic_64.h |    6 ------
  1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/asm-x86/atomic_64.h b/include/asm-x86/atomic_64.h
index 3e0cd7d..fe589c1 100644
--- a/include/asm-x86/atomic_64.h
+++ b/include/asm-x86/atomic_64.h
@@ -11,12 +11,6 @@
   * resource counting etc..
   */

-#ifdef CONFIG_SMP
-#define LOCK "lock ; "
-#else
-#define LOCK ""
-#endif
-
  /*
   * Make sure gcc doesn't try to be clever and move things around
   * on us. We need to use _exactly_ the address the user gave us,
