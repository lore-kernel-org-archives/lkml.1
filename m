Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbXLLSkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbXLLSkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbXLLSkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:40:33 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55426 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755336AbXLLSka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:40:30 -0500
Date: Wed, 12 Dec 2007 19:40:32 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com
Subject: [2.6 patch] drivers/media/Makefile: always enter video/
Message-ID: <20071212184032.GE10069@stusta.de>
References: <200712120934.46156.toralf.foerster@gmx.de> <475FE553.4020702@linuxtv.org> <1197470781.4744.41.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1197470781.4744.41.camel@gaivota>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 12:46:21PM -0200, Mauro Carvalho Chehab wrote:
> Em Qua, 2007-12-12 às 08:42 -0500, Michael Krufky escreveu:
> > > ERROR: "tea5761_attach" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tea5761_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tea5767_autodetection" [drivers/media/video/tuner.ko] undefined!
> > > ERROR: "tea5767_attach" [drivers/media/video/tuner.ko] undefined!
> 
> > It looks like the problem has something to do with VIDEO_TUNER=m while
> > both TUNER_TEA5761 & TUNER_TEA5767 are set to 'y'.
> > 
> > I thought that we had already seen this issue and fixed it, but I guess
> > not :-/
> > 
> > One would think that this could be fixed by making TUNER_TEA5761 &
> > TUNER_TEA5767 both depend on VIDEO_TUNER , but that would be wrong,
> > since each of those modules can be attached directly to a bridge driver
> > without tuner.ko being present at all (although this is not done in
> > practice right now, but it *is* the case with some other tuner drivers)
> 
> I don't see any issue on making both dependent on VIDEO_TUNER for
> 2.6.24, since they are currently used only by tuner core module
> (tuner.ko).
>...

If "selected code isn't included" also counts as a bug at least dabusb 
is also affected by the same bug.

What about the patch below instead that fixes the actual bug instead of 
working around it?

> Cheers,
> Mauro

cu
Adrian


<--  snip  -->


Since not all code under drivers/media/video/ depends on 
CONFIG_VIDEO_DEV we cannot only enter it depending
on CONFIG_VIDEO_DEV.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
9c315b376729908cbdde8adaea0d7bc0a47a2c36 
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 8fa1993..8cf9135 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -3,6 +3,6 @@
 #
 
 obj-y := common/
-obj-$(CONFIG_VIDEO_DEV) += video/
+obj-y += video/
 obj-$(CONFIG_VIDEO_DEV) += radio/
 obj-$(CONFIG_DVB_CORE)  += dvb/

