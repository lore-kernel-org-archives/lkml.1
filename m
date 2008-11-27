Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYK0UMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYK0UMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 15:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYK0UMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 15:12:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:20400 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbYK0UMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 15:12:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=RJbo9icB27e94KKgPgXR1MygL2k5UHBYrDCIYRtqpSPTZdJKaKDPEIlTTrMVQctZVU
         ueCuwGF083k/cDyRBnaXjv/CCTj8vDeEO+HtFSCHeCoVVs9o884sO8hiyIt1OTUvraV2
         6uqAdiIslztamnxkDEguZjIpdAgZlDF7Ez73w=
Date: Thu, 27 Nov 2008 23:12:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: paulus@samba.org
Cc: linux-ppp@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: ppp_asynctty_ioctl - remove dead code
Message-ID: <20081127201237.GB18691@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ap already checked to be not null. remove useless checks.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Please review

diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
index 451bdb5..6567fab 100644
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -293,9 +293,6 @@ ppp_asynctty_ioctl(struct tty_struct *tty, struct file *file,
 	err = -EFAULT;
 	switch (cmd) {
 	case PPPIOCGCHAN:
-		err = -ENXIO;
-		if (!ap)
-			break;
 		err = -EFAULT;
 		if (put_user(ppp_channel_index(&ap->chan), p))
 			break;
@@ -303,9 +300,6 @@ ppp_asynctty_ioctl(struct tty_struct *tty, struct file *file,
 		break;
 
 	case PPPIOCGUNIT:
-		err = -ENXIO;
-		if (!ap)
-			break;
 		err = -EFAULT;
 		if (put_user(ppp_unit_number(&ap->chan), p))
 			break;
