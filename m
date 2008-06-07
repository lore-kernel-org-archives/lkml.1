Return-Path: <linux-kernel-owner+w=401wt.eu-S1762198AbYFGBOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762198AbYFGBOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759934AbYFGBJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:08 -0400
Received: from sous-sol.org ([216.99.217.87]:42379 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760217AbYFGBJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:01 -0400
Message-Id: <20080607010600.773462377@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:29 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>, Ben Gardner <bgardner@wabtec.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 14/50] i2c/max6875: Really prevent 24RF08 corruption
Content-Disposition: inline; filename=i2c-max6875-really-prevent-24rf08-corruption.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jean Delvare <khali@linux-fr.org>

commit 70455e790391dac85d9b483a9e286a40df1ecc7f in upstream

i2c-core takes care of the possible corruption of 24RF08 chips for
quite some times, so device drivers no longer need to do it. And they
really should not, as applying the prevention twice voids it.

I thought that I had fixed all drivers long ago but apparently I had
missed that one.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Ben Gardner <bgardner@wabtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/i2c/chips/max6875.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/i2c/chips/max6875.c
+++ b/drivers/i2c/chips/max6875.c
@@ -207,9 +207,6 @@ static int max6875_detect(struct i2c_ada
 	fake_client->flags = 0;
 	strlcpy(fake_client->name, "max6875 subclient", I2C_NAME_SIZE);
 
-	/* Prevent 24RF08 corruption (in case of user error) */
-	i2c_smbus_write_quick(real_client, 0);
-
 	if ((err = i2c_attach_client(real_client)) != 0)
 		goto exit_kfree2;
 

-- 
