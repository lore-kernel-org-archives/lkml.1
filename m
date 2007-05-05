Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXEERAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXEERAr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 13:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbXEERAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 13:00:47 -0400
Received: from m-relay.rz.uni-saarland.de ([134.96.7.3]:11824 "EHLO
	m-relay.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933604AbXEERAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 13:00:45 -0400
X-Greylist: delayed 3448 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 May 2007 13:00:43 EDT
Date: Sat, 5 May 2007 12:49:34 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Make bootsector stub 16-bit-only (x86_64)
Message-ID: <20070505104934.GA30966@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.5.1 (m-relay.rz.uni-saarland.de [134.96.7.3]); Sat, 05 May 2007 12:49:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir Milter (version: 1.1.3-1; AVE: 7.3.1.53; VDF: 6.38.1.19; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

The x86 bzImage contains a stub to inform people that it is not possible
any more to run a Linux kernel by catting it to a floppy and then
booting from it. This was meant to be all 16-bit code. The first
instruction, however, ended up as being coded as a 16:32-bit far jump. I
assume the intention was a 16:16-bit far jump.

This patch changes only x86_64.

Greetings,
	Alexander

Signed-off-by: Alexander van Heukelum <heukelum@mailshack.com>

---

diff --git a/arch/x86_64/boot/bootsect.S b/arch/x86_64/boot/bootsect.S
index 011b7a4..ae9df0d 100644
--- a/arch/x86_64/boot/bootsect.S
+++ b/arch/x86_64/boot/bootsect.S
@@ -44,7 +44,7 @@ #endif
 _start:
 
 	# Normalize the start address
-	jmpl	$BOOTSEG, $start2
+	jmpw	$BOOTSEG, $start2
 
 start2:
 	movw	%cs, %ax
