Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYG3VET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYG3VET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYG3VEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:04:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:59627 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYG3VEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:04:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=G7y4aXOmC15S6Fb2kK1TQ26C6wXzmQE6DK6siToaY61Ch9+djQsl0qccFqgmKvbSAa
         /1IUOf4oXQvgk+nwxxQF10tkLkm26qNqie6NSrSFxkod9XPJwBjuxMhtAUpEIAKCfOwF
         m5Wdvk0jyN3Z4tWdmwkP1z6xOJ9zClmFzHris=
Date: Thu, 31 Jul 2008 01:03:52 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: syrjala@sci.fi, adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] atyfb_base.c: fix warning
Message-ID: <20080730210352.GA29355@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

atyfb_base.c: fix warning

drivers/video/aty/atyfb_base.c:2663: warning: 'aty_resume_chip' defined
but not used

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Antonino A. Daplas <adaplas@pol.net>
---

 drivers/video/aty/atyfb_base.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index 620ba81..9e5dfb1 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -244,7 +244,9 @@ static int atyfb_sync(struct fb_info *info);
      */
 
 static int aty_init(struct fb_info *info);
+#if defined(CONFIG_PM) && defined(CONFIG_PCI)
 static void aty_resume_chip(struct fb_info *info);
+#endif
 #ifdef CONFIG_ATARI
 static int store_video_par(char *videopar, unsigned char m64_num);
 #endif
@@ -2659,6 +2661,7 @@ aty_init_exit:
 	return ret;
 }
 
+#if defined(CONFIG_PM) && defined(CONFIG_PCI)
 static void aty_resume_chip(struct fb_info *info)
 {
 	struct atyfb_par *par = info->par;
@@ -2671,6 +2674,7 @@ static void aty_resume_chip(struct fb_info *info)
 	if (par->aux_start)
 		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
 }
+#endif /* defined(CONFIG_PM) && defined(CONFIG_PCI) */
 
 #ifdef CONFIG_ATARI
 static int __devinit store_video_par(char *video_str, unsigned char m64_num)
