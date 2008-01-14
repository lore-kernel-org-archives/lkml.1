Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYANTXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYANTXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYANTWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:22:44 -0500
Received: from mail.vyatta.com ([216.93.170.194]:33696 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbYANTWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:22:43 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.518
Date: Mon, 14 Jan 2008 11:19:58 -0800
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] checkstack: parse architecture correctly
Message-ID: <20080114111958.58355143@deepthought>
Organization: Vyatta
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checkstack script wouldn't work because it was picking up the
newline on the end of the output of uname -m.

Also, use a standard perl construct to print error message and
exit with non-zero error code.

Signed-off-by: Stephen Hemminger <stephen.hemminger@vyatta.com>

--- a/scripts/checkstack.pl	2008-01-14 11:09:09.000000000 -0800
+++ b/scripts/checkstack.pl	2008-01-14 11:09:51.000000000 -0800
@@ -32,6 +32,7 @@ my (@stack, $re, $x, $xs);
 	my $arch = shift;
 	if ($arch eq "") {
 		$arch = `uname -m`;
+		chomp $arch;
 	}
 
 	$x	= "[0-9a-f]";	# hex character
@@ -85,8 +86,7 @@ my (@stack, $re, $x, $xs);
 		#   0:   00 e8 38 01     LINK 0x4e0;
 		$re = qr/.*[[:space:]]LINK[[:space:]]*(0x$x{1,8})/o;
 	} else {
-		print("wrong or unknown architecture\n");
-		exit
+	    	die "wrong or unknown architecture\"$arch\"\n";
 	}
 }
 
