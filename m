Return-Path: <linux-kernel-owner+w=401wt.eu-S966550AbYD1TXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966550AbYD1TXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966284AbYD1TXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:23:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965176AbYD1TXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:23:18 -0400
Date: Mon, 28 Apr 2008 15:22:44 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: cpufreq pull request for 2.6.26
Message-ID: <20080428192244.GB18326@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slightly late, but mostly trivial stuff..

Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ 

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   10 ++
 drivers/acpi/processor_thermal.c           |   30 ++++---
 drivers/cpufreq/cpufreq.c                  |  129 ++++++++++++---------------
 drivers/cpufreq/cpufreq_stats.c            |    6 +-
 4 files changed, 88 insertions(+), 87 deletions(-)

commit e56a727b023d40d1adf660168883f30f2e6abe0a
Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Date:   Mon Apr 28 15:13:43 2008 -0400

    [CPUFREQ] Make acpi-cpufreq more robust against BIOS freq changes behind our back.
    
    We checked the hardware freq with OS cached freq value in get_cur_freqon_cpu().
    
    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit c938ac21329f19ad286eaaed7e26434943c8061b
Author: Mike Travis <travis@sgi.com>
Date:   Wed Mar 5 08:31:29 2008 -0800

    [CPUFREQ] change cpu freq tables to per_cpu variables
    
    Change cpufreq tables from arrays to per_cpu variables in
    drivers/acpi/processor_thermal.c
    
    Based on git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    
    Cc: Len Brown <len.brown@intel.com>
    Signed-off-by: Mike Travis <travis@sgi.com>
    Signed-off-by: Dave Jones <davej@codemonkey.org.uk>

commit 25aca347d49ffc38aa3b7e63ce9b90df7f8b79c8
Author: Cesar Eduardo Barros <cesarb@cesarb.net>
Date:   Sat Feb 16 08:41:25 2008 -0200

    [CPUFREQ] fix show_trans_table
    
    Fix show_trans_table when it overflows PAGE_SIZE.
    
    * Not all snprintf calls were protected against being passed a negative
    length.
    * When show_trans_table overflows, len might be > PAGE_SIZE. In that case,
    returns PAGE_SIZE.
    
    Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
    Signed-off-by: Dave Jones <davej@codemonkey.org.uk>

commit 74212ca432982903d0fc6a0f282b199e000ad8b1
Author: Cesar Eduardo Barros <cesarb@cesarb.net>
Date:   Sat Feb 16 08:41:24 2008 -0200

    [CPUFREQ] Warn when cpufreq_register_notifier called before pure initcalls
    
    If cpufreq_register_notifier is called before pure initcalls,
    init_cpufreq_transition_notifier_list will overwrite whatever it did,
    causing notifiers to be ignored.
    
    Print some noise to the kernel log if that happens.
    
    Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
    Signed-off-by: Dave Jones <davej@codemonkey.org.uk>

commit 457091181176643787a547dc04eb3cf5dcd822ce
Author: Dave Jones <davej@redhat.com>
Date:   Wed Mar 5 14:07:34 2008 -0500

    [CPUFREQ] Refactor locking in cpufreq_add_dev
    
    Simplify this by moving the unlocking out of the error
    paths into the exit path.
    
    Signed-off-by: Dave Jones <davej@codemonkey.org.uk>

commit 905d77cd95e856b8e0b2d099fb70b9b8ccb7337e
Author: Dave Jones <davej@redhat.com>
Date:   Wed Mar 5 14:28:32 2008 -0500

    [CPUFREQ] more CodingStyle
    
    void * p   ->  void *p
    no space between function parameters
    removed excess whitespace
    
    Signed-off-by: Dave Jones <davej@codemonkey.org.uk>

commit 4d34a67d0204029079815c8c2753ca647cd0e7e9
Author: Dave Jones <davej@redhat.com>
Date:   Thu Feb 7 16:33:49 2008 -0500

    [CPUFREQ] CodingStyle
    
    return is not a function.
    
    Signed-off-by: Dave Jones <davej@redhat.com>

commit c906049447019d69b9cc2d591a142af561afa7f9
Author: Dave Jones <davej@redhat.com>
Date:   Thu Feb 7 16:32:18 2008 -0500

    [CPUFREQ] Slightly shorten the error paths of cpufreq_suspend/cpufreq_resume
    
    Signed-off-by: Dave Jones <davej@redhat.com>



-- 
http://www.codemonkey.org.uk
