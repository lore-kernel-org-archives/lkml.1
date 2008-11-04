Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbYKDX50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbYKDX50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:57:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757038AbYKDXlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:41:10 -0500
Received: from ns1.suse.de ([195.135.220.2]:47956 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947AbYKDXlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:41:08 -0500
Date: Tue, 4 Nov 2008 15:33:30 -0800
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
       alan@lxorguk.ukuu.org.uk, Dmitry Torokhov <dtor@mail.ru>,
       Matthew Garrett <mjg@redhat.com>
Subject: [patch 53/57] Input: atkbd - expand Latitudes force release quirk
	to other Dells
Message-ID: <20081104233330.GB659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-atkbd-expand-latitude-s-force-release-quirk-to-other-dells.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Matthew Garrett <mjg59@srcf.ucam.org>

commit 61579ba83934d397a4fa2bb7372de9ae112587d5 upstream.

Input: atkbd - expand Latitude's force release quirk to other Dells

Dell laptops fail to send key up events for several of their special
keys. There's an existing quirk in the kernel to handle this, but it's
limited to the Latitude range. This patch extends it to cover all
portable Dells.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/keyboard/atkbd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -834,10 +834,10 @@ static void atkbd_disconnect(struct seri
 }
 
 /*
- * Most special keys (Fn+F?) on Dell Latitudes do not generate release
+ * Most special keys (Fn+F?) on Dell laptops do not generate release
  * events so we have to do it ourselves.
  */
-static void atkbd_latitude_keymap_fixup(struct atkbd *atkbd)
+static void atkbd_dell_laptop_keymap_fixup(struct atkbd *atkbd)
 {
 	const unsigned int forced_release_keys[] = {
 		0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8f, 0x93,
@@ -1461,13 +1461,13 @@ static int __init atkbd_setup_fixup(cons
 
 static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
 	{
-		.ident = "Dell Latitude series",
+		.ident = "Dell Laptop",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
 		},
 		.callback = atkbd_setup_fixup,
-		.driver_data = atkbd_latitude_keymap_fixup,
+		.driver_data = atkbd_dell_laptop_keymap_fixup,
 	},
 	{
 		.ident = "HP 2133",

-- 
