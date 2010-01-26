Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557Ab0AZX7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0AZX7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180Ab0AZX6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:58:53 -0500
Received: from kroah.org ([198.145.64.141]:35259 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab0AZXna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:30 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:25 2010
Message-Id: <20100126233925.746705211@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takahiro Yasui <tyasui@redhat.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Hannes Reinecke <hare@suse.de>
Subject: [37/98] [SCSI] scsi_devinfo: update Hitachi entries (v2)
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takahiro Yasui <tyasui@redhat.com>

commit 627511e3e67553b04f6917c03e39b797df210e04 upstream.

Four models, OPEN-/DF400/DF500/DISK-SUBSYSTEM, can handle REPORT_LUN,
and the BLIST_REPORTLUN2 flag needs to be set. And DF600 doesn't require
any flags because it returns ANSI 03h (SPC).

Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_devinfo.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -168,11 +168,10 @@ static struct {
 	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
-	{"HITACHI", "DF400", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
-	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HITACHI", "DF400", "*", BLIST_REPORTLUN2},
+	{"HITACHI", "DF500", "*", BLIST_REPORTLUN2},
+	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
+	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},


