Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYJJKic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYJJKic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758810AbYJJKhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:37:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42523 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756771AbYJJKhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:37:09 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 04/27] epca: call tty_port_init
To: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Date: Fri, 10 Oct 2008 11:37:04 +0100
Message-ID: <20081010103701.31597.22747.stgit@localhost.localdomain>
In-Reply-To: <20081010103447.31597.42992.stgit@localhost.localdomain>
References: <20081010103447.31597.42992.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/epca.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 456e4ed..4998b27 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -1376,6 +1376,7 @@ static void post_fep_init(unsigned int crd)
 		unsigned long flags;
 		u16 tseg, rseg;
 
+		tty_port_init(&ch->port);
 		ch->brdchan = bc;
 		ch->mailbox = gd;
 		INIT_WORK(&ch->tqueue, do_softint);
@@ -1510,10 +1511,6 @@ static void post_fep_init(unsigned int crd)
 		ch->fepstopca = 0;
 
 		ch->close_delay = 50;
-		ch->port.count = 0;
-		ch->port.blocked_open = 0;
-		init_waitqueue_head(&ch->port.open_wait);
-		init_waitqueue_head(&ch->port.close_wait);
 
 		spin_unlock_irqrestore(&epca_lock, flags);
 	}

