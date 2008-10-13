Return-Path: <linux-kernel-owner+w=401wt.eu-S1765323AbYJMKAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765323AbYJMKAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761639AbYJMJnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:43:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51019 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762693AbYJMJnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:43:51 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 67/80] pty: Fix allocation failure double free
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:43:48 +0100
Message-ID: <20081013094343.21645.61950.stgit@localhost.localdomain>
In-Reply-To: <20081013092758.21645.2359.stgit@localhost.localdomain>
References: <20081013092758.21645.2359.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

The updating and moving around of the pty code added a bug where both the
helper and caller free the main tty struct (the pty driver must free the
o_tty pair itself however).

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/pty.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)


diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index c3ab8c3..3c6b791 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -544,8 +544,6 @@ free_mem_out:
 	module_put(o_tty->driver->owner);
 	free_tty_struct(o_tty);
 	pty_unix98_shutdown(tty);
-	free_tty_struct(tty);
-	module_put(driver->owner);
 	return -ENOMEM;
 }
 

