Return-Path: <linux-kernel-owner+w=401wt.eu-S1763624AbZBDTDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763624AbZBDTDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758792AbZBDStn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:43 -0500
Received: from kroah.org ([198.145.64.141]:32932 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760027AbZBDStd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:33 -0500
Date: Wed, 4 Feb 2009 10:46:54 -0800
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
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 33/41] asus-laptop: Fix the led behavior with value > 1
Message-ID: <20090204184654.GH25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="asus-laptop-fix-the-led-behavior-with-value-1.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Corentin Chary <corentincj@iksaif.net>

commit e3deda9c87ac5eef2b5d18cd0b5511370979ca26 upstream.

Fix http://bugzilla.kernel.org/show_bug.cgi?id=11613 .

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/asus-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/asus-laptop.c
+++ b/drivers/misc/asus-laptop.c
@@ -351,7 +351,7 @@ static void write_status(acpi_handle han
 	static void object##_led_set(struct led_classdev *led_cdev,	\
 				     enum led_brightness value)		\
 	{								\
-		object##_led_wk = value;				\
+		object##_led_wk = (value > 0) ? 1 : 0;			\
 		queue_work(led_workqueue, &object##_led_work);		\
 	}								\
 	static void object##_led_update(struct work_struct *ignored)	\

