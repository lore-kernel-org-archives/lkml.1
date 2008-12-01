Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYLALge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYLALge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 06:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYLALgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 06:36:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36950 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754583AbYLALgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 06:36:06 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] Add kref to fake tty used by USB console
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Dec 2008 11:36:16 +0000
Message-ID: <20081201113611.29458.66988.stgit@localhost.localdomain>
In-Reply-To: <20081201113445.29458.35295.stgit@localhost.localdomain>
References: <20081201113445.29458.35295.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hao <kexin.hao@windriver.com>

We alloc a fake tty in usb serial console setup function. we should
init the tty's kref otherwise we will face WARN_ON after following
invoke of tty_port_tty_set --> tty_kref_get.

Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/console.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 5b20de1..5b95009 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -135,6 +135,7 @@ static int usb_console_setup(struct console *co, char *options)
 				err("no more memory");
 				goto reset_open_count;
 			}
+			kref_init(&tty->kref);
 			termios = kzalloc(sizeof(*termios), GFP_KERNEL);
 			if (!termios) {
 				retval = -ENOMEM;

