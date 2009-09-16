Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbZIPT4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbZIPT4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZIPT4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:56:49 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:58520 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbZIPT4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:56:48 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix oprofile regression: select RING_BUFFER_ALLOW_SWAP
Date: Wed, 16 Sep 2009 21:56:49 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Robert Richter <robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909162156.49239.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 85bac32c4a52c592b857f2c360cc5ec93a097d70                                                                                                                             
    ring-buffer: only enable ring_buffer_swap_cpu when needed
broke oprofile (at least on s390, but likely on all platforms).

this patch lets oprofile select RING_BUFER_ALLOW_SWAP to make 
ring_buffer_swap_cpu usable for oprofile.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CC-ed: Steven Rostedt <srostedt@redhat.com> 
CC-ed: Ingo Molnar <mingo@elte.hu>
CC-ed: Robert Richter <robert.richter@amd.com>                                                                                                                      
---
 arch/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/arch/Kconfig
===================================================================
--- linux-2.6.orig/arch/Kconfig
+++ linux-2.6/arch/Kconfig
@@ -9,6 +9,7 @@ config OPROFILE
 	depends on TRACING_SUPPORT
 	select TRACING
 	select RING_BUFFER
+	select RING_BUFFER_ALLOW_SWAP
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
