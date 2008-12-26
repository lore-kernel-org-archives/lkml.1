Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbYLZFXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbYLZFXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 00:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYLZFXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 00:23:12 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:19710 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbYLZFXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 00:23:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=DwonUobSS7otWXzDubMwl9egwiEHiY3fAVEKOGSDidJJ6D9Sw6mYkELMBqSRtfIiNR
         lku+XcPVGH7InfRS6pd2F65xwepP8SpQuGNRHjyTlmOk17JQwHpqhEv9+W0gakkp6IiS
         gJqjXrSdRdgaq1WcZGrlRmcGbfm5GAsR7UPuw=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: david-b@pacbell.net, Magnus Damm <magnus.damm@gmail.com>,
       lethal@linux-sh.org, akpm@linux-foundation.org
Date: Fri, 26 Dec 2008 14:21:21 +0900
Message-Id: <20081226052121.6472.22847.sendpatchset@rx1.opensource.se>
Subject: [PATCH] gpiolib: request fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Fix request related issues in gpiolib such as:
 - fix request-already-requested handling in gpio_request()
 - clear FLAG_REQUESTED on request error in gpio_direction_input()
 - clear FLAG_REQUESTED on request error in gpio_direction_output()

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/gpio/gpiolib.c |    3 +++
 1 file changed, 3 insertions(+)

--- 0001/drivers/gpio/gpiolib.c
+++ work/drivers/gpio/gpiolib.c	2008-12-26 13:09:50.000000000 +0900
@@ -789,6 +789,7 @@ int gpio_request(unsigned gpio, const ch
 	} else {
 		status = -EBUSY;
 		module_put(chip->owner);
+		goto done;
 	}
 
 	if (chip->request) {
@@ -924,6 +925,7 @@ int gpio_direction_input(unsigned gpio)
 			/* and it's not available to anyone else ...
 			 * gpio_request() is the fully clean solution.
 			 */
+			clear_bit(FLAG_REQUESTED, &desc->flags);
 			goto lose;
 		}
 	}
@@ -977,6 +979,7 @@ int gpio_direction_output(unsigned gpio,
 			/* and it's not available to anyone else ...
 			 * gpio_request() is the fully clean solution.
 			 */
+			clear_bit(FLAG_REQUESTED, &desc->flags);
 			goto lose;
 		}
 	}
