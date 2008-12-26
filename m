Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYLZH2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYLZH2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 02:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYLZH2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 02:28:38 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56462 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbYLZH2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 02:28:36 -0500
Date: Fri, 26 Dec 2008 08:28:34 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 5/7] drivers/serial/jsm: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0812260828110.25450@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test is necessary, then the dereference should be moved below
the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/).

// <smpl>
@disable is_null@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (E == NULL) S
  f(...,E->fld,...);
- if (E == NULL) S

@@
identifier f;
expression E;
identifier fld;
statement S;
@@

+ if (!E) S
  f(...,E->fld,...);
- if (!E) S
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/serial/jsm/jsm_neo.c        |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/serial/jsm/jsm_neo.c b/drivers/serial/jsm/jsm_neo.c
index b7584ca..0119d9a 100644
--- a/drivers/serial/jsm/jsm_neo.c
+++ b/drivers/serial/jsm/jsm_neo.c
@@ -574,12 +574,13 @@ static void neo_parse_modem(struct jsm_channel *ch, u8 signals)
 {
 	u8 msignals = signals;
 
-	jsm_printk(MSIGS, INFO, &ch->ch_bd->pci_dev,
-			"neo_parse_modem: port: %d msignals: %x\n", ch->ch_portnum, msignals);
-
 	if (!ch)
 		return;
 
+	jsm_printk(MSIGS, INFO, &ch->ch_bd->pci_dev,
+			"neo_parse_modem: port: %d msignals: %x\n",
+			ch->ch_portnum, msignals);
+
 	/* Scrub off lower bits. They signify delta's, which I don't care about */
 	/* Keep DDCD and DDSR though */
 	msignals &= 0xf8;
