Return-Path: <linux-kernel-owner+w=401wt.eu-S1161379AbXDKW4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161379AbXDKW4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161384AbXDKW4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:56:03 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55879 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161379AbXDKWzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:55:55 -0400
Date: Wed, 11 Apr 2007 15:53:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 31/31] Update libata drive blacklist to the latest from
	2.6.21
Message-ID: <20070411225308.GF24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="update-libata-drive-blacklist-to-the-latest-from-2.6.21.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
Update libata drive blacklist to the latest from 2.6.21

Removes one duplicate entry from blacklist table, adds several
entries for drives with broken NCQ.

[diff between 2.6.20 and 2.6.21-rc6, with one entry removed
 that required new libata features]

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3316,7 +3316,6 @@ static const struct ata_blacklist_entry 
 	{ "WPI CDD-820", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SC-148C", NULL,	ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SC",	NULL,		ATA_HORKAGE_NODMA },
-	{ "SanDisk SDP3B-64", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",NULL,ATA_HORKAGE_NODMA },
 	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
@@ -3326,6 +3325,17 @@ static const struct ata_blacklist_entry 
 	/* Devices where NCQ should be avoided */
 	/* NCQ is slow */
         { "WDC WD740ADFD-00",   NULL,		ATA_HORKAGE_NONCQ },
+	/* http://thread.gmane.org/gmane.linux.ide/14907 */
+	{ "FUJITSU MHT2060BH",	NULL,		ATA_HORKAGE_NONCQ },
+	/* NCQ is broken */
+	{ "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
+	/* NCQ hard hangs device under heavier load, needs hard power cycle */
+	{ "Maxtor 6B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
+	/* Blacklist entries taken from Silicon Image 3124/3132
+	   Windows driver .inf file - also several Linux problem reports */
+	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
+	{ "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
+	{ "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },
 
 	/* Devices with NCQ limits */
 

-- 
