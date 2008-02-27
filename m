Return-Path: <linux-kernel-owner+w=401wt.eu-S1764238AbYB0Boo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764238AbYB0Boo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 20:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbYB0Bog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 20:44:36 -0500
Received: from igraine.blacknight.ie ([81.17.252.25]:55664 "EHLO
	igraine.blacknight.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbYB0Bof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 20:44:35 -0500
Date: Wed, 27 Feb 2008 01:44:27 +0000
From: Robert Fitzsimons <robfitz@273k.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Bongani Hlope <bonganilinux@mweb.co.za>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] bttv: Re-enable radio tuner support for
	VIDIOCGFREQ/VIDIOCSFREQ ioctls.
Message-ID: <20080227014427.GB2685@localhost>
References: <200802171036.19619.bonganilinux@mweb.co.za> <20080218131125.2857f7c7@gaivota> <200802182320.40732.bonganilinux@mweb.co.za> <200802190121.36280.bonganilinux@mweb.co.za> <20080219111640.409870a9@gaivota> <20080226154102.GD30463@localhost> <20080227014238.GA2685@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227014238.GA2685@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-blacknight-igraine-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: 1JUBLF-0007IP-5z
X-blacknight-igraine-MailScanner: Found to be clean
X-blacknight-igraine-MailScanner-SpamCheck: not spam,
	SpamAssassin (not cached, score=1.608, required 7,
	autolearn=disabled, HELO_LOCALHOST 4.50, RCVD_IN_NERDS_IE -3.50,
	RCVD_IN_PBL 0.51, RDNS_NONE 0.10)
X-blacknight-igraine-MailScanner-SpamScore: s
X-MailScanner-From: robfitz@273k.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Fitzsimons <robfitz@273k.net>
---
 drivers/media/video/bt8xx/bttv-driver.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 5404fcc..817a961 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -1990,7 +1990,7 @@ static int bttv_g_frequency(struct file *file, void *priv,
 	if (0 != err)
 		return err;
 
-	f->type = V4L2_TUNER_ANALOG_TV;
+	f->type = btv->radio_user ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = btv->freq;
 
 	return 0;
@@ -2009,7 +2009,8 @@ static int bttv_s_frequency(struct file *file, void *priv,
 
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
-	if (unlikely(f->type != V4L2_TUNER_ANALOG_TV))
+	if (unlikely(f->type != (btv->radio_user
+		? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV)))
 		return -EINVAL;
 	mutex_lock(&btv->lock);
 	btv->freq = f->frequency;
-- 
1.5.4.34.g053d9

