Return-Path: <linux-kernel-owner+w=401wt.eu-S935128AbZLQBZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935128AbZLQBZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763723AbZLQBVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:21:09 -0500
Received: from kroah.org ([198.145.64.141]:41442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763694AbZLQBU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:07 2009
Message-Id: <20091217011607.648675624@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Renninger <trenn@suse.de>,
       =?ISO-8859-15?q?Peter=20K=C3=BCppers?= <peter-mailbox@web.de>,
       Michael Franzl <michaelfranzl@gmx.at>, Ian Turner <vectro@vectro.org>,
       Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>
Subject: [74/90] asus-laptop: change light sens default values.
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Corentin Chary <corentincj@iksaif.net>

commit d951d4cc84e8b5ddb8e0ab81cf6a72cc73fdd668 upstream.

The light sensor disable brightness key and
/sys/class/backlight/ control. There was a lot of report
from users who didn't understand why they couldn't change their
brightness, including:

https://bugs.launchpad.net/bugs/222171
https://bugzilla.novell.com/show_bug.cgi?id=514747
http://bugzilla.kernel.org/show_bug.cgi?id=13671
http://bugzilla.kernel.org/show_bug.cgi?id=14432

Now the light sensor is disabled, and if the user want to enable
it, the level should be ok.

The funny thing is that comments where ok, not code.

Cc: stable@kernel.org
Cc: Thomas Renninger <trenn@suse.de>
Cc: Peter Küppers <peter-mailbox@web.de>
Cc: Michael Franzl <michaelfranzl@gmx.at>
Cc: Ian Turner <vectro@vectro.org>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/asus-laptop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1172,8 +1172,8 @@ static int asus_hotk_add(struct acpi_dev
 	hotk->ledd_status = 0xFFF;
 
 	/* Set initial values of light sensor and level */
-	hotk->light_switch = 1;	/* Default to light sensor disabled */
-	hotk->light_level = 0;	/* level 5 for sensor sensitivity */
+	hotk->light_switch = 0;	/* Default to light sensor disabled */
+	hotk->light_level = 5;	/* level 5 for sensor sensitivity */
 
 	if (ls_switch_handle)
 		set_light_sens_switch(hotk->light_switch);


