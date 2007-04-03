Return-Path: <linux-kernel-owner+w=401wt.eu-S965574AbXDCNnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965574AbXDCNnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 09:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965846AbXDCNnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 09:43:04 -0400
Received: from ns.suse.de ([195.135.220.2]:56476 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965574AbXDCNnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 09:43:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: [PATCH 1/3] Introduce cpuid_on_cpu() and cpuid_eax_on_cpu()
Date: Tue, 3 Apr 2007 15:42:50 +0200
User-Agent: KMail/1.9.6
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       cpufreq@lists.linux.org.uk, hpa@zytor.com, davej@codemonkey.org.uk
References: <20070402113831.GA6785@localhost.sw.ru> <200704021410.29623.ak@suse.de> <20070403133946.GA6536@localhost.sw.ru>
In-Reply-To: <20070403133946.GA6536@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704031542.50630.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Both powernow-k8 and cpuid attempt to schedule
> > to the target CPU so they should already run there. But it is some other CPU,
> > but when they ask your _on_cpu() functions they suddenly get a "real" CPU?
> > Where is the difference between these levels of virtualness?
> 
> *_on_cpu functions do some work on given physical CPU.
> set_cpus_allowed() in openvz operates on VCPU level, so process doing
> set_cpus_allowed() still could be scheduled anywhere. 

Ok so you have multple levels.

> > Also it has weird semantics. For example if you have multiple
> > virtual CPUs mapping to a single CPU then would the powernow-k8 driver
> > try to set the frequency multiple times on the same physical CPU?
> 
> If core cpufreq locking is OK, why would it?

It won't know about multiple CPUs mapping to a single CPU.
 
> apply_microcode() looks small enough to convert it to IPIs, but so far
> nobody asked for microcode updates in openvz.

Well if they try it they will probably have problems.
 
> > Before adding any hacks like this I think your vcpu concept
> > needs to be discussed properly on l-k. For me it doesn't look like it is
> > something good right now though.
> 
> Andi, I think it all relies on correctness of core cpufreq locking.

I have my doubts it will cope with you changing all reasonable expected semantics 
under it.

-Andi

