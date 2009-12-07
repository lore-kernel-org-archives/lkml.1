Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbZLGAOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbZLGAOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbZLGAOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:14:33 -0500
Received: from kroah.org ([198.145.64.141]:34832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934403AbZLGAOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:07:01 2009
Message-Id: <20091207000701.040805568@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>,
       Len Brown <len.brown@intel.com>
Subject: [117/119] acerhdf: return temperature in milidegree instead of degree
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=acerhdf-return-temperature-in-milidegree-instead-of-degree.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Feuerer <peter@piie.net>

commit 7005291706341a11c094f39a756a01c9e649e5f9 upstream.

Return temperature in milidegree instead of degree, as sysfs-api requires
the temperature in milidegree.

Signed-off-by: Peter Feuerer <peter@piie.net>
Tested-by: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/acerhdf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -61,7 +61,7 @@
  * measured by the on-die thermal monitor are within 0 <= Tj <= 90. So,
  * assume 89°C is critical temperature.
  */
-#define ACERHDF_TEMP_CRIT 89
+#define ACERHDF_TEMP_CRIT 89000
 #define ACERHDF_FAN_OFF 0
 #define ACERHDF_FAN_AUTO 1
 
@@ -69,7 +69,7 @@
  * No matter what value the user puts into the fanon variable, turn on the fan
  * at 80 degree Celsius to prevent hardware damage
  */
-#define ACERHDF_MAX_FANON 80
+#define ACERHDF_MAX_FANON 80000
 
 /*
  * Maximum interval between two temperature checks is 15 seconds, as the die
@@ -85,8 +85,8 @@ static int kernelmode;
 #endif
 
 static unsigned int interval = 10;
-static unsigned int fanon = 63;
-static unsigned int fanoff = 58;
+static unsigned int fanon = 63000;
+static unsigned int fanoff = 58000;
 static unsigned int verbose;
 static unsigned int fanstate = ACERHDF_FAN_AUTO;
 static char force_bios[16];
@@ -171,7 +171,7 @@ static int acerhdf_get_temp(int *temp)
 	if (ec_read(bios_cfg->tempreg, &read_temp))
 		return -EINVAL;
 
-	*temp = read_temp;
+	*temp = read_temp * 1000;
 
 	return 0;
 }


