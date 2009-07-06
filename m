Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbZGFFGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbZGFFGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 01:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbZGFFGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 01:06:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58986 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZGFFGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 01:06:44 -0400
Date: Mon, 6 Jul 2009 15:06:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the percpu tree with the tip tree
Message-Id: <20090706150634.04255209.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/x86/kernel/cpu/perf_counter.c between commit
0406ca6d8e849d9dd027c8cb6791448e81411aef ("perf_counter: Ignore the nmi
call frames in the x86-64 backtraces") from the tip tree and commit
245b2e70eabd797932adb263a65da0bab3711753 ("percpu: clean up percpu
variable definitions") from the percpu tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/cpu/perf_counter.c
index 36c3dc7,13bd6d6..0000000
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@@ -1559,9 -1559,8 +1559,9 @@@ void callchain_store(struct perf_callch
  		entry->ip[entry->nr++] = ip;
  }
  
- static DEFINE_PER_CPU(struct perf_callchain_entry, irq_entry);
- static DEFINE_PER_CPU(struct perf_callchain_entry, nmi_entry);
+ static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_irq_entry);
+ static DEFINE_PER_CPU(struct perf_callchain_entry, pmc_nmi_entry);
 +static DEFINE_PER_CPU(int, in_nmi_frame);
  
  
  static void
