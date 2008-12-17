Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760949AbYLQANs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbYLQANs (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759743AbYLQAHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:07:12 -0500
Received: from kroah.org ([198.145.64.141]:41234 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757688AbYLQAFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:05:55 -0500
Date: Tue, 16 Dec 2008 16:04:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 06/22] libata: fix Seagate NCQ+FLUSH blacklist
Message-ID: <20081217000409.GG4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-fix-seagate-ncq-flush-blacklist.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit d10d491f842243e2e3bf5a2714020f9d649e1e38 upstream.

Due to miscommunication, P/N was mistaken as firmware revision
strings.  Update it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   65 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 6 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3979,17 +3979,70 @@ static const struct ata_blacklist_entry 
 	{ "ST3160023AS",	"3.42",		ATA_HORKAGE_NONCQ },
 
 	/* Seagate NCQ + FLUSH CACHE firmware bug */
-	{ "ST31500341AS",	"9JU138",	ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD15",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST31000333AS",	"9FZ136",	ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD16",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640623AS",	"9FZ164",	ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD17",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3640323AS",	"9FZ134",	ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD18",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320813AS",	"9FZ182",	ATA_HORKAGE_NONCQ |
+	{ "ST31500341AS",	"SD19",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
-	{ "ST3320613AS",	"9FZ162",	ATA_HORKAGE_NONCQ |
+
+	{ "ST31000333AS",	"SD15",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST31000333AS",	"SD16",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST31000333AS",	"SD17",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST31000333AS",	"SD18",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST31000333AS",	"SD19",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+
+	{ "ST3640623AS",	"SD15",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640623AS",	"SD16",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640623AS",	"SD17",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640623AS",	"SD18",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640623AS",	"SD19",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+
+	{ "ST3640323AS",	"SD15",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640323AS",	"SD16",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640323AS",	"SD17",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640323AS",	"SD18",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3640323AS",	"SD19",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+
+	{ "ST3320813AS",	"SD15",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320813AS",	"SD16",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320813AS",	"SD17",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320813AS",	"SD18",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320813AS",	"SD19",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+
+	{ "ST3320613AS",	"SD15",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320613AS",	"SD16",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320613AS",	"SD17",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320613AS",	"SD18",		ATA_HORKAGE_NONCQ |
+						ATA_HORKAGE_FIRMWARE_WARN },
+	{ "ST3320613AS",	"SD19",		ATA_HORKAGE_NONCQ |
 						ATA_HORKAGE_FIRMWARE_WARN },
 
 	/* Blacklist entries taken from Silicon Image 3124/3132

