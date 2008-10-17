Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYJQT2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYJQT2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbYJQT2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:28:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50691 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755545AbYJQT2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:28:36 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/3] epca: Add infinite break support
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 17 Oct 2008 20:28:25 +0100
Message-ID: <20081017192758.9308.94462.stgit@localhost.localdomain>
In-Reply-To: <20081017192309.9308.74370.stgit@localhost.localdomain>
References: <20081017192309.9308.74370.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

The EPCA can support indefinte break lengths and with info from digi that
can now be added

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/epca.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 4998b27..cf2461d 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -2477,7 +2477,11 @@ static int pc_send_break(struct tty_struct *tty, int msec)
 	unsigned long flags;
 
 	if (msec == -1)
-		return -EOPNOTSUPP;
+		msec = 0xFFFF;
+	else if (msec > 0xFFFE)
+		msec = 0xFFFE;
+	else if (msec < 1)
+		msec = 1;
 
 	spin_lock_irqsave(&epca_lock, flags);
 	globalwinon(ch);

