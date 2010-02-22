Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0BVOBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 09:01:44 -0500
Received: from mail-px0-f184.google.com ([209.85.216.184]:62381 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0BVOBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 09:01:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=DLU4+W2KV+WPUcJ9ezcpWv8C6jhBMVnXZK1VpNfT4t5Wb3j26YTFi8AsuGyUu5z39m
         yMA/BgewQiQcc7S82mL2ViLaEVTvcRlPE56v9E8ZdZU0K1S1IBrI2OKKqzByNRRR5jVJ
         wylJW+zUsW5JjOaPTjL2nsRrW7DX4QZjAzy+Y=
MIME-Version: 1.0
Date: Mon, 22 Feb 2010 19:31:41 +0530
Message-ID: <f5a7b3811002220601k3525f733jb046cfe3ee69963a@mail.gmail.com>
Subject: error: 'subbuf_idx' undeclared after enabling CONFIG_LTT_RELAY_LOCKED=y
From: naresh kamboju <naresh.kernel@gmail.com>
To: ltt-dev@lists.casi.polymtl.ca
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have noticed below error after enabling CONFIG_LTT_RELAY_LOCKED=y

  CC      ltt/ltt-relay-locked.o
In file included from ltt/ltt-relay-locked.c:56:
ltt/ltt-relay-locked.h: In function 'ltt_check_deliver':
ltt/ltt-relay-locked.h:167:  (first use in this function)
ltt/ltt-relay-locked.h:167: error: (Each undeclared identifier is
reported only once
ltt/ltt-relay-locked.h:167: error: for each function it appears in.)

After my work around I have found error is caused from the
lttng-relay-locked-writer-use-noref-flag.patch

Below patch will fix the compilation issues.
Please review this patch.

---
 ltt/ltt-relay-locked.h |    2  1 +     1 -     0 !
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/ltt/ltt-relay-locked.h
===================================================================
--- a/ltt/ltt-relay-locked.h
+++ b/ltt/ltt-relay-locked.h
@@ -164,7 +164,7 @@ static __inline__ void ltt_check_deliver
                 */
                ltt_set_noref_flag(rchan, buf, idx);
 #ifdef CONFIG_LTT_VMCORE
-               ltt_buf->commit_seq[subbuf_idx] = commit_count;
+               ltt_buf->commit_seq[idx] = commit_count;
 #endif
                ltt_buf->wakeup_readers = 1;
        }

For your information LTTng configuration. dotconfig


CONFIG_LTT=y
CONFIG_LTT_FILTER=m
CONFIG_HAVE_LTT_DUMP_TABLES=y
CONFIG_LTT_RELAY_ALLOC=y
# CONFIG_LTT_RELAY_LOCKLESS is not set
# CONFIG_LTT_RELAY_IRQOFF is not set
CONFIG_LTT_RELAY_LOCKED=y
CONFIG_LTT_SERIALIZE=y
CONFIG_LTT_FAST_SERIALIZE=y
CONFIG_LTT_TRACEPROBES=m
CONFIG_LTT_TRACE_CONTROL=y
CONFIG_LTT_TRACER=y
CONFIG_LTT_ALIGNMENT=y
CONFIG_LTT_CHECK_ARCH_EFFICIENT_UNALIGNED_ACCESS=y
# CONFIG_LTT_DEBUG_EVENT_SIZE is not set
CONFIG_LTT_USERSPACE_EVENT=m
CONFIG_LTT_VMCORE=y
CONFIG_LTT_STATEDUMP=m
CONFIG_LTT_KPROBES=m

Please review the patch and provide your comments.

Kernel: 2.6.29-RT
Lttng: 0.158
ARCH: ARM

Best regards
Naresh Kamboju
