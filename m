Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbYEHCDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbYEHCDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 22:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbYEHCDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 22:03:24 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:39738 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbYEHCDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 22:03:22 -0400
Message-ID: <48225F95.3020205@keyaccess.nl>
Date: Thu, 08 May 2008 04:04:05 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: [PATCH] x86: enable PAT support on AMD Duron model 7
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl> <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl>
In-Reply-To: <48225DEC.2030502@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08-05-08 03:57, Rene Herman wrote:

> Okay, so how's this? Seem to work well for me and makes me happy. Only
> tested on UP.

With this on top, I'm ecstatic:

  x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106


x86: enable PAT support on AMD Duron model 7

PAT support seems to work well on AMD Duron model 7. Enable it.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7bec5e0..39b308b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -312,6 +312,8 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
 	case X86_VENDOR_AMD:
 		if (c->x86 >= 0xf && c->x86 <= 0x11)
 			set_cpu_cap(c, X86_FEATURE_PAT_GOOD);
+		if (c->x86 == 6 && c->x86_model == 7)
+			set_cpu_cap(c, X86_FEATURE_PAT_GOOD);
 		break;
 	case X86_VENDOR_INTEL:
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
@@ -411,6 +413,8 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 	case X86_VENDOR_AMD:
 		if (c->x86 >= 0xf && c->x86 <= 0x11)
 			set_cpu_cap(c, X86_FEATURE_PAT_GOOD);
+		if (c->x86 == 6 && c->x86_model == 7)
+			set_cpu_cap(c, X86_FEATURE_PAT_GOOD);
 		break;
 	case X86_VENDOR_INTEL:
 		if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
