Return-Path: <linux-kernel-owner+w=401wt.eu-S1759700AbZKLAU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700AbZKLAU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759164AbZKLAU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:20:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:29085 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758940AbZKLAU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:20:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,726,1249282800"; 
   d="scan'208";a="512960646"
Subject: Re: [PATCH] cpufreq: fix conservative/ondemand behaviour with
 ignore_nice_load
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Alexander Miller <Miller@fmi.uni-stuttgart.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
In-Reply-To: <200911112310.45175.Miller@fmi.uni-stuttgart.de>
References: <200911061727.17541.Miller@fmi.uni-stuttgart.de>
	 <B5B0CFF685D7DF46A05CF1678CFB42ED20E0C63D@orsmsx505.amr.corp.intel.com>
	 <20091110222038.GA32028@linux-os.sc.intel.com>
	 <200911112310.45175.Miller@fmi.uni-stuttgart.de>
Content-Type: text/plain
Date: Wed, 11 Nov 2009 16:20:25 -0800
Message-Id: <1257985225.21141.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 14:10 -0800, Alexander Miller wrote:
> On Tue, Nov 10, 2009, Pallipadi, Venkatesh wrote:
> > > Can you describe the "unresonable behavior" you are seeing. Is it
> > > with NO_HZ enabled or disabled?
> $ zgrep NO_HZ /proc/config.gz
> # CONFIG_NO_HZ is not set
> 
> When there are two cpu-intense processes, one with nice 19 and the other
> with nice 0, then the latter will use almost 100% cpu time, of course.
> But the cpu has been stuck at the lowest frequency without the patch.
> To be exact, it would change the freq sometimes, but return to the
> lowest freq within a fraction of a second.
> I would expect it to select a freq such that the non-nice processes
> take <80% or the highest freq (which it does with the patch).
> 
> > > I see there can be a problem with this code when NO_HZ is disabled.
> > > But, the patch below is not the right solution as it will result in
> > > Adding times in different units with NO_HZ enabled.
> 
> Yes, you are right. Looks like I've patched the wrong half of the
> inconsistency :-(
> I think it's a bit irritating you are using cputime64_t to store
> microseconds. At least it fooled me (I'm no kernel guy though) into
> thinking that get_cpu_idle_time_jiffy() returning jiffies was the
> intended behaviour.

Agreed. That cputime64 is ugly. There is also some confusion with naming
of get_cpu_idle_time_jiffy and get_cpu_idle_time_us and these routines
being redundantly repeated across 2 files. Will add them to my todo
queue.

> 
> > Does the below test patch (only compile tested) resolve the problem you
> > are seeing?
> 
> I've just rebooted the machine with the new patched kernel, and
> it looks good.

Ok. Thanks for reporting (and diagnosing as well :)) and verifying the
patch. I will resend the patch with a bit more description and your
Reported/Tested-by.

Thanks,
Venki


