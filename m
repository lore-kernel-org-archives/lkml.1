Return-Path: <linux-kernel-owner+w=401wt.eu-S1758860AbXHWD0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbXHWD0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 23:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbXHWD0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 23:26:46 -0400
Received: from n8a.bullet.mail.re3.yahoo.com ([68.142.236.46]:27101 "HELO
	n8a.bullet.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752168AbXHWD0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 23:26:45 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 233368.35331.bm@rrr2.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Nlrsvyf7h5KPqHpduN+GY8y+RmRFkKj5hCGzLQVvHsvbyEzirOpLk29wykjmczjXo2vy/icWZMBt9E1OiRwyFwfGVky5ZVMjaDAZ8AYlvnhRjF+kW9/70lVDP5Za6J1p8GZDA4Yqu9StV/USYyPrRVVxXoSMga2Ge+3xGALQBR8=;
Date: Wed, 22 Aug 2007 20:26:01 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH 3 of 5 resend ] /drivers/char/drm ioremap balancing/ returncode check
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <525882.95198.qm@web44909.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc3.  
corrects missing ioremap return checks and balancing on iounmap calls, integrated changes per list
recommendations on the original set of patches..

Warning -- cleanup handler here may miss additional required cleanup as has occurred on other
portions of ioremap audit.

This patch had been submitted previously but hushmail client caused wordwrap issues, resending
with different mail client.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/char/drm/drm_bufs.c b/drivers/char/drm/drm_bufs.c
index 923174c..448488b 100644
--- a/drivers/char/drm/drm_bufs.c
+++ b/drivers/char/drm/drm_bufs.c
@@ -177,8 +177,13 @@ static int drm_addmap_core(struct drm_device * dev, unsigned
 						     MTRR_TYPE_WRCOMB, 1);
 			}
 		}
-		if (map->type == _DRM_REGISTERS)
+		if (map->type == _DRM_REGISTERS){
 			map->handle = ioremap(map->offset, map->size);
+			if (!map->handle) {
+				drm_free(map, sizeof(*map), DRM_MEM_MAPS);
+				return -ENOMEM;
+			}
+		}
 		break;
 	case _DRM_SHM:
 		list = drm_find_matching_map(dev, map);


       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers -
Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433


       
____________________________________________________________________________________
Take the Internet to Go: Yahoo!Go puts the Internet in your pocket: mail, news, photos & more. 
http://mobile.yahoo.com/go?refer=1GNXIC

