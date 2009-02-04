Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbZBDSyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbZBDSyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760320AbZBDStP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:15 -0500
Received: from kroah.org ([198.145.64.141]:34350 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758210AbZBDStI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:08 -0500
Date: Wed, 4 Feb 2009 10:46:06 -0800
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
       alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 09/41] Input: atkbd - broaden the Dell DMI signatures
Message-ID: <20090204184606.GJ25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-atkbd-broaden-the-dell-dmi-signatures.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Garrett <mjg59@srcf.ucam.org>

commit 2a3ec3265741c3b2a7ebbd1b33f538e5a5583c48 upstream.

Some Dells need the dell input quirk applied but have a different vendor
string in their DMI tables. Add an extra entry to cover these machines as
well.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/keyboard/atkbd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1486,6 +1486,15 @@ static struct dmi_system_id atkbd_dmi_qu
 		.driver_data = atkbd_dell_laptop_keymap_fixup,
 	},
 	{
+		.ident = "Dell Laptop",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_dell_laptop_keymap_fixup,
+	},
+	{
 		.ident = "HP 2133",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),

