Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbXIMUm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbXIMUm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 16:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758258AbXIMUl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 16:41:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:60215 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbXIMUl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 16:41:58 -0400
Date: Thu, 13 Sep 2007 16:41:12 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/3] UML - Fix usec to nsec conversion
Message-ID: <20070913204112.GA9991@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

microseconds need to be multiplied by a thousand, not a billion, to get
nanoseconds.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/os-Linux/time.c
===================================================================
--- linux-2.6.22.orig/arch/um/os-Linux/time.c	2007-09-12 16:45:28.000000000 -0400
+++ linux-2.6.22/arch/um/os-Linux/time.c	2007-09-13 11:37:05.000000000 -0400
@@ -48,7 +48,7 @@ static inline unsigned long long tv_to_n
 	 */
 
 	return ((unsigned long long) tv->tv_sec) * UM_NSEC_PER_SEC +
-		tv->tv_usec * UM_NSEC_PER_SEC;
+		tv->tv_usec * UM_NSEC_PER_USEC;
 }
 
 unsigned long long disable_timer(void)
