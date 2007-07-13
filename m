Return-Path: <linux-kernel-owner+w=401wt.eu-S935854AbXGMT7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935854AbXGMT7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 15:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbXGMT7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 15:59:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757684AbXGMT7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 15:59:15 -0400
Date: Fri, 13 Jul 2007 15:59:08 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 904f7a3f042b5c6aa9e53ce83f2c9de5e33170ff
Message-ID: <20070713195908.GA31803@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4697B7DB.3030006@zytor.com> <20070713182739.GE28567@redhat.com> <20070713193138.GA31781@redhat.com> <alpine.LFD.0.999.0707131252580.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0707131252580.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 12:53:12PM -0700, Linus Torvalds wrote:
 > 
 > 
 > On Fri, 13 Jul 2007, Dave Jones wrote:
 > > 
 > > Can we be a bit less trigger happy about reverting stuff ?
 > > Linus, how do you want to proceed, cpufreq.git has that fixed, but
 > > will you now have to revert the revert, or will I have to do something?
 > 
 > Point mw to your fixed repo, I'll fix it up,

Pull req was sent an hour or so ago, here it is again.

Thanks,

	Dave

Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ 

 Documentation/feature-removal-schedule.txt        |   22 --
 arch/i386/kernel/cpu/cpufreq/Kconfig              |   18 +--
 arch/i386/kernel/cpu/cpufreq/longhaul.c           |    7 +
 arch/i386/kernel/cpu/cpufreq/powernow-k8.c        |   26 ++-
 arch/i386/kernel/cpu/cpufreq/speedstep-centrino.c |  276 ++-------------------
 arch/x86_64/kernel/cpufreq/Kconfig                |    6 +-
 drivers/cpufreq/cpufreq.c                         |   29 ++-
 7 files changed, 65 insertions(+), 319 deletions(-)

commit 9a60ddbcb710ff78cd8c772681723a04e3f5aba3
Author: Dave Jones <davej@redhat.com>
Date:   Fri Jul 13 01:34:10 2007 -0400

    [CPUFREQ] Fix typos in powernow-k8 printk's.
    
    Based on a patch from Joachim which didn't apply, so I fixed
    it up by hand, and also corrected the surrounding indentation
    a little.
    
    Signed-off-by: Joachim.Deguara <joachim.deguara@amd.com>
    Acked-by: Mark Langsdorf <mark.langsdorf@amd.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 084f34939424161669467c19280dbcf637730314
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Jul 9 11:35:28 2007 -0700

    [CPUFREQ] Restore previously used governor on a hot-replugged CPU
    
    Negative side effect: needs NR_CPUs pointer array of memory in
    CONFIG_HOTPLUG_CPU case.
    
    Still needs userspace track keeping and rewriting of governors if governors
    change while a CPU is not active (always the governor at CPU remove time is
    restored).
    
    Move of policy->user_policy.governor assignment is just a minor cleanup.
    http://bugzilla.kernel.org/show_bug.cgi?id=8671
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Mattia Dongili <malattia@linux.it>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 91973de736bc97dc04156242c5a4b00993b6c902
Author: Peter Oruba <peter.oruba@amd.com>
Date:   Mon Jul 9 11:35:27 2007 -0700

    [CPUFREQ] bugfix cpufreq in combination with performance governor
    
    There is a frequency scaling issue that I encountered with the performance
    governor in combination with CPU hotplug.
    
    In cpufreq.c CPU frequency is reduced to its minimum before the CPU gets
    unregistered and set offline.  Does that have a particular reason?
    
    Since the (k8-)governor does not monitor CPU frequency that setting also
    applies then to the remaining CPU as well and lets the system run on the
    lowest frequency although performance is chose as the policy.
    
    Signed-off-by: Peter Oruba <peter.oruba@amd.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit aac22d0a79f51d7bd93145be36322baaa4b423f8
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Mon Jul 9 11:35:27 2007 -0700

    [CPUFREQ] powernow-k8 compile fix.
    
    Make it compile on UP.
    
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 68485695e5a84399da7b48b208ac42623fe22963
Author: Adrian Bunk <bunk@stusta.de>
Date:   Sun Jul 8 23:39:14 2007 +0200

    [CPUFREQ] the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI
    
    This patch contains the overdue removal of X86_SPEEDSTEP_CENTRINO_ACPI.
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 905497c4b2e6715eebde97cbcb313354e14c2489
Author: Rafał Bilski <rafalbilski@interia.pl>
Date:   Sun Jul 8 21:51:26 2007 +0200

    [CPUFREQ] Longhaul - Option to disable ACPI C3 support
    
    On some motherboards ACPI C3 is available, but it isn't
    causing frequency transition on VIA Nehemiah. Longhaul
    wasn't working at all earlier, but due to
    scaling_cur_speed returning true CPU frequency now, it
    looks like CPU is getting stuck at highest frequency
    since 2.6.21. I didn't find a reason. Halt is causing
    frequency transition.
    
    Signed-off-by: Rafal Bilski <rafalbilski@interia.pl>
    Signed-off-by: Dave Jones <davej@redhat.com>

-- 
http://www.codemonkey.org.uk
