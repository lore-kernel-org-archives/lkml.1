Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbZJUVHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbZJUVHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZJUVHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:07:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbZJUVHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:07:43 -0400
Date: Wed, 21 Oct 2009 23:07:18 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>
Subject: [PATCH] macintosh: Explicitly set llseek to no_llseek in ans-lcd
In-Reply-To: <20091010153349.966159859@linutronix.de>
Message-ID: <alpine.LFD.2.00.0910212305090.3526@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153349.966159859@linutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0c2b412cdccf73bdeb19bb866bfe556942eaeca2 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 21 Oct 2009 23:01:12 +0200
Subject: [PATCH] macintosh: Explicitly set llseek to no_llseek in ans-lcd

Now that we've removed the BKL here, let's explicitly set lleek to no_llseek

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/macintosh/ans-lcd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/macintosh/ans-lcd.c b/drivers/macintosh/ans-lcd.c
index 4ae8ec9..a1a1bde 100644
--- a/drivers/macintosh/ans-lcd.c
+++ b/drivers/macintosh/ans-lcd.c
@@ -137,6 +137,7 @@ const struct file_operations anslcd_fops = {
 	.write		= anslcd_write,
 	.unlocked_ioctl	= anslcd_ioctl,
 	.open		= anslcd_open,
+	.llseedk	= no_llseek,
 };
 
 static struct miscdevice anslcd_dev = {
-- 
1.6.0.6


