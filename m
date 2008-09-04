Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYIDNws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYIDNws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 09:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbYIDNwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 09:52:38 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:59111
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751340AbYIDNwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 09:52:38 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: Re: oltp ~10% regression with 2.6.27-rc5 on stoakley machine
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: peterz@infradead.org, Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, mingo@elte.hu
Date: Thu, 04 Sep 2008 09:50:13 -0400
Message-ID: <20080904134959.26109.90529.stgit@dev.haskins.net>
In-Reply-To: <1220526360.8609.213.camel@twins>
References: <1220526360.8609.213.camel@twins>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Peter Zijlstra wrote:
>
>
> Also, we used to have some auto-tuning in there, which dissapeared some
> time ago, gregory brought it back to live recently, perhaps he likes to
> share? :-)
>

Per your request, I brought those "revert" patches I had in the PQ branch
forward to 2.6.27-rc5.  They are completely unbuilt and untested, but here
for your experimentation.

-Greg

---

Gregory Haskins (4):
      sched: make task_hot() once again use sd->cache_hot_time
      Revert "sched: zap the migration init / cache-hot balancing code"
      Revert "[PATCH] sched: remove cache_hot_time"
      revert "sched: sched_cacheflush is now unused"


 Documentation/kernel-parameters.txt |   43 +++
 arch/ia64/kernel/setup.c            |   15 +
 arch/mips/kernel/smp.c              |   11 +
 arch/sparc/kernel/smp.c             |   10 +
 arch/sparc64/kernel/smp.c           |   27 ++
 arch/x86/kernel/smpboot.c           |   12 +
 include/asm-m32r/system.h           |   10 +
 include/asm-mips/system.h           |   10 +
 include/asm-parisc/system.h         |   11 +
 include/asm-x86/system.h            |    9 +
 include/linux/sched.h               |    7 
 include/linux/topology.h            |    1 
 kernel/sched.c                      |  499 ++++++++++++++++++++++++++++++++++-
 13 files changed, 656 insertions(+), 9 deletions(-)

-- 
Signature
