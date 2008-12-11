Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYLKNn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYLKNn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 08:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbYLKNnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 08:43:20 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:36388 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbYLKNnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 08:43:19 -0500
Date: Thu, 11 Dec 2008 14:41:31 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] cpumask: use maxcpus=NUM to extend the cpu limit
	as well as restrict the limit
Message-ID: <20081211134131.GB6264@osiris.boeblingen.de.ibm.com>
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112807.004085000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211112807.004085000@polaris-admin.engr.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 03:28:09AM -0800, Mike Travis wrote:
> Impact: allow adding additional cpus.
> 
> Use maxcpus=NUM kernel parameter to extend the number of possible cpus as well
> as (currently) limit them.  Any cpus >= number of present cpus will disabled.
> 
> The ability to HOTPLUG ON cpus that are "possible" but not "present" is
> dealt with in a later patch.

Hm.. documentation/kernel-parameters.txt says:

	maxcpus=	[SMP] Maximum number of processors that an SMP kernel
			should make use of.  maxcpus=n : n >= 0 limits the
			kernel to using 'n' processors.	 n=0 is a special case,
			it is equivalent to "nosmp", which also disables
			the IO APIC.

but documentation/cpu-hotplug.txt says:

maxcpus=n    Restrict boot time cpus to n. Say if you have 4 cpus, using
	     maxcpus=2 will only boot 2. You can choose to bring the
	     other cpus later online, read FAQ's for more info.

It used to be (implementation wise) that maxcpus doesn't influence the number
of possible cpus but just indicated how many cpus were brought online at startup
of the kernel. Which is what cpu-hotplug.txt describes.

Other present cpus would appear offline and could be brought online later.

For s390 I added the possible_cpus kernel parameter back then, since my
understanding back then was that maxcpus doesn't and shouldn't influence the
number of possible cpus:

possible_cpus=n		[s390 only] use this to set hotpluggable cpus.
			This option sets possible_cpus bits in
			cpu_possible_map. Thus keeping the numbers of bits set
			constant even if the machine gets rebooted.

Dunno... it all looks like a mess ;)
