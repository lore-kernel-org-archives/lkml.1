Return-Path: <linux-kernel-owner+w=401wt.eu-S934679AbZIEAX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934679AbZIEAX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964817AbZIEAVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:32 -0400
Received: from kroah.org ([198.145.64.141]:42205 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934623AbZIEAVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:02 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:53 2009
Message-Id: <20090905001453.124138246@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 37/71] libata: OCZ Vertex cant do HPA
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=libata-ocz-vertex-can-t-do-hpa.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Tejun Heo <tj@kernel.org>

commit 7831387bda72af3059be48d39846d3eb6d8ce2f6 upstream.

OCZ Vertex SSD can't do HPA and not in a usual way.  It reports HPA,
allows unlocking but then fails all IOs which fall in the unlocked
area.  Quirk it so that HPA unlocking is not used for the device.

Reported by Daniel Perup in bnc#522414.

 https://bugzilla.novell.com/show_bug.cgi?id=522414

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Daniel Perup <probe@spray.se>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4271,6 +4271,9 @@ static const struct ata_blacklist_entry 
 	{ "WDC WD2500JD-00HBB0", "WD-WMAL71490727", ATA_HORKAGE_BROKEN_HPA },
 	{ "MAXTOR 6L080L4",	"A93.0500",	ATA_HORKAGE_BROKEN_HPA },
 
+	/* this one allows HPA unlocking but fails IOs on the area */
+	{ "OCZ-VERTEX",		    "1.30",	ATA_HORKAGE_BROKEN_HPA },
+
 	/* Devices which report 1 sector over size HPA */
 	{ "ST340823A",		NULL,		ATA_HORKAGE_HPA_SIZE, },
 	{ "ST320413A",		NULL,		ATA_HORKAGE_HPA_SIZE, },


