Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab0CCHId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 02:08:33 -0500
Received: from mail-bw0-f212.google.com ([209.85.218.212]:55628 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab0CCHIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 02:08:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=XzGNfk6gOUV/mK27B0GK142uTIE0TRqz7okgtrshNvqTQK6TbmKC5w/u75wmXF13Wi
         Apf0NyLXstc4rYQAKs7rIspmHAi5pk/0h0ZurnMNLF7RnjxiUoykaC/hxDhtsO8It8Lx
         8OHbW4Ohl24TOCqBhouVIXCPqIWVUo7bekqkg=
Date: Wed, 3 Mar 2010 10:08:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] oxygen: change || to &&
Message-ID: <20100303070818.GD5086@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Clemens Ladisch <clemens@ladisch.de>, alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the original code the condition was always true (hopefully) because
WM8776_HPLVOL is zero.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/sound/pci/oxygen/xonar_wm87x6.c b/sound/pci/oxygen/xonar_wm87x6.c
index 7754db1..dbc4b89 100644
--- a/sound/pci/oxygen/xonar_wm87x6.c
+++ b/sound/pci/oxygen/xonar_wm87x6.c
@@ -68,7 +68,7 @@ static void wm8776_write(struct oxygen *chip,
 			 OXYGEN_SPI_CEN_LATCH_CLOCK_LO,
 			 (reg << 9) | value);
 	if (reg < ARRAY_SIZE(data->wm8776_regs)) {
-		if (reg >= WM8776_HPLVOL || reg <= WM8776_DACMASTER)
+		if (reg >= WM8776_HPLVOL && reg <= WM8776_DACMASTER)
 			value &= ~WM8776_UPDATE;
 		data->wm8776_regs[reg] = value;
 	}
