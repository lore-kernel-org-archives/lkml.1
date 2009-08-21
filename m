Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbZHUVqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbZHUVqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932981AbZHUVqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:46:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59354 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932995AbZHUVqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:46:31 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 6/7] checkpatch: limit sN/uN matches to actual bit sizes
Date: Fri, 21 Aug 2009 22:46:09 +0100
Message-Id: <1250891170-8599-7-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1250891170-8599-1-git-send-email-apw@canonical.com>
References: <1250891170-8599-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Limit our type matcher to the s/u/le/be etc sizes that actually exist
to prevent miss categorising s2 as a type.  Fix up the spelling of the
error also.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 57df906..7fee823 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -182,7 +182,7 @@ our $UTF8	= qr {
 }x;
 
 our $typeTypedefs = qr{(?x:
-	(?:__)?(?:u|s|be|le)(?:\d|\d\d)|
+	(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
 	atomic_t
 )};
 
@@ -1936,7 +1936,7 @@ sub process {
 						# A unary '*' may be const
 
 					} elsif ($ctx =~ /.xW/) {
-						ERROR("Aspace prohibited after that '$op' $at\n" . $hereptr);
+						ERROR("space prohibited after that '$op' $at\n" . $hereptr);
 					}
 
 				# unary ++ and unary -- are allowed no space on one side.
-- 
1.6.3.3

