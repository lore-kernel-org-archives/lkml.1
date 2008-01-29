Return-Path: <linux-kernel-owner+w=401wt.eu-S932901AbYA2Qiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932901AbYA2Qiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYA2Qin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:38:43 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46357 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbYA2Qim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:38:42 -0500
Date: Tue, 29 Jan 2008 14:38:09 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>, Hans Verkuil <hverkuil@xs4all.nl>,
       v4l-dvb-maintainer@linuxtv.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.25 regression: VIDEO_DEV=y/m, I2C=n
 compile error
Message-ID: <20080129143809.30cff2f1@gaivota>
In-Reply-To: <20080128121245.GG1001@does.not.exist>
References: <20080127185216.GB13300@does.not.exist>
	<20080127223334.696fce6e@gaivota>
	<20080128084001.GB1001@does.not.exist>
	<Pine.LNX.4.58.0801280053010.15635@shell4.speakeasy.net>
	<20080128094912.1848eacd@gaivota>
	<20080128121245.GG1001@does.not.exist>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.1; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 14:12:45 +0200
Adrian Bunk <bunk@kernel.org> wrote:

>
> Why does anyone want to introduce such a weird syntax for something 
> that already works with the simple
> 
> 	depends on I2C || I2C=n
> 
This didn't work.

Something weird is happening here... It seems that "menuconfig I2C" is not
working properly, or maybe I'm blind ;)

I'm trying to generate the patch for fixing this issue. However, every time I
add a dependency for I2C, I got wrong results:

make oldconfig >/dev/null; grep CONFIG_VIDEO_DEV .config; grep CONFIG_I2C= .config; grep CONFIG_VIDEO_V4L2_COMMON .config
CONFIG_VIDEO_DEV=y
CONFIG_I2C=m
CONFIG_VIDEO_V4L2_COMMON=y

---

Trying to isolate the problem, I'm applying this patch to define
CONFIG_VIDEO_V4L2_COMMON:


diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 8f4a453..20a5d26 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -25,6 +25,11 @@ config VIDEO_DEV
          To compile this driver as a module, choose M here: the
          module will be called videodev.

+config VIDEO_V4L2_COMMON
+       tristate
+       depends on I2C
+       default y
+
 config VIDEO_V4L1
        bool "Enable Video For Linux API 1 (DEPRECATED)"
        depends on VIDEO_DEV

---

Shouldn't VIDEO_V4L2_COMMON be equal to 'm', due to I2C dependency?

Cheers,
Mauro
