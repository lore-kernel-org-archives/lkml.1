Return-Path: <linux-kernel-owner+w=401wt.eu-S1764323AbYHDU31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764323AbYHDU31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764285AbYHDU27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:28:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:46019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763843AbYHDU26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:28:58 -0400
Date: Mon, 4 Aug 2008 13:16:07 -0700
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
       alan@lxorguk.ukuu.org.uk, Zhang Rui <rui.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>, Len Brown <len.brown@intel.com>
Subject: [patch 23/33] ACPI: update thermal temperature
Message-ID: <20080804201607.GX1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-update-thermal-temperature.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Zhang, Rui <rui.zhang@intel.com>

commit 76ecb4f2d7ea5c3aac8970b9529775316507c6d2 upstream

Fix the problem that thermal_get_temp returns the cached value,
which causes the temperature in generic thermal never updates.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/thermal.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -891,10 +891,15 @@ static void acpi_thermal_check(void *dat
 static int thermal_get_temp(struct thermal_zone_device *thermal, char *buf)
 {
 	struct acpi_thermal *tz = thermal->devdata;
+	int result;
 
 	if (!tz)
 		return -EINVAL;
 
+	result = acpi_thermal_get_temperature(tz);
+	if (result)
+		return result;
+
 	return sprintf(buf, "%ld\n", KELVIN_TO_MILLICELSIUS(tz->temperature));
 }
 

-- 
