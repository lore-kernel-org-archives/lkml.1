Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZJUVOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZJUVOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZJUVOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:14:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970AbZJUVOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:14:43 -0400
Date: Wed, 21 Oct 2009 23:13:26 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, Jonathan Corbet <corbet@lwn.net>,
       Christoph Hellwig <hch@infradead.org>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Subject: [PATCH] rtc: Explicitly set llseek to no_llseek
In-Reply-To: <20091010153350.046644063@linutronix.de>
Message-ID: <alpine.LFD.2.00.0910212312270.3526@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de> <20091010153350.046644063@linutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e1b7175258b33da3b0564ef04a0b1956f04f0cc7 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Wed, 21 Oct 2009 23:10:30 +0200
Subject: [PATCH] rtc: Explicitly set llseek to no_llseek

Now that we've removed the BKL here, lets explicitly set llseek to no_llseek
since the default llseek is not used here.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/char/efirtc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index 26a47dc..53c524e 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -285,6 +285,7 @@ static const struct file_operations efi_rtc_fops = {
 	.unlocked_ioctl	= efi_rtc_ioctl,
 	.open		= efi_rtc_open,
 	.release	= efi_rtc_close,
+	.llseek		= no_llseek,
 };
 
 static struct miscdevice efi_rtc_dev= {
-- 
1.6.0.6


