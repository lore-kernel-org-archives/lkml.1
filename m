Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYJOOKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYJOOKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYJOOGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:06:10 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:32960 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbYJOOGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:06:08 -0400
Subject: [PATCH 05/21] fat: use generic_file_llseek() for directory
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:57:57 +0900
Message-ID: <3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
In-Reply-To: <2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since fat_dir_ioctl() was already fixed (i.e. called under ->i_mutex),
and __fat_readdir() doesn't take BKL anymore. So, BKL for ->llseek()
is pointless, and we have to use generic_file_llseek().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/fat/dir.c~fat_use-generic_file_llseek fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat_use-generic_file_llseek	2008-08-29 11:59:44.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2008-09-01 20:07:19.000000000 +0900
@@ -832,6 +832,7 @@ static long fat_compat_dir_ioctl(struct 
 #endif /* CONFIG_COMPAT */
 
 const struct file_operations fat_dir_operations = {
+	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.readdir	= fat_readdir,
 	.ioctl		= fat_dir_ioctl,
_
