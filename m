Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZFYJI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZFYJI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 05:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZFYJIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 05:08:50 -0400
Received: from baikonur.stro.at ([213.239.196.228]:39295 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZFYJIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 05:08:49 -0400
Date: Thu, 25 Jun 2009 11:08:42 +0200
From: maximilian attems <max@stro.at>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: >= 2.6.30 broken alpha smp build
Message-ID: <20090625090842.GA17936@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC [M]  arch/alpha/kernel/srm_env.o
In file included from /build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/include/linux/percpu.h:10,
                 from /build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/include/asm/local.h:4,
                 from /build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/include/linux/module.h:20,
                 from /build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/kernel/srm_env.c:33:
/build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/include/asm/percpu.h:100:1: error: "PER_CPU_ATTRIBUTES" redefined
/build/buildd-linux-2.6_2.6.30-1-alpha-vHGTgq/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/include/asm/percpu.h:52:1: error: this is the location of the previous definition
make[6]: *** [arch/alpha/kernel/srm_env.o] Error 1
make[5]: *** [arch/alpha/kernel] Error 2
make[4]: *** [sub-make] Error 2
make[3]: *** [all] Error 2
make[2]: *** [debian/stamps/build_alpha_none_alpha-smp_plain] Error 2
make[1]: *** [build_alpha_none_alpha-smp_real] Error 2

belows patch fixes aboves error but gives a new one on SMP

diff --git a/arch/alpha/include/asm/percpu.h b/arch/alpha/include/asm/percpu.h
index 06c5c7a..622d585 100644
--- a/arch/alpha/include/asm/percpu.h
+++ b/arch/alpha/include/asm/percpu.h
@@ -95,8 +95,8 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 #define PER_CPU_SHARED_ALIGNED_SECTION ""
 #define PER_CPU_FIRST_SECTION ""
 
-#endif
-
 #define PER_CPU_ATTRIBUTES
 
+#endif
+
 #endif /* __ALPHA_PERCPU_H */

  CC [M]  arch/alpha/kernel/srm_env.o

cc1: warnings being treated as errors
In file included from /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/include/linux/sched.h:86,
                 from /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/include/asm/uaccess.h:5,
                 from /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/kernel/srm_env.c:37:
/home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/include/linux/hrtimer.h:310: error: �~@~X__used__�~@~Y attribute ignored
In file included from /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/include/asm/uaccess.h:5,
                 from /home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/arch/alpha/kernel/srm_env.c:37:
/home/maks/src/linux-2.6-2.6.30/debian/build/source_alpha_none/include/linux/sched.h:134: error: �~@~X__used__�~@~Y attribute ignored
make[6]: *** [arch/alpha/kernel/srm_env.o] Error 1


-- 
maks
