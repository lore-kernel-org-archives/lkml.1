Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZKJLIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZKJLIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZKJLIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:08:23 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:51887 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZKJLIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dkzma8MLPpVooU9ymkR3eM/DGy6MET4mLIaaD8TysNm+j3Z8V3X/lPMnCw3LQ7IhMl
         UTgEKs737NI2ByWKLqMss8dY8r9CGqI6rkbeyAlRbLBjL41amNSeNPOzGUHW+ZXslws/
         nyRfsGDabw068u/bzIWStp51S7Y7Oz+RVnpAw=
Date: Tue, 10 Nov 2009 12:08:25 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, dimm <dmitry.adamushko@gmail.com>
Subject: [PATCH 2/3] x86, ucode-amd: Don't warn when no ucode is available
 for a CPU revision
Message-ID: <20091110110825.GI30802@alberich.amd.com>
References: <20091110110601.GG30802@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110110601.GG30802@alberich.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in warning when there is no ucode available for a
specific CPU revision. Currently the container-file, which provides the
AMD ucode patches for OS load, contains only a few ucode patches.

It's already clearly indicated by the printed patch_level whenever new
ucode was available and an update happened. So the warning message is
of no help but rather annoying on systems with many CPUs.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 75538f6..9f13324 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -105,11 +105,8 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
 		i++;
 	}
 
-	if (!equiv_cpu_id) {
-		printk(KERN_WARNING "microcode: CPU%d: cpu revision "
-		       "not listed in equivalent cpu table\n", cpu);
+	if (!equiv_cpu_id)
 		return 0;
-	}
 
 	if (mc_header->processor_rev_id != equiv_cpu_id)
 		return 0;
-- 
1.6.5.2

