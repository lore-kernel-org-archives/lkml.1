Return-Path: <linux-kernel-owner+w=401wt.eu-S934291AbYA2Tml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbYA2Tml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbYA2Tll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:41:41 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52740 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbYA2Tli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:41:38 -0500
Date: Tue, 29 Jan 2008 11:15:31 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 3/4] x86_64: Use early reservation for early node data
In-reply-to: <200801291113.35974.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-id: <200801291115.32050.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801291113.35974.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@suse.de>

[PATCH 3/4] x86_64: Use early reservation for early node data

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

===================================================================
--- linux.orig/arch/x86/mm/numa_64.c
+++ linux/arch/x86/mm/numa_64.c
@@ -175,6 +175,7 @@
 		 * with bss section
 		 */
 		mem = round_up(mem, PAGE_SIZE);
+		reserve_early(mem, mem + size);
 		return __va(mem);
 	}
 	ptr = __alloc_bootmem_nopanic(size,
