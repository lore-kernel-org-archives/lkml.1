Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYIICcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYIICcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 22:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYIICb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 22:31:59 -0400
Received: from smtpoutwbe07.prod.mesa1.secureserver.net ([208.109.78.209]:54612
	"HELO smtpoutwbe07.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751811AbYIICb7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 22:31:59 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2008 22:31:58 EDT
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Originating-IP: 206.15.73.2
User-Agent: Web-Based Email 4.14.3
Message-Id: <20080908192518.2473bd03aebb90616c9dd57ad0673876.061e21e3ac.wbe@email.secureserver.net>
From: q-newsgroup@qypea.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Re: fbcon: replace =?UTF-8?Q?mono=5Fcol=20macro=20with=20static?=
 =?UTF-8?Q?=20inline?=
Date: Mon, 08 Sep 2008 19:25:18 -0700
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 22af89aa0c0b4012a7431114a340efd3665a7617 changed the order of
operations for computing monochrome color values. This generates
0xffff000f instead of 0x0000000f for a 4 bit monochrome color, leading
to image corruption if it is passed to cfb_imageblit or other similar
functions.
Here's a quick patch to fix it up.
David Winn

PS: Please CC me with any replies. Thanks

diff --git a/drivers/video/console/fbcon.h
b/drivers/video/console/fbcon.h
index a6e38e9..89a3468 100644
--- a/drivers/video/console/fbcon.h
+++ b/drivers/video/console/fbcon.h
@@ -110,7 +110,7 @@ static inline int mono_col(const struct fb_info
*info)
        __u32 max_len;
        max_len = max(info->var.green.length, info->var.red.length);
        max_len = max(info->var.blue.length, max_len);
-       return ~(0xfff << (max_len & 0xff));
+       return (~(0xfff << max_len)) & 0xff;
 }

 static inline int attr_col_ec(int shift, struct vc_data *vc,

