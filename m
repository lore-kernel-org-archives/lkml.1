Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbZAWBbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbZAWBbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759420AbZAWBP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:59 -0500
Received: from kroah.org ([198.145.64.141]:50746 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760247AbZAWBPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:10 -0500
Date: Thu, 22 Jan 2009 17:12:42 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Alistair John Strachan <alistair@devzero.co.uk>,
       Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>
Subject: [patch 33/46] hwmon: (abituguru3) Fix CONFIG_DMI=n fallback to
	probe
Message-ID: <20090123011242.GH19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-fix-config_dmi-n-fallback-to-probe.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alistair John Strachan <alistair@devzero.co.uk>

commit 46a5f173fc88ffc22651162033696d8a9fbcdc5c upstream.

When CONFIG_DMI is not enabled, dmi detection should flag that no board
could be detected (err=1) rather than another error condition (err<0).

This fixes the fallback to manual probing for all motherboards, even
those without DMI strings, when CONFIG_DMI=n.

Signed-off-by: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/abituguru3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/abituguru3.c
+++ b/drivers/hwmon/abituguru3.c
@@ -1153,7 +1153,7 @@ static int __init abituguru3_dmi_detect(
 
 static inline int abituguru3_dmi_detect(void)
 {
-	return -ENODEV;
+	return 1;
 }
 
 #endif /* CONFIG_DMI */

