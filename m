Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZBJTNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZBJTNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbZBJTD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:03:58 -0500
Received: from kroah.org ([198.145.64.141]:53947 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755811AbZBJTD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:03:56 -0500
Date: Tue, 10 Feb 2009 11:00:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Corentin Chary <corentincj@iksaif.net>,
       Len Brown <len.brown@intel.com>
Subject: [patch 29/53] asus_acpi: Add R1F support
Message-ID: <20090210190042.GD14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="asus_acpi-add-r1f-support.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Corentin Chary <corentincj@iksaif.net>

commit 1021e2119eb33a990a2b9ff1410805dd9bdf7997 upstream.

Add R1F support

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/asus_acpi.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/acpi/asus_acpi.c
+++ b/drivers/acpi/asus_acpi.c
@@ -143,6 +143,7 @@ struct asus_hotk {
 							 S1300N, S5200N*/
 		A4S,            /* Z81sp */
 		F3Sa,		/* (Centrino) */
+		R1F,
 		END_MODEL
 	} model;		/* Models currently supported */
 	u16 event_count[128];	/* Count for each event TODO make this better */
@@ -420,7 +421,18 @@ static struct model_data model_conf[END_
 		.display_get	= "\\ADVG",
 		.display_set	= "SDSP",
 	},
-
+	{
+		.name = "R1F",
+		.mt_bt_switch = "BLED",
+		.mt_mled = "MLED",
+		.mt_wled = "WLED",
+		.mt_lcd_switch = "\\Q10",
+		.lcd_status = "\\GP06",
+		.brightness_set = "SPLV",
+		.brightness_get = "GPLV",
+		.display_set = "SDSP",
+		.display_get = "\\INFB"
+	}
 };
 
 /* procdir we use */
@@ -1165,6 +1177,8 @@ static int asus_model_match(char *model)
 		return W3V;
 	else if (strncmp(model, "W5A", 3) == 0)
 		return W5A;
+	else if (strncmp(model, "R1F", 3) == 0)
+		return R1F;
 	else if (strncmp(model, "A4S", 3) == 0)
 		return A4S;
 	else if (strncmp(model, "F3Sa", 4) == 0)

