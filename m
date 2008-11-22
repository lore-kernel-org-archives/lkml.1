Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbYKVRiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbYKVRiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759429AbYKVRfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:35:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58461 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759424AbYKVRfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:35:45 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 15/32] section misannotation in ibmtr_cs
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1L3wOW-0006UX-K3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:35:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ibmtr_resume() is calling ibmtr_probe(), which is devinit.  Whether
that's the right thing to do there is a separate question, but
since it's PCMCIA and thus will never compile without HOTPLUG...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/pcmcia/ibmtr_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/pcmcia/ibmtr_cs.c b/drivers/net/pcmcia/ibmtr_cs.c
--- a/drivers/net/pcmcia/ibmtr_cs.c
+++ b/drivers/net/pcmcia/ibmtr_cs.c
@@ -349,7 +349,7 @@ static int ibmtr_suspend(struct pcmcia_device *link)
 	return 0;
 }
 
-static int ibmtr_resume(struct pcmcia_device *link)
+static int __devinit ibmtr_resume(struct pcmcia_device *link)
 {
 	ibmtr_dev_t *info = link->priv;
 	struct net_device *dev = info->dev;
