Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbZEJPq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbZEJPq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 11:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZEJPqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 11:46:18 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:37608 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZEJPqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 11:46:17 -0400
Date: Sun, 10 May 2009 11:45:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] SCRIPTS: Correct RE in header CONFIG leak check.
Message-ID: <alpine.LFD.2.00.0905101141140.17364@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correct the regular expression in scripts/headers_check.pl to include
'_' as a valid character in the class; otherwise, the check will
report a "leaked" symbol of CONFIG_A_B_C as merely CONFIG_A.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 56f90a4..4414c43 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -70,7 +70,7 @@ sub check_prototypes

 sub check_config
 {
-	if ($line =~ m/[^a-zA-Z0-9_]+CONFIG_([a-zA-Z0-9]+)[^a-zA-Z0-9]/) {
+	if ($line =~ m/[^a-zA-Z0-9_]+CONFIG_([a-zA-Z0-9_]+)[^a-zA-Z0-9_]/) {
 		printf STDERR "$filename:$lineno: leaks CONFIG_$1 to userspace where it is not valid\n";
 	}
 }

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
