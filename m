Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbZCNAv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbZCNAv0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbZCNAUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:20:22 -0400
Received: from kroah.org ([198.145.64.141]:35126 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754112AbZCNAT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:53 2009
Message-Id: <20090314000753.783424694@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:44 -0700
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
       alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>
Subject: [patch 96/96] hwmon: (it87) Properly decode -128 degrees C temperature
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-properly-decode-128-degrees-c-temperature.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit e267d25005c861fe6afda343f044536342c9f8b4 upstream

The it87 driver is reporting -128 degrees C as +128 degrees C.
That's not a terribly likely temperature value but let's still
get it right, especially when it simplifies the code.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/hwmon/it87.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -207,7 +207,7 @@ static inline u16 FAN16_TO_REG(long rpm)
 
 #define TEMP_TO_REG(val) (SENSORS_LIMIT(((val)<0?(((val)-500)/1000):\
 					((val)+500)/1000),-128,127))
-#define TEMP_FROM_REG(val) (((val)>0x80?(val)-0x100:(val))*1000)
+#define TEMP_FROM_REG(val) ((val) * 1000)
 
 #define PWM_TO_REG(val)   ((val) >> 1)
 #define PWM_FROM_REG(val) (((val)&0x7f) << 1)
@@ -261,9 +261,9 @@ struct it87_data {
 	u8 has_fan;		/* Bitfield, fans enabled */
 	u16 fan[5];		/* Register values, possibly combined */
 	u16 fan_min[5];		/* Register values, possibly combined */
-	u8 temp[3];		/* Register value */
-	u8 temp_high[3];	/* Register value */
-	u8 temp_low[3];		/* Register value */
+	s8 temp[3];		/* Register value */
+	s8 temp_high[3];	/* Register value */
+	s8 temp_low[3];		/* Register value */
 	u8 sensor;		/* Register value */
 	u8 fan_div[3];		/* Register encoding, shifted right */
 	u8 vid;			/* Register encoding, combined */


