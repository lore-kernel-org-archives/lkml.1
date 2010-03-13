Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243Ab0CMA1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:27:50 -0500
Received: from kroah.org ([198.145.64.141]:32858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934950Ab0CMAVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:06 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:14 2010
Message-Id: <20100313001514.756898683@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joe Perches <joe@perches.com>
Subject: [patch 110/123] scripts/get_maintainer.pl: fix possible infinite loop
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Joe Perches <joe@perches.com>

commit 3c840c18bcd8efb37f1a565e83a9509e1ea5d105 upstream.

If MAINTAINERS section entries are misformatted, it was possible to have
an infinite loop.

Correct the defect by always moving the index to the end of section + 1

Also, exit check for exclude as soon as possible.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/get_maintainer.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


