Return-Path: <linux-kernel-owner+w=401wt.eu-S1757167AbYJEQ06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbYJEQ06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbYJEQWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:22:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57967 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758170AbYJEQWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:10 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 61/76] pty: Fix allocation failure double free
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:22:10 +0100
Message-ID: <20081005162206.1997.63147.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 

