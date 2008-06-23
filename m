Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYFWXIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYFWXIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYFWXHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:07:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:44468 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYFWXHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:07:08 -0400
Date: Mon, 23 Jun 2008 16:04:48 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Mark M. Hoffman" <mhoffman@lightlink.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 09/10] hwmon: (adt7473) Initialize max_duty_at_overheat
	before use
Message-ID: <20080623230448.GC29853@suse.de>
References: <20080623225737.837265824@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="patch-hwmon-initialize-max_duty_at_overheat-before-use.patch"
In-Reply-To: <20080623230417.GA29853@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25.9-stable review patch.  If anyone has any objections, please let
us know.

------------------ 
From: Jean Delvare <khali@linux-fr.org>

commit ed4ec814e45ae8b1596aea0a29b92f6c3614acaa upstream

data->max_duty_at_overheat is not updated in adt7473_update_device,
so it might be used before it is initialized (if the user reads from
sysfs file max_duty_at_crit before writing to it.)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Darrick J. Wong <djwong@us.ibm.com>
Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/hwmon/adt7473.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hwmon/adt7473.c
+++ b/drivers/hwmon/adt7473.c
@@ -309,6 +309,9 @@ no_sensor_update:
 						ADT7473_REG_PWM_BHVR(i));
 	}
 
+	i = i2c_smbus_read_byte_data(client, ADT7473_REG_CFG4);
+	data->max_duty_at_overheat = !!(i & ADT7473_CFG4_MAX_DUTY_AT_OVT);
+
 	data->limits_last_updated = local_jiffies;
 	data->limits_valid = 1;
 

-- 
