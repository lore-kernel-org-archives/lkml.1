Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbZJFQgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbZJFQgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbZJFQgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:36:22 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:41913 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbZJFQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:36:21 -0400
Date: Tue, 6 Oct 2009 22:05:21 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       linux-arch@vger.kernel.org
Subject: Re: [v7 PATCH 0/7]: cpuidle/x86/POWER: Cleanup idle power
	management code in x86, cleanup drivers/cpuidle/cpuidle.c and
	introduce cpuidle to POWER.
Message-ID: <20091006163521.GA10425@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20091006152421.GA7278@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091006152421.GA7278@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-10-06 20:54:21]:

> Hi
> 
> Please consider this for inclusion into the testing tree.
> 
> This patchset introduces cpuidle infrastructure to POWER, prototyping
> for pSeries, and also does a major refactoring of current x86 idle
> power management and a cleanup of cpuidle infrastructure.
> 
> Earlier discussions on the same can be found at:
> 
> v6 --> http://lkml.org/lkml/2009/9/22/180
> v5 --> http://lkml.org/lkml/2009/9/22/26
> v4 --> http://lkml.org/lkml/2009/9/1/133
> v3 --> http://lkml.org/lkml/2009/8/27/124
> v2 --> http://lkml.org/lkml/2009/8/26/233
> v1 --> http://lkml.org/lkml/2009/8/19/150
> 
> 
> Changes in this version:
> -----------------------------------------
> 
> * Earlier implementation maintained a list of cpuidle devices and
>   the list was traversed to disable and enable the cpuidle devices
>   when switching governors. This list is not necessary and is removed.
>   Now, we get the per cpu structure cpuidle_devices and disable and
>   enable it for each online cpu while switching governors.
> 
> * Earlier iterations were buggy w.r.t the sysfs interface of the cpuidle.
>   This iteration removes the bug in PATCH 1/7.
> 
> * In PATCH 7/7, smt_snooze_delay was not being updated whenever it was
>   changed through the sysfs interface. Provide a helper routine to
>   update it.
> 
> * In PATCH 7/7, the idle loops are renamed to denote the idle states
>   to avoid any confusion.
> 

Also, the per-cpu nature of registration/unregistration of cpuidle
has been maintained as ACPI needs this.

> 
> thanks,
> arun
