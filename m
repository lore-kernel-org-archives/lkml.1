Return-Path: <linux-kernel-owner+w=401wt.eu-S1765346AbZAPXiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765346AbZAPXiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 18:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZAPXiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 18:38:15 -0500
Received: from relay3.sgi.com ([192.48.171.31]:58894 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752799AbZAPXiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 18:38:14 -0500
Message-ID: <49711A64.3050103@sgi.com>
Date: Fri, 16 Jan 2009 15:38:12 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] cpu freq: fix problems with work_on_cpu usage in
 acpi-cpufreq [PULL request]
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
In-Reply-To: <20090116191108.135927000@polaris-admin.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> This set of patches improves the work_on_cpu() function to
> eliminate circular lock dependencies from occurring by requiring
> the caller to insure the cpu does not go offline.  This effectively
> models the previous behaviour using set_cpus_allowed().
> 
> The other fix is to use a separate work queue for work_on_cpu so
> it does not clash with kevent items that might already be on the
> queue from the same caller.
> 
> This fixes the boot up and suspend/resume to disk problems previously
> seen.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Cc: Dieter Ries <clip2@gmx.de>
> Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
> Cc: Dave Jones <davej@redhat.com>
> Cc: <cpufreq@vger.kernel.org>
> 

Hi Ingo,

If you are ready for these, I've pushed them to the cpus4096-for-ingo
tree.  (Note it's been renamed.)

Thanks!
Mike
--- 

The following changes since commit c99dbbe9f8f6b3e9383e64710217e873431d1c31:
  Mike Travis (1):
        sched: fix warning on ia64

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git master

Mike Travis (1):
      cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write

Rusty Russell (2):
      work_on_cpu: don't try to get_online_cpus() in work_on_cpu.
      work_on_cpu: Use our own workqueue.

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   22 +++++++++-------------
 kernel/workqueue.c                         |   20 ++++++++++----------
 2 files changed, 19 insertions(+), 23 deletions(-)
