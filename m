Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYAJKU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYAJKU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYAJKUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:20:16 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:43838 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYAJKUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:20:15 -0500
Date: Thu, 10 Jan 2008 12:19:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080110101928.GC28740@does.not.exist>
References: <20080103442.621670000@suse.de> <20080103154229.9723F14DDD@wotan.suse.de> <20080103181438.GA7141@does.not.exist> <200801031943.43828.ak@suse.de> <20080110095407.GB28740@does.not.exist> <20080110095857.GN25945@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080110095857.GN25945@bingen.suse.de>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 10:58:57AM +0100, Andi Kleen wrote:
> > It seems the correct solution would be not to hijack __cpuinit
> > (as your patch does), but to create a new annotation.
> 
> The rationale is that after suspend the CPU has to be reinitialized.
> That is because it is essentially like a reboot. All the previous
> CPU state is gone.
>...

But your patch does:

+config PM_CPUINIT
+       bool
+       depends on PM
+       default y

As an example, even plain ACPI support without any suspend support in 
the kernel at all requires CONFIG_PM and therefore forces all __cpuinit 
code to be non-__init after your patch.

And if the dependency was corrected to PM_SLEEP it will still make 
the UP kernel use more memory since we currently have __cpuinit code 
that gets discarded after boot but suspend/resume is apparently working.

Plus my other point that it seems to be wrong to do whatever change only 
for x86.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

