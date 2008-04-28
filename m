Return-Path: <linux-kernel-owner+w=401wt.eu-S934962AbYD1SFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934962AbYD1SFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933086AbYD1SFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:05:19 -0400
Received: from gw.goop.org ([64.81.55.164]:37446 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933473AbYD1SFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:05:17 -0400
Message-ID: <481611D3.9020302@goop.org>
Date: Mon, 28 Apr 2008 11:05:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080418)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Gerhard Mack <gmack@innerfire.net>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: don't bother printing compat vdso address
References: <alpine.DEB.1.10.0804241244360.28216@mtl.rackplans.net> <Pine.LNX.4.64.0804251632490.19002@twin.jikos.cz> <alpine.DEB.1.10.0804261213200.28624@mtl.rackplans.net> <48140ACF.4000500@goop.org> <alpine.DEB.1.10.0804281145090.17060@mtl.rackplans.net> <4816029D.3030508@goop.org> <alpine.DEB.1.10.0804281322200.17060@mtl.rackplans.net>
In-Reply-To: <alpine.DEB.1.10.0804281322200.17060@mtl.rackplans.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel prints the compat vdso address regardless of whether compat
vdso mode is enabled or not, which is confusing.  Given that this
isn't very interesting information anyway, just remove the printk.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Gerhard Mack <gmack@innerfire.net>
---
 arch/x86/vdso/vdso32-setup.c |    2 --
 1 file changed, 2 deletions(-)

===================================================================
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -303,8 +303,6 @@
 
 #ifdef CONFIG_X86_32
 	gate_vma_init();
-
-	printk("Compat vDSO mapped to %08lx.\n", __fix_to_virt(FIX_VDSO));
 #endif
 
 	if (!vdso32_sysenter()) {



