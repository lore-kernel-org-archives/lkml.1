Return-Path: <linux-kernel-owner+w=401wt.eu-S1755212AbYAIV5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbYAIV5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbYAIV52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:57:28 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:59461 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYAIV52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:57:28 -0500
Date: Wed, 9 Jan 2008 22:57:25 +0100
From: Andi Kleen <andi@firstfloor.org>
To: jreiser@BitWagon.com, mingo@elte.hu
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: STT_FUNC for assembler checksum and semaphore ops" in git-x86
Message-ID: <20080109215725.GA18185@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 09 Jan 2008 21:51:17.0049 (UTC) FILETIME=[C2F1B290:01C85309]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In gitx86:

commit 692effca950d7c6032e8e2ae785a32383e7af4a3
Author: John Reiser <jreiser@BitWagon.com>
Date:   Wed Jan 9 13:31:12 2008 +0100

    STT_FUNC for assembler checksum and semaphore ops
...
    Comments?
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
index adbccd0..1f9aacb 100644
--- a/arch/x86/lib/checksum_32.S
+++ b/arch/x86/lib/checksum_32.S
@@ -48,6 +48,7 @@ unsigned int csum_partial(const unsigned char * buff, int len, unsigned int sum)
           * Fortunately, it is easy to convert 2-byte alignment to 4-byte
           * alignment for the unrolled loop.
           */           
+       .type csum_partial, @function
 ENTRY(csum_partial)
+       .type csum_partial, @function
 ENTRY(csum_partial)
        CFI_STARTPROC
        pushl %esi
@@ -141,11 +142,13 @@ ENTRY(csum_partial)
        ret
        CFI_ENDPROC
 ENDPROC(csum_partial)
+       .size csum_partial, . - csum_partial

AK:
Better option would be to just add to ENTRY/ENDPROC

do something like (untested) 

#define ENTRY(x) \
	...
	.set curfunc, x

#define ENDPROC(x) \
	...
	.size x - curfunc

-Andi
