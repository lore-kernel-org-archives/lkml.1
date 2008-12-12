Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYLLKDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYLLKDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 05:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYLLKDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 05:03:40 -0500
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:60794 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbYLLKDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 05:03:39 -0500
Date: Fri, 12 Dec 2008 11:03:30 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] cpumask: use maxcpus=NUM to extend the cpu limit
	as well as restrict the limit
Message-ID: <20081212100330.GB4395@osiris.boeblingen.de.ibm.com>
References: <20081211112806.499831000@polaris-admin.engr.sgi.com> <20081211112807.004085000@polaris-admin.engr.sgi.com> <20081211134131.GB6264@osiris.boeblingen.de.ibm.com> <494159C2.5020401@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494159C2.5020401@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 10:19:46AM -0800, Mike Travis wrote:
> Heiko Carstens wrote:
> > maxcpus=n    Restrict boot time cpus to n. Say if you have 4 cpus, using
> > 	     maxcpus=2 will only boot 2. You can choose to bring the
> > 	     other cpus later online, read FAQ's for more info.
> > 
> > It used to be (implementation wise) that maxcpus doesn't influence the number
> > of possible cpus but just indicated how many cpus were brought online at startup
> > of the kernel. Which is what cpu-hotplug.txt describes.
> > 
> > Other present cpus would appear offline and could be brought online later.
> > 
> > For s390 I added the possible_cpus kernel parameter back then, since my
> > understanding back then was that maxcpus doesn't and shouldn't influence the
> > number of possible cpus:
> > 
> > possible_cpus=n		[s390 only] use this to set hotpluggable cpus.
> > 			This option sets possible_cpus bits in
> > 			cpu_possible_map. Thus keeping the numbers of bits set
> > 			constant even if the machine gets rebooted.
> 
> Hmm, I hadn't noticed that.  For a while the X86 devel kernel had an
> "additional_cpus=n" parameter, which was also a bit confusing.  Say you
> wanted, 64 total, you had to give the increment over how many you already
> had [e.g., (want)64 - (have)16  = (additional_cpus=)48.]

Yes, we had the additional_cpus parameter as well. But that was too confusing.
Especially if you add a few cpus while the system is running and then reboot
it. The result for (want) would vary for each configuration change and reboot.

That's why I added possible_cpus to s390, then you get (want) == possible_cpus.

> I just figured that re-using the same kernel parameter was better than adding
> another.  But I'm willing to go either way.

Maybe you could go for possible_cpus as well? Having this in sync for several
architectures seems not so bad :)
