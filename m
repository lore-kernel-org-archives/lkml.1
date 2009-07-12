Return-Path: <linux-kernel-owner+w=401wt.eu-S1752132AbZGLHn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbZGLHn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 03:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZGLHnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 03:43:18 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:52325 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbZGLHnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 03:43:17 -0400
Date: Sun, 12 Jul 2009 09:42:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jkosina@suse.cz, linux-input@vger.kernel.org, gregkh@suse.de,
       jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] drivers/hid: Drop NULL test on list_entry result
Message-ID: <Pine.LNX.4.64.0907120942070.17416@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

list_entry, which is an alias for container_of, cannot return NULL, as
there is no way to add a NULL value to a doubly linked list.

A simplified version of the semantic match that findds this problem is as
follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r@
expression x,E;
statement S1,S2;
position p,p1;
@@

*x = list_entry@p(...)
... when != x = E
*if@p1 (x == NULL) S1 else S2
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/hid/hid-lgff.c              |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-lgff.c b/drivers/hid/hid-lgff.c
index 95835ea..987abeb 100644
--- a/drivers/hid/hid-lgff.c
+++ b/drivers/hid/hid-lgff.c
@@ -151,11 +151,6 @@ int lgff_init(struct hid_device* hid)
 
 	/* Check that the report looks ok */
 	report = list_entry(report_list->next, struct hid_report, list);
-	if (!report) {
-		err_hid("NULL output report");
-		return -1;
-	}
-
 	field = report->field[0];
 	if (!field) {
 		err_hid("NULL field");
