Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbYAaW4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbYAaW4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbYAaWz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:55:59 -0500
Received: from gw.goop.org ([64.81.55.164]:53484 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbYAaWz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:55:58 -0500
Message-ID: <47A251E9.4050606@goop.org>
Date: Thu, 31 Jan 2008 14:55:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Campbell <ijc@hellion.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: PAE swapper_pg_dir needs to be page-sized
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen currently needs swapper_pg_dir page aligned and sized.  This fixes
the second part of that...

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/head_32.S |    1 +
 1 file changed, 1 insertion(+)

===================================================================
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -640,6 +640,7 @@
 # else
 #  error "Kernel PMDs should be 1, 2 or 3"
 # endif
+	.align PAGE_SIZE_asm		/* needs to be page-sized too */
 #endif
 
 .data


