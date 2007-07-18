Return-Path: <linux-kernel-owner+w=401wt.eu-S937525AbXGRXkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937525AbXGRXkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761796AbXGRXbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:31:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49823 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936868AbXGRXbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RDSpLb/C0+pw5SBhXOyEuSG7+EltSzs+0ddhKrNvOGMrjR4sD2gy+s0QNaKbaKsZiVj/zddzhLCmN2LiXzvWNHW/5vR2u2PYXwrED5lzk7p3T2LCVX0QwpoFcacwzJeongnPKmjCYN2iRlpJdF1i/LuNtp0vWvAUW4mj3jfU3qw=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH]  cr_backlight_probe allocates too little storage for struct cr_panel
Date: Thu, 19 Jul 2007 01:30:38 +0200
User-Agent: KMail/1.9.7
Cc: Thomas Hellstrom <thomas@tungstengraphics.com>,
       Alan Hourihane <alanh@tungstengraphics.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707190130.39067.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Coverity checker noticed that we allocate too little storage 
for "struct cr_panel *crp" in cr_backlight_probe().
We allocate sizeof(crp) where we should really be 
allocating sizeof(*crp) - or sizeof(struct cr_panel) - I 
chose the first notation.
This patch should fix the problem.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/video/backlight/cr_bllcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
index e9bbc34..1b3f658 100644
--- a/drivers/video/backlight/cr_bllcd.c
+++ b/drivers/video/backlight/cr_bllcd.c
@@ -174,7 +174,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
 	struct cr_panel *crp;
 	u8 dev_en;
 
-	crp = kzalloc(sizeof(crp), GFP_KERNEL);
+	crp = kzalloc(sizeof(*crp), GFP_KERNEL);
 	if (crp == NULL)
 		return -ENOMEM;
 


