Return-Path: <linux-kernel-owner+w=401wt.eu-S1761075AbYJMJlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075AbYJMJlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 05:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbYJMJfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 05:35:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56166 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759095AbYJMJfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 05:35:37 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 23/80] nozomi: Fix close on error
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2008 10:35:33 +0100
Message-ID: <20081013093529.21645.85336.stgit@localhost.localdomain>
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

Nozomi assumes the close method isn't called if open errors. The tty layer
is different to other drives in this respect however. Pointed out by Denis J
Barrow.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/nozomi.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 66a0f93..9a34a19 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1599,7 +1599,10 @@ static int ntty_open(struct tty_struct *tty, struct file *file)
 	return 0;
 }
 
-/* Called when the userspace process close the tty, /dev/noz*. */
+/* Called when the userspace process close the tty, /dev/noz*. Also
+   called immediately if ntty_open fails in which case tty->driver_data
+   will be NULL an we exit by the first return */
+
 static void ntty_close(struct tty_struct *tty, struct file *file)
 {
 	struct nozomi *dc = get_dc_by_tty(tty);

