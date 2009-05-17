Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZEQPEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZEQPEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 11:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZEQPE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 11:04:29 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:17003 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZEQPE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 11:04:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WHzN0rAlDja8tKh57z6nREk4k/D8Vfiwrr1oAVzAxkqG3Fz81OmsFx6KzYGndhgJMj
         KyWrs6UtUD7JrpmNqM6ogd9tyXoVzWD+10l7auRhs0na1C4eozgx7bcx8YU1ZtmTfHcm
         d2Vk1VBUh3Q+M02NT8xRXc0xX2spKPyXlrfiY=
MIME-Version: 1.0
Date: Sun, 17 May 2009 23:04:27 +0800
Message-ID: <af3ea28a0905170804n500126e4tc425dafd9fcaa68a@mail.gmail.com>
Subject: fix rtc_cmos bug
From: ye janboe <janboe.ye@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: rjw@sisk.pl, bunk@kernel.org, bugme-janitors@lists.osdl.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    fix  Bug 13326 -  Null pointer dereference in rtc-cmos driver
    http://bugzilla.kernel.org/show_bug.cgi?id=13326

    Signed-off-by: janboe <janboe.ye@gmail.com>

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 23e10b6..da132f6 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1179,7 +1179,9 @@ static int __init cmos_init(void)
        int retval = 0;

 #ifdef CONFIG_PNP
-       pnp_register_driver(&cmos_pnp_driver);
+       retval = pnp_register_driver(&cmos_pnp_driver);
+       if (retval)
+               return retval;
 #endif

        if (!cmos_rtc.dev)
