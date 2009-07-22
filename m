Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZGVKPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZGVKPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZGVKO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:14:59 -0400
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:40236 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbZGVKKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:10:47 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Oren Laadan <orenl@librato.com>,
       Oren Laadan <orenl@cs.columbia.edu>
Subject: [RFC v17][PATCH 36/60] c/r: add generic '->checkpoint()' f_op to simple devices
Date: Wed, 22 Jul 2009 05:59:58 -0400
Message-Id: <1248256822-23416-37-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248256822-23416-1-git-send-email-orenl@librato.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* /dev/null
* /dev/zero
* /dev/random
* /dev/urandom

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
---
 drivers/char/mem.c    |    2 ++
 drivers/char/random.c |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index afa8813..828ba7f 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -799,6 +799,7 @@ static const struct file_operations null_fops = {
 	.read		= read_null,
 	.write		= write_null,
 	.splice_write	= splice_write_null,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 #ifdef CONFIG_DEVPORT
@@ -815,6 +816,7 @@ static const struct file_operations zero_fops = {
 	.read		= read_zero,
 	.write		= write_zero,
 	.mmap		= mmap_zero,
+	.checkpoint	= generic_file_checkpoint,
 };
 
 /*
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8c74448..211ca70 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1164,6 +1164,7 @@ const struct file_operations random_fops = {
 	.poll  = random_poll,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
+	.checkpoint = generic_file_checkpoint,
 };
 
 const struct file_operations urandom_fops = {
@@ -1171,6 +1172,7 @@ const struct file_operations urandom_fops = {
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
+	.checkpoint = generic_file_checkpoint,
 };
 
 /***************************************************************
-- 
1.6.0.4

