Return-Path: <linux-kernel-owner+w=401wt.eu-S1764154AbZFPUUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764154AbZFPUUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763021AbZFPURB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:17:01 -0400
Received: from ru.mvista.com ([213.79.90.228]:2501 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1763006AbZFPURA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:17:00 -0400
Date: Wed, 17 Jun 2009 00:16:30 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/2] Makefile: Never use -fno-omit-frame-pointer
Message-ID: <20090616201630.GA4971@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Segher Boessenkool and GCC manual, -fomit-frame-pointer
is only the default when optimising on archs/ABIs where it doesn't
hinder debugging and -pg. So, we do not get it by default on x86,
not at any optimisation level.

On the other hand, *using* -fno-omit-frame-pointer causes gcc to
produce buggy code on PowerPC targets.

If Segher and GCC manual are right, this patch should be a no-op
for all arches except PowerPC, where the patch fixes gcc issues.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

See this thread for more discussion:
http://osdir.com/ml/linux-kernel/2009-05/msg01754.html

p.s.
Obviously, I didn't test this patch on anything else but PPC32. ;-)

Segher, do you know if all GCC versions that we support for
building Linux are behaving the way that GCC manual describe?

Thanks,

 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index ea63667..70ad1ff 100644
--- a/Makefile
+++ b/Makefile
@@ -535,7 +535,7 @@ KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 endif
 
 ifdef CONFIG_FRAME_POINTER
-KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
+KBUILD_CFLAGS	+= -fno-optimize-sibling-calls
 else
 KBUILD_CFLAGS	+= -fomit-frame-pointer
 endif
-- 
1.6.3.1

