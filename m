Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab0BWSxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:53:16 -0500
Received: from mail.perches.com ([173.55.12.10]:1195 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab0BWSxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:53:15 -0500
Subject: [PATCH V2] scripts/get_maintainer.pl: Fix possible infinite loop
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1266946280.9265.31.camel@Joe-Laptop.home>
References: <1266946280.9265.31.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 10:53:13 -0800
Message-ID: <1266951193.9265.40.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is simpler.

If MAINTAINERS section entries are misformatted,
it was possible to have an infinite loop.

Correct the defect by always moving the index
to the end of section + 1

Also, exit check for exclude as soon as possible.

Signed-off-by: Joe Perches <joe@perches.com>

 scripts/get_maintainer.pl |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 2f3230d..049c419 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -314,6 +314,7 @@ foreach my $file (@files) {
 		if ($type eq 'X') {
 		    if (file_match_pattern($file, $value)) {
 			$exclude = 1;
+			last;
 		    }
 		}
 	    }
@@ -340,8 +341,7 @@ foreach my $file (@files) {
 	    }
 	}
 
-	$tvi += ($end - $start);
-
+	$tvi = $end + 1;
     }
 
     foreach my $line (sort {$hash{$b} <=> $hash{$a}} keys %hash) {


