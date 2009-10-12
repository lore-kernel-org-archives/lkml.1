Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbZJLLgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbZJLLgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbZJLLgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:36:48 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:47535 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbZJLLgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:36:47 -0400
Date: Mon, 12 Oct 2009 17:06:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [v8 PATCH 1/8]: cpuidle: cleanup drivers/cpuidle/cpuidle.c
Message-ID: <20091012113602.GC3007@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091008094828.GA20595@linux.vnet.ibm.com>
 <20091008094942.GB20595@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091008094942.GB20595@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R B <arun@linux.vnet.ibm.com> [2009-10-08 15:19:42]:

> * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-08 15:18:28]:
> 
> This patch cleans up drivers/cpuidle/cpuidle.c
> Earlier cpuidle assumed pm_idle as the default idle loop. Break that
> assumption and make it more generic. cpuidle_idle_call() which is the
> main idle loop of cpuidle is to be called by architectures which have
> registered to cpuidle.
> 
> Remove routines cpuidle_install/uninstall_idle_handler() which are not
> needed anymore.
> 
>

[snip]

  /**
> - * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
> - */
> -void cpuidle_install_idle_handler(void)
> -{
> -	if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
> -		/* Make sure all changes finished before we switch to new idle */
> -		smp_wmb();
> -		pm_idle = cpuidle_idle_call;
> -	}
> -}
> -
> -/**
> - * cpuidle_uninstall_idle_handler - uninstalls the cpuidle idle loop handler
> - */
> -void cpuidle_uninstall_idle_handler(void)
> -{
> -	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
> -		pm_idle = pm_idle_old;
> -		cpuidle_kick_cpus();
> -	}
> -}
> -

I see the routines above being called in from
cpuidle_pause/resume_and_lock/unlock below and they are entries from
ACPI on ACPI_PROCESSOR_NOTIFY_POWER and from the hotplug path, could
you test them to make sure they are not broken. We also seem to be
missing a cpuidle_kick_cpus() in cpuidle_pause_and_lock()

[snip]

-- 
	Balbir
