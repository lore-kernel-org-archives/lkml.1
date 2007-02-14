Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbXBNVsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbXBNVsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964783AbXBNVsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:48:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33069 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964787AbXBNVr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:47:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ego@in.ibm.com
Subject: Re: [RFC PATCH(Experimental) 0/4] Freezer based Cpu-hotplug
Date: Wed, 14 Feb 2007 22:43:35 +0100
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, paulmck@us.ibm.com, mingo@elte.hu, vatsa@in.ibm.com,
       dipankar@in.ibm.com, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org, oleg@tv-sign.ru
References: <20070214144031.GA15257@in.ibm.com>
In-Reply-To: <20070214144031.GA15257@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702142243.37189.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, 14 February 2007 15:40, Gautham R Shenoy wrote:
> Hello Everybody,
> 
> This is an experiment towards process_freezer based implementation
> of cpu-hotplug. This is mainly based on ideas of Andrew Morton, 
> Ingo Molnar and Paul Mckenney featured in the discussion
> http://lkml.org/lkml/2007/1/31/323.
> 
> This is an absolute bare-minimal implementation to check the feasibility
> of using process freezer for cpu-hotplug. 
> 
> The patchset comprises of four patches.
> o PATCH 1/4: Core implementation of freezer-based-hotplug.
> o PATCH 2/4: Revert changes to workqueue to make it work with the
>              freezer-cpu-hotplug.
> o PATCH 3/4: Eliminate hotcpu subsystem mutexes from sched and slab.
> o PATCH 4/4: Eliminate lock_cpu_hotplug from the kernel.

I think two things are missing:

1) We should make sure there are not PF_NOFREEZE tasks running when a CPU
is removed (when one is added probably too).  For this purpose we can add a
parameter to freeze_processes() that will tell it to ignore PF_NOFREEZE, but
at the same time we'll have to change all kernel threads that set PF_NOFREEZE
to call try_to_freeze() anyway.  I can do that, but it will take me a couple of
days.

2) We have to change the PM code to stop using CPU hotplug for disabling
nonboot CPUs. ;-)

Greetings,
Rafael
