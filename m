Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYHJWNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYHJWNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 18:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbYHJWNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 18:13:14 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:41942 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbYHJWNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 18:13:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CLbqOOpI6CP0gXUw5uJJBDtxkve/MidvGvl7Y4dNt79Vj0EO3/500awmSs9ClQAbiD
         jxUwvUhesiF8plmF/yYNevG5ZkBhTI7P5YoRNssQFI0ZEwEfY/IWWIvrQJ1eAciFzJ9V
         c6/2MIMl3SOcH6f/WiFYYvlNeBCIXsj94xNlo=
Date: Mon, 11 Aug 2008 00:12:37 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH] x86: fix MP_processor_info section mismatch warning
Message-ID: <20080810221233.GD27349@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x1fe7): Section mismatch in reference from the function MP_processor_info() to the variable .init.data:x86_quirks
The function __cpuinit MP_processor_info() references
a variable __initdata x86_quirks.
If x86_quirks is only used by MP_processor_info then
annotate x86_quirks with a matching annotation.

MP_processor_info uses x86_quirks which is __init and is used only from
smp_read_mpc and construct_default_ISA_mptable which are __init

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/mpparse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a7189f4..2c1963b 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -49,7 +49,7 @@ static int __init mpf_checksum(unsigned char *mp, int len)
 	return sum & 0xFF;
 }
 
-static void __cpuinit MP_processor_info(struct mpc_config_processor *m)
+static void __init MP_processor_info(struct mpc_config_processor *m)
 {
 	int apicid;
 	char *bootup_cpu = "";
-- 
1.5.4.5

