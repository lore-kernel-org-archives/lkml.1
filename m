Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0BSGWB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:22:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:51604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab0BSGV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:21:59 -0500
Date: Fri, 19 Feb 2010 06:21:37 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
In-Reply-To: <tip-*@git.kernel.org>
References: <tip-*@git.kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86-64, setup: Inhibit decompressor output if video info is invalid
Message-ID: <tip-eb572a5c7951288e265b3e8f9a5d37b6abb2e996@git.kernel.org>
Git-Commit-ID: eb572a5c7951288e265b3e8f9a5d37b6abb2e996
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Feb 2010 06:21:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb572a5c7951288e265b3e8f9a5d37b6abb2e996
Gitweb:     http://git.kernel.org/tip/eb572a5c7951288e265b3e8f9a5d37b6abb2e996
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Thu, 18 Feb 2010 22:15:04 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Feb 2010 22:15:04 -0800

x86-64, setup: Inhibit decompressor output if video info is invalid

Inhibit output from the kernel decompressor if the video information
is invalid.  This was already the case for 32 bits, make 64 bits
match.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <tip-*@git.kernel.org>
---
 arch/x86/boot/compressed/misc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 3b22fe8..3487e86 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -185,11 +185,9 @@ static void __putstr(int error, const char *s)
 		return;
 #endif
 
-#ifdef CONFIG_X86_32
 	if (real_mode->screen_info.orig_video_mode == 0 &&
 	    lines == 0 && cols == 0)
 		return;
-#endif
 
 	x = real_mode->screen_info.orig_x;
 	y = real_mode->screen_info.orig_y;
