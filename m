Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbYBINVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbYBINVA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbYBINUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:20:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:49574 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754668AbYBINUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:20:51 -0500
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX18bS84DBGkbuyYQFZPmWOWw/1wk9fnUGlhLcjyDYx
	7HOIFKm8d3tvCO
Subject: [PATCH] time: Fix constant size in kernel/timeconst.h
From: Johann Felix Soden <johfel@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 09 Feb 2008 14:20:42 +0100
Message-Id: <1202563242.22512.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

kernel/timeconst.pl generates only long sized constants in timeconst.pl
which gives this warning:

kernel/time.c: In function 'msecs_to_jiffies':
kernel/time.c:472: warning: integer constant is too large for 'long' type

unsigned long long is needed.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
CC: H. Peter Anvin <hpa@zytor.com>
---
 kernel/timeconst.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timeconst.pl b/kernel/timeconst.pl
index 62b1287..a645654 100644
--- a/kernel/timeconst.pl
+++ b/kernel/timeconst.pl
@@ -342,12 +342,12 @@ sub output($@)
 		      'USEC_TO_HZ','HZ_TO_USEC') {
 		foreach $bit (32, 64) {
 			foreach $suf ('MUL', 'ADJ', 'SHR') {
-				printf "#define %-23s %s\n",
+				printf "#define %-23s %sULL\n",
 					"${pfx}_$suf$bit", shift(@val);
 			}
 		}
 		foreach $suf ('NUM', 'DEN') {
-			printf "#define %-23s %s\n",
+			printf "#define %-23s %sULL\n",
 				"${pfx}_$suf", shift(@val);
 		}
 	}
-- 
1.5.4



