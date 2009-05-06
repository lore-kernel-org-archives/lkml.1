Return-Path: <linux-kernel-owner+w=401wt.eu-S1757061AbZEFG5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbZEFG5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZEFG4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:56:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:35146 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbZEFG4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:56:52 -0400
Date: Wed, 6 May 2009 06:55:31 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, benh@kernel.crashing.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, yinghai@kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F654E9.4070809@kernel.org>
References: <49F654E9.4070809@kernel.org>
Subject: [tip:irq/numa] irq: change ->set_affinity() to return status, fix
Message-ID: <tip-b2e5d8588de0b5341eddad87dbe48d2185eaa3dd@git.kernel.org>
Git-Commit-ID: b2e5d8588de0b5341eddad87dbe48d2185eaa3dd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 06:55:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2e5d8588de0b5341eddad87dbe48d2185eaa3dd
Gitweb:     http://git.kernel.org/tip/b2e5d8588de0b5341eddad87dbe48d2185eaa3dd
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 6 May 2009 07:55:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 07:55:33 +0200

irq: change ->set_affinity() to return status, fix

This build failure:

 arch/powerpc/sysdev/mpic.c:810: error: conflicting types for 'mpic_set_affinity'
 arch/powerpc/sysdev/mpic.h:39: error: previous declaration of 'mpic_set_affinity' was here
 make[2]: *** [arch/powerpc/sysdev/mpic.o] Error 1
 make[2]: *** Waiting for unfinished jobs....

Triggers because the function prototype was not updated when the
function call signature got changed by:

   d5dedd4: irq: change ->set_affinity() to return status

[ Impact: build fix on powerpc ]

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-arch@vger.kernel.org
LKML-Reference: <49F654E9.4070809@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/sysdev/mpic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/sysdev/mpic.h b/arch/powerpc/sysdev/mpic.h
index 3cef2af..eff433c 100644
--- a/arch/powerpc/sysdev/mpic.h
+++ b/arch/powerpc/sysdev/mpic.h
@@ -36,6 +36,6 @@ static inline int mpic_pasemi_msi_init(struct mpic *mpic)
 
 extern int mpic_set_irq_type(unsigned int virq, unsigned int flow_type);
 extern void mpic_set_vector(unsigned int virq, unsigned int vector);
-extern void mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask);
+extern int mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask);
 
 #endif /* _POWERPC_SYSDEV_MPIC_H */
