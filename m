Return-Path: <linux-kernel-owner+w=401wt.eu-S1751969AbZLaMQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbZLaMQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 07:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbZLaMQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 07:16:32 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:1078 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZLaMQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 07:16:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xiXCcoQajsKi2jBvLEBEdRH5hbdv/ryuOvMQQDvNCccl9wU1iwy7iSIomvVJhxA9zQ
         cUVXGcf+oE9bzZnXSXdoLWrazgIqgnbNguqCa8JfBkNsxzqSaG1TkMGPytbu7RROXdhc
         qyrxlbko6zuGxBa93x5Yauqsvh7kS+7syVqDc=
Message-ID: <4B3C96DF.8060903@gmail.com>
Date: Thu, 31 Dec 2009 13:19:43 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Input: &&/|| confusion in gf2k_connect()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This always evaluates to true.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/input/joystick/gf2k.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

I am not 100% certain, but wasn't this intended?

diff --git a/drivers/input/joystick/gf2k.c b/drivers/input/joystick/gf2k.c
index 67c207f..45ac70e 100644
--- a/drivers/input/joystick/gf2k.c
+++ b/drivers/input/joystick/gf2k.c
@@ -277,7 +277,7 @@ static int gf2k_connect(struct gameport *gameport, struct gameport_driver *drv)
 	}
 
 #ifdef RESET_WORKS
-	if ((gf2k->id != (GB(19,2,0) | GB(15,3,2) | GB(12,3,5))) ||
+	if ((gf2k->id != (GB(19,2,0) | GB(15,3,2) | GB(12,3,5))) &&
 	    (gf2k->id != (GB(31,2,0) | GB(27,3,2) | GB(24,3,5)))) {
 		err = -ENODEV;
 		goto fail2;
