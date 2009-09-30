Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZI3KCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZI3KCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 06:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbZI3KCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 06:02:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZI3KB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 06:01:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Make pty_driver and pty_slave_driver local vars in legacy BSD
	pty code
To: torvalds@osdl.org, akpm@linux-foundation.org, gregkh@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Wed, 30 Sep 2009 11:01:47 +0100
Message-ID: <20090930100147.28440.87231.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the pty_driver and pty_slave_driver global variables into local vars of
legacy_pty_init() as that's the only thing that ever accesses the values.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/pty.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 53761ce..6fe1f07 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -326,8 +326,6 @@ static const struct tty_operations pty_ops = {
 
 /* Traditional BSD devices */
 #ifdef CONFIG_LEGACY_PTYS
-static struct tty_driver *pty_driver, *pty_slave_driver;
-
 static int pty_bsd_ioctl(struct tty_struct *tty, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
@@ -356,6 +354,8 @@ static const struct tty_operations pty_ops_bsd = {
 
 static void __init legacy_pty_init(void)
 {
+	struct tty_driver *pty_driver, *pty_slave_driver;
+
 	if (legacy_count <= 0)
 		return;
 

