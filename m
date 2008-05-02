Return-Path: <linux-kernel-owner+w=401wt.eu-S933991AbYEBRVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991AbYEBRVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYEBRVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:21:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYEBRVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:21:08 -0400
Message-ID: <481B4D75.9060305@redhat.com>
Date: Fri, 02 May 2008 12:20:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] fix checkstack.pl arch detection
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uname -m was leaving a newline in $arch, and not passing the tests.

Also, printing the unknown arch on failure is probably helpful.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.25/scripts/checkstack.pl
===================================================================
--- linux-2.6.25.orig/scripts/checkstack.pl	2008-05-02 12:17:59.000000000 -0500
+++ linux-2.6.25/scripts/checkstack.pl	2008-05-02 12:18:15.426407528 -0500
@@ -32,6 +32,7 @@ my (@stack, $re, $x, $xs);
 	my $arch = shift;
 	if ($arch eq "") {
 		$arch = `uname -m`;
+		chomp($arch);
 	}
 
 	$x	= "[0-9a-f]";	# hex character
@@ -85,7 +86,7 @@ my (@stack, $re, $x, $xs);
 		#   0:   00 e8 38 01     LINK 0x4e0;
 		$re = qr/.*[[:space:]]LINK[[:space:]]*(0x$x{1,8})/o;
 	} else {
-		print("wrong or unknown architecture\n");
+		print("wrong or unknown architecture \"$arch\"\n");
 		exit
 	}
 }

