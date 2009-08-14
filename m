Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbZHNT5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbZHNT5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 15:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbZHNT5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 15:57:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:9291 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757099AbZHNT5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 15:57:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,381,1246863600"; 
   d="scan'208";a="541461376"
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090814192730.GA6431@ldl.fc.hp.com>
References: <20090814163618.GQ7185@ldl.fc.hp.com>
	 <1250276831.3077.17.camel@sbs-t61.sc.intel.com>
	 <20090814192730.GA6431@ldl.fc.hp.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 14 Aug 2009 12:56:39 -0700
Message-Id: <1250279799.3077.41.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-14 at 12:27 -0700, Alex Chiang wrote:
> Hm, I'm not entirely sure about that, for two reasons.
> 
> First (and this is the weaker reason), I'd prefer not to keep
> adding new fields to /proc/cpuinfo if we can help it, as it just
> makes for a continually more complicated ABI/API for userspace.

Overriding same field with different values based on the system will be
confusing. On some systems it will be derived from cpuid, some will be
based on physical slots. This is too confusing.

> Second, I guess I'm not sure what else 'physical id' /should/
> represent. I'm willing to be corrected on this point, so if I'm
> wrong, just call it simple ignorance. :)

As far as possible we kept these fields closer to what the cpuid
instruction says, so that firmware won't mess up the topology detection
etc by having wrong values in the bios tables.

> My quick grep earlier led me to believe that as long as the
> phys_proc_ids were /consistent/ then it didn't seem to matter
> what their /values/ were.

This is correct. But there are several assumptions in the patch that
might break in the future and where ever possible we simply don't want
to depend on what bios says and rather depend on what the cpu/hardware
says.

For example, we shouldn't assume that original phys proc id's calculated
from cpuid etc need not be contiguous and start from 0 etc. This is
platform dependent and may vary from one version to another version of
processor etc.

Also, you are selecting the fixup table based on number of present cpu
etc. I am just nervous that how this all workout across cpu generations
having different cores, sparsely populated sockets in the platform etc.
We just can't afford to go and fix all the old kernels if we have any
problem in the future config setups.

Easiest route will be to add a new entry in /proc/cpuinfo

thanks,
suresh


