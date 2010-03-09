Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab0CIKyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:54:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42493 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab0CIKyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:54:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding:organization;
        b=hRl4Ef6HRXMB1mtaZZZ8IYJjygmzI4nvxfKuGVFGjctnVMOgQLKO5xDsGLa61SCsBJ
         Nv1PEG34bLgLkpz32YRM+8EZ1mW1vODHUDUzvA6mhjXAxCvUyhPKDSoLzGqRgljN/enI
         WwKFRJyhdWj4b3LLG+brb8JxpsA/Aslfc8GQQ=
From: Fang Wenqi <anton.fang@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: anton.fang@gmail.com, antonf@turbolinux.com.cn
Subject: [PATCH] tty_buffer: Fix distinct type warning
Date: Tue,  9 Mar 2010 18:54:28 +0800
Message-Id: <1268132068-5459-1-git-send-email-antonf@turbolinux.com.cn>
X-Mailer: git-send-email 1.6.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Organization: Turbolinux China, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC      drivers/char/tty_buffer.o
drivers/char/tty_buffer.c: In function ‘tty_insert_flip_string_fixed_flag’:
drivers/char/tty_buffer.c:251: warning: comparison of distinct pointer types lacks a cast
drivers/char/tty_buffer.c: In function ‘tty_insert_flip_string_flags’:
drivers/char/tty_buffer.c:288: warning: comparison of distinct pointer types lacks a cast

Fix it by replacing min() with min_t() in tty_insert_flip_string_flags and
					  tty_insert_flip_string_fixed_flag().

Signed-off-by: Fang Wenqi <antonf@turbolinux.com.cn>
---
 drivers/char/tty_buffer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index af8d977..7ee5216 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -248,7 +248,7 @@ int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
 {
 	int copied = 0;
 	do {
-		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
@@ -285,7 +285,7 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
 {
 	int copied = 0;
 	do {
-		int goal = min(size - copied, TTY_BUFFER_PAGE);
+		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
 		int space = tty_buffer_request_room(tty, goal);
 		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
-- 
1.6.6.1

