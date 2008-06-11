Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYFKTjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYFKTjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYFKTjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:39:22 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:50041 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYFKTjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:39:21 -0400
Date: Wed, 11 Jun 2008 22:38:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] always enable FW_LOADER unless EMBEDDED=y
Message-ID: <20080611193817.GD2958@cs181133002.pp.htv.fi>
References: <20080610160408.GB11685@cs181133002.pp.htv.fi> <20080610162450.GB13538@kroah.com> <20080610181206.GF11685@cs181133002.pp.htv.fi> <20080610212859.GB26249@kroah.com> <20080611082320.GM11685@cs181133002.pp.htv.fi> <20080611182040.GA18506@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080611182040.GA18506@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 11:20:40AM -0700, Greg KH wrote:
> On Wed, Jun 11, 2008 at 11:23:20AM +0300, Adrian Bunk wrote:
> > On Tue, Jun 10, 2008 at 02:28:59PM -0700, Greg KH wrote:
> > > On Tue, Jun 10, 2008 at 09:12:06PM +0300, Adrian Bunk wrote:
> > > > On Tue, Jun 10, 2008 at 09:24:50AM -0700, Greg KH wrote:
> > > > > On Tue, Jun 10, 2008 at 07:04:08PM +0300, Adrian Bunk wrote:
> > > > > > James Bottomley recently discovered that we have 
> > > > > > {request,release}_firmware() dummies for the case of the actual 
> > > > > > functions not being available and has a fix for the bug that was 
> > > > > > actually causing build errors for built-in users with 
> > > > > > CONFIG_FW_LOADER=m.
> > > > > > 
> > > > > > But now missing selects on FW_LOADER are no longer visible at 
> > > > > > compile-time at all and can become runtime problems.
> > > > > > 
> > > > > > FW_LOADER is infrastructure with relatively small codesize we can 
> > > > > > safely enable for everyone, and only for people who really need small 
> > > > > > kernels (and can be expected to know what they are doing) it matters 
> > > > > > being able to disable it.
> > > > > > 
> > > > > > This patch therefore always sets FW_LOADER=y and allows users only to 
> > > > > > disable it with EMBEDDED=y.
> > > > > > 
> > > > > > As a bonus, we can then get rid of all "select FW_LOADER" plus the due 
> > > > > > to it required "depends on HOTPLUG" which removes some complexity from 
> > > > > > our Kconfig files.
> > > > > 
> > > > > Well, we can't get rid of that if EMBEDDED is set, right?
> > > > 
> > > > No, if EMBEDDED is set and HOTPLUG is not set you will not be able to
> > > > enable FW_LOADER (the "depends on HOTPLUG" for FW_LOADER has to stay, 
> > > > but all the options that currently select FW_LOADER no longer need the 
> > > > dependency).
> > > 
> > > Ok, but what about the point that the options that are wanting FW_LOADER
> > > in that situation?  I know EMBEDDED is tough to get right as you can
> > > shoot yourself in the foot very easily, but this seems like we are going
> > > to make it even harder to use properly.
> > 
> > Currently missing selects can result in a build error.
> > 
> > After James' patch to fix the dummy functions (that should have worked 
> > from day 1) it will instead become a runtime problem.
> 
> Ah, yes, that should be fine then.
> 
> Can you bounce me the patch again?

done

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

