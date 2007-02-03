Return-Path: <linux-kernel-owner+w=401wt.eu-S1946245AbXBCChQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946245AbXBCChQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946232AbXBCChE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:37:04 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52785 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946233AbXBCCgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:36:49 -0500
Message-Id: <20070203023749.312721000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:06 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Philippe De Muyter <phdm@macqel.be>,
       Mark A Greer <mgreer@mvista.com>
Subject: [patch 02/59] i2c/m41t00: Do not forget to write year
Content-Disposition: inline; filename=i2c-m41t00-do-not-forget-to-write-year.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Philippe De Muyter <phdm@macqel.be>

m41t00.c forgets to set the year field in set_rtc_time; fix that.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Acked-by: Mark A. Greer <mgreer@mvista.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
Merged in 2.6.20-rc4:
http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=81ffbc04a8ea06c4bea534154f49ed598013ee6b

 drivers/i2c/chips/m41t00.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.19.2.orig/drivers/i2c/chips/m41t00.c
+++ linux-2.6.19.2/drivers/i2c/chips/m41t00.c
@@ -209,6 +209,7 @@ m41t00_set(void *arg)
 	buf[m41t00_chip->hour] = (buf[m41t00_chip->hour] & ~0x3f) | (hour& 0x3f);
 	buf[m41t00_chip->day] = (buf[m41t00_chip->day] & ~0x3f) | (day & 0x3f);
 	buf[m41t00_chip->mon] = (buf[m41t00_chip->mon] & ~0x1f) | (mon & 0x1f);
+	buf[m41t00_chip->year] = year;
 
 	if (i2c_master_send(save_client, wbuf, 9) < 0)
 		dev_err(&save_client->dev, "m41t00_set: Write error\n");

--
