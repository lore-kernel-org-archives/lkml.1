Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0BWRbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 12:31:23 -0500
Received: from mail.perches.com ([173.55.12.10]:1193 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab0BWRbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 12:31:21 -0500
Subject: [PATCH] scripts/get_maintainer.pl: Fix possible infinite loop
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 09:31:20 -0800
Message-ID: <1266946280.9265.31.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If MAINTAINERS section entries are misformatted,
it was possible to have an infinite loop.

Correct the defect by always moving at least one entry
forward in parsing the MAINTAINERS file.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 2f3230d..4f2ec25 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -340,8 +340,11 @@ foreach my $file (@files) {
 	    }
 	}
 
-	$tvi += ($end - $start);
-
+	if ($end <= $start) {
+	    $tvi++;
+	} else {
+	    $tvi += ($end - $start);
+	}
     }
 
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {
-- 
1.7.0.14.g7e948


