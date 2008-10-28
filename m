Return-Path: <linux-kernel-owner+w=401wt.eu-S1753623AbYJ1Ino@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623AbYJ1Ino (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYJ1Ind
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:43:33 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:30652 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYJ1Inb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:43:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=QcGe3xyL05Vz4FvnwN99MBN+/iV/SCEixIQVqBxvYlRYMJZkWVtTC8rNdqwnz14p8h
         VJDIhrPo5zDEGKhiTuhsZHIx4qVTJlBwOXhx/BVFg+V4v352RkO49gUip9fTATYbn0vC
         f4/sZ81oQjittneEyBbDmCbkT4c5UC6TzJYA0=
Message-ID: <4906D0AE.7020903@gmail.com>
Date: Tue, 28 Oct 2008 09:43:26 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH][RESEND] tracing: fix a build error on alpha
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When tracing is enabled, some arch have included <linux/irqflags.h>
on their <asm/system.h> but others like alpha or m68k don't.

Build error on alpha:

kernel/trace/trace.c: In function 'tracing_cpumask_write':
kernel/trace/trace.c:2145: error: implicit declaration of function 'raw_local_irq_disable'
kernel/trace/trace.c:2162: error: implicit declaration of function 'raw_local_irq_enable'

Tested on Alpha through a cross-compiler (should correct a similar issue on m68k).

Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 306e433..c09493e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -34,6 +34,7 @@
 
 #include <linux/stacktrace.h>
 #include <linux/ring_buffer.h>
+#include <linux/irqflags.h>
 
 #include "trace.h"
 
