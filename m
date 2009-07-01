Return-Path: <linux-kernel-owner+w=401wt.eu-S1764753AbZGAA46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764753AbZGAA46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761427AbZGAAem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:42 -0400
Received: from kroah.org ([198.145.64.141]:60299 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759924AbZGAAek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:24 2009
Message-Id: <20090701002424.559577537@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       John Stoffel <john@stoffel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 037/108] sym53c8xx: ratelimit parity errors
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=sym53c8xx-ratelimit-parity-errors.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Stoffel <john@stoffel.org>

commit 75be63bcf73ebdd1fdc1d49f6bf2d1326a1ba7de upstream.

This makes a huge difference when you have a serial console on bootup to limit
these messages to a sane number.

Signed-off-by: John Stoffel <john@stoffel.org>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -2312,8 +2312,9 @@ static void sym_int_par (struct sym_hcb 
 	int phase	= cmd & 7;
 	struct sym_ccb *cp	= sym_ccb_from_dsa(np, dsa);
 
-	printf("%s: SCSI parity error detected: SCR1=%d DBC=%x SBCL=%x\n",
-		sym_name(np), hsts, dbc, sbcl);
+	if (printk_ratelimit())
+		printf("%s: SCSI parity error detected: SCR1=%d DBC=%x SBCL=%x\n",
+			sym_name(np), hsts, dbc, sbcl);
 
 	/*
 	 *  Check that the chip is connected to the SCSI BUS.


