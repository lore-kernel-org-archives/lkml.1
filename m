Return-Path: <linux-kernel-owner+w=401wt.eu-S966139AbXDCBYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966139AbXDCBYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 21:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966140AbXDCBYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 21:24:54 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:7993 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966139AbXDCBYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 21:24:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=P7I/Fj0M0ezBtmVLPUk/kKF7k1WD4yRHuMTuRyE6x90gyyzZlZHjE/GFhdG1r0uYmEeIkjqTS6XEm9SFC/ZUFvTQKtbqRvL/k0GMqn9dZq30i8q1/FmLY2Pi7eaeynhGkhK3QpOrMwUCixo1rw73l4ZL+lpc0uoDzDXnnRhyg/Q=
Message-ID: <4611ACCD.5000305@gmail.com>
Date: Tue, 03 Apr 2007 09:24:29 +0800
From: "Antonino A. Daplas" <adaplas@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] vt: Expose system-wide UTF-8 default setting via sysfs
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create a variable, default_utf8, that defines the system-wide default UTF-8
setting.  This variable can be altered via sysfs. If the variable is properly
set, this should mimimize breakage of UTF-8 encoded consoles when doing a
reset or echo -e '\033c' and of newly opened/allocated consoles.

This is based from patches by Jan Engelhardt and Paul LeoNerd Evans.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
---
> I think you're missing the whole point of console reset.  Its purpose is 
> to force the console into a known-good state.  The fewer pieces of state 
> it leaves unset, the better.  To some degree it's less important what 
> that state actually is.

Okay, you convinced me. Hopefully this is acceptable to all parties.

Andrew,

If everybody agrees, can you drop the previous patch I sent to you, and use
this instead?

Tony

 drivers/char/vt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 1bbb45b..8aca96f 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -157,6 +157,8 @@ static void blank_screen_t(unsigned long
 static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
+static int default_utf8;
+module_param(default_utf8, int, S_IRUGO | S_IWUSR);
 
 /*
  * ignore_poke: don't unblank the screen when things are typed.  This is
@@ -1497,7 +1499,7 @@ static void reset_terminal(struct vc_dat
 	vc->vc_charset		= 0;
 	vc->vc_need_wrap	= 0;
 	vc->vc_report_mouse	= 0;
-	vc->vc_utf		= 0;
+	vc->vc_utf              = default_utf8;
 	vc->vc_utf_count	= 0;
 
 	vc->vc_disp_ctrl	= 0;
