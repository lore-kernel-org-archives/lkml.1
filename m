Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbYCMPvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbYCMPvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYCMPvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:51:36 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:45905 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYCMPvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:51:35 -0400
Message-ID: <47D94D81.5090108@tiscali.nl>
Date: Thu, 13 Mar 2008 16:51:29 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: pe1rxq@amsat.org, linux-usb@vger.kernel.org, video4linux-list@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] logical-bitwise & confusion in se401_init() (was: logical-bitwise
 & confusion in se401_init()?)
References: <47D47257.9090204@tiscali.nl> <20080313120602.6920a621@gaivota>
In-Reply-To: <20080313120602.6920a621@gaivota>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> On Mon, 10 Mar 2008 00:27:19 +0100
> Roel Kluin <12o3l@tiscali.nl> wrote:
> 
>> drivers/media/video/se401.c:1282:
>>
>> if (!cp[2] && SE401_FORMAT_BAYER) {
>>
>> shouldn't this be 'if (!(cp[2] & SE401_FORMAT_BAYER)) {'
>> drivers/media/video/se401.h:52:
>>
>> #define SE401_FORMAT_BAYER       0x40
> 
> I don't have this driver, but this seems to be the proper fix.
---
logical-bitwise & confusion, SE401_FORMAT_BAYER is defined 0x40

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
index d5d7d6c..952c9bd 100644
--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -1279,7 +1279,7 @@ static int se401_init(struct usb_se401 *se401, int button)
 	rc=se401_sndctrl(0, se401, SE401_REQ_GET_HEIGHT, 0, cp, sizeof(cp));
 	se401->cheight=cp[0]+cp[1]*256;
 
-	if (!cp[2] && SE401_FORMAT_BAYER) {
+	if (!cp[2] & SE401_FORMAT_BAYER) {
 		err("Bayer format not supported!");
 		return 1;
 	}
