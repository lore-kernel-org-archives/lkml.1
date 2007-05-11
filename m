Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbXEKLOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbXEKLOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 07:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757135AbXEKLOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 07:14:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738AbXEKLOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 07:14:36 -0400
Message-ID: <46444F3F.6010308@redhat.com>
Date: Fri, 11 May 2007 13:10:55 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch] Refine SCREEN_INFO sanity check for vgacon initialization.
Content-Type: multipart/mixed;
 boundary="------------040003000702090201060107"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040003000702090201060107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

   Hi,

Checking video mode field only to see whenever SCREEN_INFO is
initialized is not enougth, in some cases it is zero although
a vga card is present.  Lets additionally check cols and lines.

Updates f82af20e1a028e16b9bb11da081fa1148d40fa6a, should go
into 2.6.22.

please apply,
   Gerd


--------------040003000702090201060107
Content-Type: text/plain;
 name="vgacon-fixup-check"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vgacon-fixup-check"

Refine SCREEN_INFO sanity check for vgacon initialization.

Checking video mode field only to see whenever SCREEN_INFO is
initialized is not enougth, in some cases it is zero although
a vga card is present.  Lets additionally check cols and lines.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Cc: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/video/console/vgacon.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: vanilla-2.6.21-git11/drivers/video/console/vgacon.c
===================================================================
--- vanilla-2.6.21-git11.orig/drivers/video/console/vgacon.c
+++ vanilla-2.6.21-git11/drivers/video/console/vgacon.c
@@ -368,9 +368,14 @@ static const char *vgacon_startup(void)
 #endif
 	}
 
+	/* SCREEN_INFO initialized? */
+	if ((ORIG_VIDEO_MODE  == 0) &&
+	    (ORIG_VIDEO_LINES == 0) &&
+	    (ORIG_VIDEO_COLS  == 0))
+		goto no_vga;
+
 	/* VGA16 modes are not handled by VGACON */
-	if ((ORIG_VIDEO_MODE == 0x00) ||	/* SCREEN_INFO not initialized */
-	    (ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
+	if ((ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
 	    (ORIG_VIDEO_MODE == 0x0E) ||	/* 640x200/4 */
 	    (ORIG_VIDEO_MODE == 0x10) ||	/* 640x350/4 */
 	    (ORIG_VIDEO_MODE == 0x12) ||	/* 640x480/4 */

--------------040003000702090201060107--
