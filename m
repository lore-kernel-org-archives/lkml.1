Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZJUUoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZJUUoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZJUUoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:44:24 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39437 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbZJUUoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=KjBEYMgrl5uZOFP7jJyI/wasNPkIwyEiqGZsB86XYLB9jpOoQsEnL2pzf+nzKe5beF
         8kwDOhMaIrHkOlZO8lKoo6DhkaUwRgTDoPcSRrxBT7vfUgi1KD2uAVmbHUUZdyBk+kBX
         xEOOJjHtbDKCf7UCXrhs0vk69+lOQ3QSEqn58=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:44:05 +0200
Message-Id: <20091021204405.4593.85470.sendpatchset@localhost.localdomain>
In-Reply-To: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
References: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/12] Staging: rt28x0: remove private RTPRIV_IOCTL_SET ioctl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: remove private RTPRIV_IOCTL_SET ioctl

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/sta_ioctl.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

Index: b/drivers/staging/rt2860/sta_ioctl.c
===================================================================
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -2978,6 +2978,7 @@ INT rt28xx_sta_ioctl(
 		case SIOCSIWRETRY:	//set retry limits and lifetime
 		case RT_PRIV_IOCTL:
 		case RT_PRIV_IOCTL_EXT:
+		case RTPRIV_IOCTL_SET:
 			Status = -EOPNOTSUPP;
 			break;
 		case SIOCGIWPRIV:
@@ -2990,11 +2991,6 @@ INT rt28xx_sta_ioctl(
 					Status = -EFAULT;
 			}
 			break;
-		case RTPRIV_IOCTL_SET:
-			if(access_ok(VERIFY_READ, wrq->u.data.pointer, wrq->u.data.length) != TRUE)
-				break;
-			rt_ioctl_setparam(net_dev, NULL, NULL, wrq->u.data.pointer);
-			break;
 		case RTPRIV_IOCTL_GSITESURVEY:
 			RTMPIoctlGetSiteSurvey(pAd, wrq);
 		    break;
