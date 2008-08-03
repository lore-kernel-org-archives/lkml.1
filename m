Return-Path: <linux-kernel-owner+w=401wt.eu-S1759312AbYHCUi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312AbYHCUi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYHCUiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:38:20 -0400
Received: from xenotime.net ([66.160.160.81]:58090 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753004AbYHCUiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:38:20 -0400
Date: Sun, 3 Aug 2008 13:38:16 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org
Subject: [PATCH] kernel-doc: skip nested struct/union cleanly
Message-ID: <Pine.LNX.4.64.0808031336440.20768@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix handling of nested structs or unions.  The regex to strip (eliminate)
nested structs or unions was limited to only 0 or 1 matches.
This can cause an uneven number of left/right braces to be stripped,
which causes this:

Warning(linux-2.6.27-rc1-git2//include/net/mac80211.h:336): No description found for parameter '}'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lin2627-rc1g2-kerndocbrace.orig/scripts/kernel-doc
+++ lin2627-rc1g2-kerndocbrace/scripts/kernel-doc
@@ -1403,7 +1403,7 @@ sub dump_struct($$) {
 	my $members = $3;
 
 	# ignore embedded structs or unions
-	$members =~ s/{.*?}//g;
+	$members =~ s/{.*}//g;
 
 	# ignore members marked private:
 	$members =~ s/\/\*.*?private:.*?public:.*?\*\///gos;
