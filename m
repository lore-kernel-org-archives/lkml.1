Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbZG1XGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbZG1XGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755795AbZG1XGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:06:53 -0400
Received: from kroah.org ([198.145.64.141]:43038 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941AbZG1XEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:04:07 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 15:59:45 2009
Message-Id: <20090728225944.940144185@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 15:58:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Giuseppe Mazzotta <g.mazzotta@iragan.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 27/37] Input: wistron_btns - recognize Maxdata Pro 7000 notebooks
References: <20090728225828.431071451@mini.kroah.org>
Content-Disposition: inline; filename=input-wistron_btns-recognize-maxdata-pro-7000-notebooks.patch
In-Reply-To: <20090728230145.GA10486@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Giuseppe Mazzotta <g.mazzotta@iragan.com>

commit e705cee427e319665969ef7ac664f3612dec8899 upstream.

This patch adds DMI information to automatically load the correct
layout for the Maxdata Pro 7000X/DX notebook models. Such notebooks
are clones of Fujitsu Amilo V2000, the hook for the v2000 is being
used and I have tested that perfectly works.

The immediate result of integrating this patch is that the five
special buttons will work on these specific notebook models and that
the RF killswitch will not be activated after suspend. This patch
definitively obsoletes the fsam7400 module which I was still needing
to enable wifi and to fix the RF killswitch suspend problem; in the
current 2.6.30 kernel it is necessary to load the wistron_btns module
with options 'force=1 keymap=1557/MS2141', which was not anyway a
complete workaround.

Signed-off-by: Giuseppe Mazzotta <g.mazzotta@iragan.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/misc/wistron_btns.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -627,6 +627,15 @@ static struct dmi_system_id dmi_ids[] __
 	},
 	{
 		.callback = dmi_matched,
+		.ident = "Maxdata Pro 7000 DX",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MAXDATA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Pro 7000"),
+		},
+		.driver_data = keymap_fs_amilo_pro_v2000
+	},
+	{
+		.callback = dmi_matched,
 		.ident = "Fujitsu N3510",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),


