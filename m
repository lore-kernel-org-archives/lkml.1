Return-Path: <linux-kernel-owner+w=401wt.eu-S1751105AbXBNBqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbXBNBqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXBNBqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:46:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:41984 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbXBNBqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:46:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jnhIr5GuecxsQoZSzwNdMih8s1JNBFMzS+Cy+dVgpIdiAGMUg47u9B4qvfUN1VIfVP/kzgvAerx4tuxr6vWdAqSiIb9XhP4/gFNSWJ6CQddEODx14xy0iql599qTMzYV8mM5jR97GWnuvCbmWtCyGvPSaFSQsVBvfnXe0OR83qk=
Message-ID: <e13597370702131746q6a5d8e79i2341f5eb9c59bf6e@mail.gmail.com>
Date: Wed, 14 Feb 2007 04:46:41 +0300
From: "Eugene Ilkov" <e.ilkov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20 mmc: problem with highspeed SD card
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have I/O errors with Transcend SD highspeed card 2GB/150x when it's
mounted in r/w mode (cardreader on sharp sl-c1000)
It works well  if I reverse mmcv4 patch commited to 2.6.19-git2
(http://lkml.org/lkml/2006/10/4/27)
I'm not experienced in mmc, but I figured out that problem is
somewhere in mmc_read_switch_caps() and when i change cmd.arg value
from 0x80FFFFF1 to 0x00FFFFF1 it works fine too
What argument should have SD_SWITCH opcode?


--- linux-2.6.20/drivers/mmc/mmc.c      2007-02-14 04:13:23.644408219 +0300
+++ linux-2.6.20.g/drivers/mmc/mmc.c    2007-02-14 04:19:09.642624022 +0300
@@ -1225,7 +1225,7 @@
                memset(&cmd, 0, sizeof(struct mmc_command));

                cmd.opcode = SD_SWITCH;
-               cmd.arg = 0x80FFFFF1;
+               cmd.arg = 0x00FFFFF1;
                cmd.flags = MMC_RSP_R1 | MMC_CMD_ADTC;

                memset(&data, 0, sizeof(struct mmc_data));
