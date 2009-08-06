Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbZHFAvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbZHFAvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZHFAvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:51:31 -0400
Received: from mail.atheros.com ([12.36.123.2]:29954 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbZHFAvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:51:14 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>,
       <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <mcgrof@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] checkincludes.pl: close file as soon as we're done with it
Date: Wed, 5 Aug 2009 17:51:10 -0700
Message-ID: <1249519872-23958-2-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249519872-23958-1-git-send-email-lrodriguez@atheros.com>
References: <1249519872-23958-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 scripts/checkincludes.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
index 8e6b716..32ebff6 100755
--- a/scripts/checkincludes.pl
+++ b/scripts/checkincludes.pl
@@ -13,12 +13,12 @@ foreach $file (@ARGV) {
 			++$includedfiles{$1};
 		}
 	}
+
+	close(FILE);
 	
 	foreach $filename (keys %includedfiles) {
 		if ($includedfiles{$filename} > 1) {
 			print "$file: $filename is included more than once.\n";
 		}
 	}
-
-	close(FILE);
 }
-- 
1.6.3.3

