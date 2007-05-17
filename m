Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbXERID4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbXERID4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 04:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755538AbXERIDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 04:03:43 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:50851 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755433AbXERIDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 04:03:41 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix roundup_pow_of_two(1)
Date: Thu, 17 May 2007 23:56:56 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705172356.57620.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix roundup_pow_of_two(1)

1 is a power of two, therefore roundup_pow_of_two(1) should return 1. It does
in case the argument is a variable but in case it's a constant it behaves
wrong and returns 0. Probably nobody ever did it so this was never noticed.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit 01ceeffac83011f0b5021013cc4abd1c4f291df5
tree 7da59df51617d7cebd55e4361019181645a17e10
parent ab35916f807eb4f2019a208e96cb0bddbb91dfc3
author Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 17 May 2007 23:43:54 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Thu, 17 May 2007 23:43:54 +0200

 include/linux/log2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index 57e641e..1b8a2c1 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -159,7 +159,7 @@ unsigned long __roundup_pow_of_two(unsigned long n)
 #define roundup_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 0 :			\
+		(n == 1) ? 1 :			\
 		(1UL << (ilog2((n) - 1) + 1))	\
 				   ) :		\
 	__roundup_pow_of_two(n)			\
