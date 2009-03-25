Return-Path: <linux-kernel-owner+w=401wt.eu-S1758802AbZCYJPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802AbZCYJPO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 05:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbZCYJOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 05:14:04 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:59972 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758400AbZCYJOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 05:14:01 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [RFC PATCH 00/11] sched: find_busiest_group() cleanup
To: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       "Balbir Singh" <balbir@in.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Date: Wed, 25 Mar 2009 14:43:30 +0530
Message-ID: <20090325091239.13992.96090.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset contains the cleanup of the humongous find_busiest_group()
function.

Vaidy had  tried a hand at this before. His approach can be
found here:
http://lkml.org/lkml/2008/9/24/201 and
http://lkml.org/lkml/2008/10/9/176

Though the code in this patchset has been written from scratch I have
reused some of the ideas that Vaidy had originally proposed.
Credit has been given whereever it is due :)

The patches in this series are incremental. Each one is a functional patch,
which compiles fine.

The steps followed in the cleanup are as follows:
- Fix indentations.

- Group variables that serve a common high-level purpose into a single
  structure.

- Use helper functions to perform all the calculatations, like calculating
  the sched_domain and sched_group statistics, calculating the imbalance, etc.

- Move the power_savings_balance part, which depends on
  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) into a different section, thereby
  eliminating the #ifdef jungle in helper functions.

- Add /** style comments for all the functions, including find_busiest_group()

- Add additional comments whereever appropriate.

After applying all the patches, the size of find_busiest_group() goes down
from 313 lines to 76 lines. Of course, there are the helpers, but effort
has been put to keep all the helper functions within the 80 line limit.

Any feedback on the patches and how the functionality can be tested is greatly
appreciated.

---

Gautham R Shenoy (11):
      sched: Add comments to find_busiest_group() function.
      sched: Refactor the power savings balance code.
      sched: Optimize the !power_savings_balance during find_busiest_group.
      sched: Create a helper function to calculate imbalance.
      sched: Create helper to calculate small_imbalance in find_busiest_group.
      sched: Create a helper function to calculate sched_domain stats for fbg()
      sched: Define structure to store the sched_domain statistics for fbg()
      sched: Create a helper function to calculate sched_group stats for fbg()
      sched: Define structure to store the sched_group statistics for fbg()
      sched: Fix indentations in find_busiest_group using gotos.
      sched: Simple helper functions for find_busiest_group()


 kernel/sched.c |  765 ++++++++++++++++++++++++++++++++++++++------------------
 1 files changed, 515 insertions(+), 250 deletions(-)

-- 
Thanks and Regards
gautham.
