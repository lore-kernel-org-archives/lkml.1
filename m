Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZFONaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZFONaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbZFONaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:30:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZFONaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:30:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: [PATCH] asm-generic: add EMAXERRNO
Date: Mon, 15 Jun 2009 15:30:09 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <OF48364F7F.ED6F93C7-ON482575D6.0042A7E0-482575D6.0043654D@sunplusct.com>
In-Reply-To: <OF48364F7F.ED6F93C7-ON482575D6.0042A7E0-482575D6.0043654D@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <200906151530.10299.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19K1DwfMCfN8iXWQu8WhoOVrddHVFGRgrcHiYj
 8N+kGd1Yl0/C48l8RRuST5xHSttn/3/h0+lTTNesnzFjnXD5J1
 YTgRRxJGkvgxzVb+swTrQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures want to flag error returns from a syscall based on
the return value. The range from zero to -511 is for errors that
we can return to user space, so add a #define for this to
include/asm-generic/errno.h.

Reported-by: Chen Liquin <liqin.chen@sunplusct.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/errno.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

On Monday 15 June 2009, liqin.chen@sunplusct.com wrote:

> Maybe I can don't use EMAXERRNO in score code. But I think define a 
> maximum error number in asm-generic/errno.h is better.
> 

How about this one?

diff --git a/include/asm-generic/errno.h b/include/asm-generic/errno.h
index e8852c0..16bb31d 100644
--- a/include/asm-generic/errno.h
+++ b/include/asm-generic/errno.h
@@ -106,4 +106,8 @@
 #define	EOWNERDEAD	130	/* Owner died */
 #define	ENOTRECOVERABLE	131	/* State not recoverable */
 
+#ifdef __KERNEL__
+#define	EMAXERRNO	511	/* maximum errno value we return to user */
+#endif
+
 #endif
-- 
1.6.3.1

 

