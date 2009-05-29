Return-Path: <linux-kernel-owner+w=401wt.eu-S1761932AbZE2PzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761932AbZE2PzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbZE2Py7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:54:59 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43517 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbZE2Py7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:54:59 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       "Peter Botha" <peterb@goldcircle.co.za>
Subject: [PATCH 1/1] Char: mxser, fix ISA board lookup
Date: Fri, 29 May 2009 17:53:13 +0200
Message-Id: <1243612393-2111-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Peter Botha" <peterb@goldcircle.co.za>

There's a bug in the mxser kernel module that still appears in the 2.6.29.4
kernel.

mxser_get_ISA_conf takes a ioaddress as it's first argument, by passing the
not of the ioaddr, you're effectively passing 0
which means it won't be able to talk to an ISA card.
I have tested this, and removing the ! fixes the problem.

Cc: "Peter Botha" <peterb@goldcircle.co.za>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 6dfef56..9533f43 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -2715,7 +2715,7 @@ static int __init mxser_module_init(void)
 			continue;
 
 		brd = &mxser_boards[m];
-		retval = mxser_get_ISA_conf(!ioaddr[b], brd);
+		retval = mxser_get_ISA_conf(ioaddr[b], brd);
 		if (retval <= 0) {
 			brd->info = NULL;
 			continue;
-- 
1.6.3

