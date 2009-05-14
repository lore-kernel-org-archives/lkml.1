Return-Path: <linux-kernel-owner+w=401wt.eu-S1754459AbZENWpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbZENWpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZENWmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:42:06 -0400
Received: from kroah.org ([198.145.64.141]:51531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbZENWmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:42:03 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu May 14 15:35:22 2009
Message-Id: <20090514223522.005939835@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 May 2009 15:32:46 -0700
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
Subject: [patch 11/51] hwmon: (w83781d) Fix W83782D support (NULL pointer dereference)
References: <20090514223235.348540705@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-fix-w83782d-support.patch
In-Reply-To: <20090514223755.GA27019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

Commit 848ddf116b3d1711c956fac8627be12dfe8d736f upstream

Commit 360782dde00a2e6e7d9fd57535f90934707ab8a8 (hwmon: (w83781d) Stop
abusing struct i2c_client for ISA devices) broke W83782D support for
devices connected on the ISA bus. You will hit a NULL pointer
dereference as soon as you read any device attribute. Other devices,
and W83782D devices on the SMBus, aren't affected.

Reported-by: Michel Abraham
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Tested-by: Michel Abraham
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/w83781d.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -1462,7 +1462,8 @@ static struct w83781d_data *w83781d_upda
 				data->pwm[i] =
 				    w83781d_read_value(data,
 						       W83781D_REG_PWM[i]);
-				if ((data->type != w83782d || !client->driver)
+				/* Only W83782D on SMBus has PWM3 and PWM4 */
+				if ((data->type != w83782d || !client)
 				    && i == 1)
 					break;
 			}


