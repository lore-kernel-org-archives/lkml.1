Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZJSJtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZJSJtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 05:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZJSJtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 05:49:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55808 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZJSJtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 05:49:19 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH] checkpatch: fix false positive on __initconst
Date: Mon, 19 Oct 2009 11:49:14 +0200
Message-Id: <1255945754-2160-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch falsely complained about '__initconst' because it thought the
'const' needed a space before. Fix this by changing the list of attributes:

- add '__initconst'
- force plain 'init' to contain a word-boundary at the end

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Andy Whitcroft <apw@shadowen.org>
---

Not entirely sure if adding the word boundary may cause a side-effect which I
overlooked. A few more eyes on this would be great.

 scripts/checkpatch.pl |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 87bbb8b..0a47a1f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -142,11 +142,14 @@ our $Sparse	= qr{
 			__kprobes|
 			__ref
 		}x;
+
+# Notes to $Attribute:
+# We need \b after 'init' otherwise 'initconst' will cause a false positive in a check
 our $Attribute	= qr{
 			const|
 			__read_mostly|
 			__kprobes|
-			__(?:mem|cpu|dev|)(?:initdata|init)|
+			__(?:mem|cpu|dev|)(?:initdata|initconst|init\b)|
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
-- 
1.6.3.3

