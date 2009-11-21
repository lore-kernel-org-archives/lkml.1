Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZKUSty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZKUSty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZKUStw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:49:52 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39295 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZKUStv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:49:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rc/js4yuHSrm4Mly5U8HwaGzBrabukMVw8aVsThhbLtPs6EArSYuZAnptmsQXfrZwt
         wUmNuAJGYWLr/6GFXtWJdM8AhEv6y6xAdXTVptmV08jb9N5z3L6cKnRZGSRv2PyveU+g
         x1Y8ZvVuATDaTC9uT/ZEUJixsdbxtn/LyZlRM=
Message-ID: <4B083957.3040500@gmail.com>
Date: Sat, 21 Nov 2009 20:02:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Joseph Chan <JosephChan@via.com.tw>, Scott Fang <ScottFang@viatech.com.cn>,
       linux-fbdev-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] viafb: Use sizeof struct rather than pointer
References: <4B0838F1.4090202@gmail.com>
In-Reply-To: <4B0838F1.4090202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The returned error should be negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/video/via/viafbdev.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

> Unless I am mistaken?

There was another in the same file:

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 56ec696..7b181e7 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -680,7 +680,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 		if (!viafb_gamma_table)
 			return -ENOMEM;
 		if (copy_from_user(viafb_gamma_table, argp,
-				sizeof(viafb_gamma_table))) {
+				sizeof(*viafb_gamma_table))) {
 			kfree(viafb_gamma_table);
 			return -EFAULT;
 		}
@@ -694,7 +694,7 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 			return -ENOMEM;
 		viafb_get_gamma_table(viafb_gamma_table);
 		if (copy_to_user(argp, viafb_gamma_table,
-			sizeof(viafb_gamma_table))) {
+			sizeof(*viafb_gamma_table))) {
 			kfree(viafb_gamma_table);
 			return -EFAULT;
 		}
