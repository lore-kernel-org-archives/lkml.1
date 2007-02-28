Return-Path: <linux-kernel-owner+w=401wt.eu-S932563AbXB1OKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbXB1OKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:10:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932566AbXB1OKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:10:09 -0500
Received: from gate.edelkey.net ([213.138.147.140]:40098 "EHLO
	gate.edelkey.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563AbXB1OKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:10:07 -0500
Message-ID: <45E58D2D.6010308@ray.fi>
Date: Wed, 28 Feb 2007 16:09:49 +0200
From: Tommi Kyntola <tommi.kyntola@ray.fi>
Reply-To: tommi.kyntola@ray.fi
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, alsa-devel@lists.sourceforge.net
Subject: [RFC][PATCH] intel8x0: revert regression that broke sounds after
 S3 suspend
X-MIMETrack: Itemize by SMTP Server on raysrv05/RAY(Release 6.5.5 HF456|May 19, 2006) at
 28.02.2007 16:09:49,
	Serialize by Router on raysrv05/RAY(Release 6.5.5 HF456|May 19, 2006) at
 28.02.2007 16:09:51,
	Serialize complete at 28.02.2007 16:09:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The regression in 2.6.19-rc3 (namely 30b35399ceb2398d05837863476dcb12f12f3a82,
"[ALSA] Various fixes for suspend/resume of ALSA PCI drivers"),
broke HP nw8000 speaker sounds after S3 suspend (headphones still worked).
Removing this line makes the sounds work again...

Signed-off-by: Tommi Kyntola <tommi.kyntola@ray.fi>
---
This is a FYI kinda message, which Rafael Wysocki asekd me to send,
and something that is clearly not the correct way to go with this,
but I was unable to locate the actual reason for the regression
and this does fix it for me, so here it goes.

Wether other devices suffer from this or not, I don't know. I was only
able test this on an HP nw8000, which has the said intel8x0.

I'll gladly try out further patches or submit configs, or whatever
more verbose information is asked for.
         Kynde

diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index a289abf..f62a456 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2470,7 +2470,6 @@ static int intel8x0_suspend(struct pci_dev *pci, pm_message_t state)
         }
         pci_disable_device(pci);
         pci_save_state(pci);
-       pci_set_power_state(pci, pci_choose_state(pci, state));
         return 0;
  }


