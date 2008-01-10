Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbYAJJzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbYAJJzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752900AbYAJJy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:54:56 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37892 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbYAJJyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:54:55 -0500
Date: Thu, 10 Jan 2008 11:54:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <ak@suse.de>
Cc: rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080110095407.GB28740@does.not.exist>
References: <20080103442.621670000@suse.de> <20080103154229.9723F14DDD@wotan.suse.de> <20080103181438.GA7141@does.not.exist> <200801031943.43828.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801031943.43828.ak@suse.de>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 07:43:43PM +0100, Andi Kleen wrote:
> On Thursday 03 January 2008 19:14:38 Adrian Bunk wrote:
> > On Thu, Jan 03, 2008 at 04:42:29PM +0100, Andi Kleen wrote:
> > > 
> > > This avoids the requirement to mark a lot of initialization functions not 
> > > __cpuinit just for resume from RAM.
> > > 
> > > More functions could be converted now, didn't do all.
> > >...
> > 
> > Shouldn't this aready be handled by the following?
> > 
> > config PM_SLEEP_SMP
> >         bool
> >         depends on SUSPEND_SMP_POSSIBLE || HIBERNATION_SMP_POSSIBLE
> >         depends on PM_SLEEP
> >         select HOTPLUG_CPU
> >         default y
> 
> Won't help for UP at least. 

I know that it's not popular to care about the kernel size, but your 
patch will cost precious memory in the common case of UP embedded 
systems with CONFIG_PM=y.

It seems the correct solution would be not to hijack __cpuinit
(as your patch does), but to create a new annotation.

> -Andi

cu
Adrian

BTW: Is there any good reason why your patch is x86 only?
     No matter how this gets handled, it should be an architecture 
     independent issue.

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

