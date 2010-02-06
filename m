Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0BFIoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 03:44:44 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:52532 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab0BFIol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 03:44:41 -0500
Date: Sat, 6 Feb 2010 09:44:39 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 9/11] drivers/scsi: Correct NULL test
Message-ID: <Pine.LNX.4.64.1002060944160.8092@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

fcf is tested in the line just below, so the first test is not needed.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression *x;
expression e;
identifier l;
@@

if (x == NULL || ...) {
    ... when forall
    return ...; }
... when != goto l;
    when != x = e
    when != &x
*x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/fcoe/libfcoe.c         |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 9823291..9b634bd 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -941,8 +941,6 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	u32	desc_mask;
 
 	LIBFCOE_FIP_DBG(fip, "Clear Virtual Link received\n");
-	if (!fcf)
-		return;
 	if (!fcf || !fc_host_port_id(lport->host))
 		return;
 
