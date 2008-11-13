Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYKMBym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYKMBym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 20:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYKMByS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 20:54:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:37124 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYKMByR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 20:54:17 -0500
From: Kevin Hao <kexin.hao@windriver.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, Alan Cox <alan@redhat.com>, linux-usb@vger.kernel.org
Subject: [PATCH 1/2] init tty kref in usb serial console setup
Date: Thu, 13 Nov 2008 09:53:36 +0800
Message-Id: <23d0e3c26b7580b20c76900e16a53e42950ffaab.1226366228.git.kexin.hao@windriver.com>
X-Mailer: git-send-email 1.6.0.3.640.g6331a
In-Reply-To: <1226541217-32673-1-git-send-email-kexin.hao@windriver.com>
References: <1226541217-32673-1-git-send-email-kexin.hao@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We alloc a fake tty in usb serial console setup function. we should
init the tty's kref otherwise we will face WARN_ON after following
invoke of tty_port_tty_set --> tty_kref_get.

Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
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
-- 
1.6.0.3.640.g6331a

