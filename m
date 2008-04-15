Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYDOR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYDOR6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 13:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYDOR6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 13:58:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:39046 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751190AbYDOR6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:58:42 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/42Q8y71b40QGHO/272+yVbZgu8S8JTdzZ2LqYnY
	PNaWFWxWgQy/Fo
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: build issue #469 for v2.6.25-rc8-166-g6fdf5e6 in pms.c : undefined reference to `video_usercopy'
Date: Tue, 15 Apr 2008 19:58:39 +0200
User-Agent: KMail/1.9.7
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <200804061448.42888.toralf.foerster@gmx.de> <20080415135933.1a85fd2e@gaivota>
In-Reply-To: <20080415135933.1a85fd2e@gaivota>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804151958.39524.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Tuesday 15 April 2008 18:59:33 Mauro Carvalho Chehab wrote :
> Hi Toralf,
> Please try the enclosed patch. It should fix the issue.
...
> ---
> Fix build when CONFIG_VIDEO_PMS=y and VIDEO_V4L2_COMMON=m
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> 
> 
> Cheers,
> Mauro

The patch works, thx :)

However I had to change the files manually b/c the patch utility didn't
accepted your input, therefore here's the diff output from my side:

tfoerste@n22 ~/devel/linux-2.6 $ git diff drivers/media/Kconfig
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 1195069..a91f768 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -30,7 +30,7 @@ config VIDEO_V4L2_COMMON
        depends on (I2C || I2C=n) && VIDEO_DEV
        default (I2C || I2C=n) && VIDEO_DEV

-config VIDEO_V4L1
+config VIDEO_ALLOW_V4L1
        bool "Enable Video For Linux API 1 (DEPRECATED)"
        depends on VIDEO_DEV && VIDEO_V4L2_COMMON
        default VIDEO_DEV && VIDEO_V4L2_COMMON
@@ -60,9 +60,14 @@ config VIDEO_V4L1_COMPAT

 config VIDEO_V4L2
        bool
+       tristate
        depends on VIDEO_DEV && VIDEO_V4L2_COMMON
        default VIDEO_DEV && VIDEO_V4L2_COMMON

+config VIDEO_V4L1
+       tristate
+       depends on VIDEO_DEV && VIDEO_V4L2_COMMON && VIDEO_ALLOW_V4L1
+       default VIDEO_DEV && VIDEO_V4L2_COMMON && VIDEO_ALLOW_V4L1
 source "drivers/media/video/Kconfig"

 source "drivers/media/radio/Kconfig"

-- 
MfG/Sincerely

Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
