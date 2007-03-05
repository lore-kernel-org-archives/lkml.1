Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXCEU6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXCEU6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933200AbXCEU6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:09 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46851 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409AbXCEU6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:08 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 10/11] uml - activate_fd: return ENOMEM only when appropriate
Date: Mon, 05 Mar 2007 21:49:09 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204909.9072.33957.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25KwZZJ008274

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Avoid returning ENOMEM in case of a duplicate IRQ - ENOMEM was saved into err
earlier.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/um/kernel/irq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 50a288b..dbf2f5b 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -142,6 +142,7 @@ int activate_fd(int irq, int fd, int type, void *dev_id)
 				     .events 		= events,
 				     .current_events 	= 0 } );
 
+	err = -EBUSY;
 	spin_lock_irqsave(&irq_lock, flags);
 	for (irq_fd = active_fds; irq_fd != NULL; irq_fd = irq_fd->next) {
 		if ((irq_fd->fd == fd) && (irq_fd->type == type)) {


