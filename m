Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbXIROyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbXIROyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbXIROyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:54:36 -0400
Received: from smtpq3.tilbu1.nb.home.nl ([213.51.146.202]:60399 "EHLO
	smtpq3.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929AbXIROyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:54:35 -0400
Message-ID: <46EFE66A.9090400@gmail.com>
Date: Tue, 18 Sep 2007 16:53:30 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Nicolas Pitre <nico@cam.org>
CC: Dmitry Torokhov <dtor_core@ameritech.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ucb1400_ts.c -- replace an interruptible sleep with an uninterruptible
 one
Content-Type: multipart/mixed;
 boundary="------------090602040104010908050200"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090602040104010908050200
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Nicolas.

Given that it's not checking for signals, I believe this one should be an 
uninterruptible sleep instead?

Signed-off-by: Rene Herman <rene.herman@gmail.com>

Rene.

--------------090602040104010908050200
Content-Type: text/plain;
 name="schedule_timeout-ucb1400_ts.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="schedule_timeout-ucb1400_ts.diff"

diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index f0cbcdb..670dd49 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -130,8 +130,7 @@ static unsigned int ucb1400_adc_read(struct ucb1400 *ucb, u16 adc_channel)
 		if (val & UCB_ADC_DAT_VALID)
 			break;
 		/* yield to other processes */
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(1);
+		schedule_timeout_uninterruptible(1);
 	}
 
 	return UCB_ADC_DAT_VALUE(val);

--------------090602040104010908050200--
