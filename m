Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYKWSh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYKWSh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYKWShM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:37:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:23258 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYKWShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:37:11 -0500
Message-ID: <154e089b0811231037l18d4d8erce62eb4e77e28b10@mail.gmail.com>
Date: Sun, 23 Nov 2008 19:37:09 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] x86: boot - fix sparse warnings
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

arch/x86/boot/video.c:233:3: warning: symbol 'saved' was not declared.
Should it be static?
arch/x86/boot/video-vga.c:37:13: warning: symbol 'video_vga' was not
declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 arch/x86/boot/video-vga.c |    4 ++--
 arch/x86/boot/video.c     |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/video-vga.c b/arch/x86/boot/video-vga.c
index b939cb4..5d4742e 100644
--- a/arch/x86/boot/video-vga.c
+++ b/arch/x86/boot/video-vga.c
@@ -34,7 +34,7 @@ static struct mode_info cga_modes[] = {
 	{ VIDEO_80x25,  80, 25, 0 },
 };

-__videocard video_vga;
+static __videocard video_vga;

 /* Set basic 80x25 mode */
 static u8 vga_set_basic_mode(void)
@@ -259,7 +259,7 @@ static int vga_probe(void)
 	return mode_count[adapter];
 }

-__videocard video_vga = {
+static __videocard video_vga = {
 	.card_name	= "VGA",
 	.probe		= vga_probe,
 	.set_mode	= vga_set_mode,
diff --git a/arch/x86/boot/video.c b/arch/x86/boot/video.c
index 83598b2..3bef2c1 100644
--- a/arch/x86/boot/video.c
+++ b/arch/x86/boot/video.c
@@ -226,7 +226,7 @@ static unsigned int mode_menu(void)

 #ifdef CONFIG_VIDEO_RETAIN
 /* Save screen content to the heap */
-struct saved_screen {
+static struct saved_screen {
 	int x, y;
 	int curx, cury;
 	u16 *data;
