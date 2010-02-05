Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab0BEU6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:58:11 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:59387 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab0BEU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:58:07 -0500
Subject: [PATCHv4 0/2] sched: arch_scale_smt_powers
From: Joel Schopp <jschopp@austin.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: ego@in.ibm.com, linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       jschopp@austin.ibm.com
In-Reply-To: <1264720808.9660.18.camel@jschopp-laptop>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264548479.12239.54.camel@jschopp-laptop>
	 <1264720808.9660.18.camel@jschopp-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Feb 2010 14:57:46 -0600
Message-ID: <1265403466.6089.39.camel@jschopp-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new Power7 processor has 4 way SMT.  This 4 way SMT benefits from
dynamic power updates that arch_scale_smt_power was designed to provide.
The first patch fixes a generic scheduler bug necessary for arch_scale_smt
to properly function.  The second patch implements arch_scale_smt_power 
for powerpc, and in particular for Power7 processors.

Version 2 changes:
- Drop Patch 1 from the original series since it's in the -tip tree now
- Move enabling the cpu feature into it's own patch (now patch 1)
- Add stubbing out broken x86 implementation to patch 1
- clean up coding style in patch 2

Version 3 changes:
- Added a comment to Patch 2

Version 4 changes:
- Wrap arch_scale_smt_power() in #ifdef CONFIG_SCHED_SMT in Patch 2

---
Joel Schopp (2):
sched: enable ARCH_POWER
powerpc: implement arch_scale_smt_power for Power7

 arch/powerpc/include/asm/cputable.h |    3 +
 arch/powerpc/kernel/smp.c           |   58
++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sched.c         |    6 +--
 kernel/sched_features.h             |    2 -
 4 files changed, 63 insertions(+), 6 deletions(-)


