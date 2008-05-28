Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbYE1RNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbYE1RNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYE1RMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:12:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbYE1RMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:12:54 -0400
Date: Wed, 28 May 2008 12:57:13 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [X86] Fix up silly i1586 boot message.
Message-ID: <20080528165713.GA412@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to boot a 64-bit kernel on a 32bit Pentium 4 gets
you an amusing message along the lines of.
"you need an x86-64, but you only have an i1586"
due to the P4 being family F.  Munge it to be 686.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/boot/cpu.c b/arch/x86/boot/cpu.c
index 00e19ed..882c839 100644
--- a/arch/x86/boot/cpu.c
+++ b/arch/x86/boot/cpu.c
@@ -28,6 +28,8 @@ static char *cpu_name(int level)
 	if (level == 64) {
 		return "x86-64";
 	} else {
+		if (level == 15)
+			level = 6;
 		sprintf(buf, "i%d86", level);
 		return buf;
 	}

-- 
http://www.codemonkey.org.uk
