Return-Path: <linux-kernel-owner+w=401wt.eu-S1760403AbYCZQ4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760403AbYCZQ4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbYCZQ4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:56:00 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:38259 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbYCZQ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:56:00 -0400
Date: Wed, 26 Mar 2008 18:55:54 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Modify Kconfig to allow up to 4096 cpus
Message-ID: <20080326165554.GD1789@cs181133002.pp.htv.fi>
References: <20080326014137.934171000@polaris-admin.engr.sgi.com> <20080326014138.292294000@polaris-admin.engr.sgi.com> <20080326160924.GC1789@cs181133002.pp.htv.fi> <47EA7A5A.5030207@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47EA7A5A.5030207@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 09:31:22AM -0700, Mike Travis wrote:
> Adrian Bunk wrote:
> > On Tue, Mar 25, 2008 at 06:41:39PM -0700, Mike Travis wrote:
> >> Increase the limit of NR_CPUS to 4096 and introduce a boolean
> >> called "MAXSMP" which when set (e.g. "allyesconfig"), will set
> >> NR_CPUS = 4096 and NODES_SHIFT = 9 (512).
> > 
> > 
> > I'm not really getting the point of MAXSMP - people should simply pick 
> > their values, and when they want the maximum "(2-4096)" and "(1-15)" 
> > already provide this information (except that your patch hides the 
> > latter information from the user).
> > 
> > And with your patch, even with MAXSMP=y people could still set 
> > NR_CPUS=7 and NODES_SHIFT=15 or whatever else they want...
> > 
> > More interesting would be why you want it to set NODES_SHIFT to 
> > something less than the maximum value of 15. I'm getting the fact that
> > 2^15 > 4096 and that 15 might be nonsensical high, but this sounds more 
> > like requiring a patch to limit the range to 9?
> 
> I guess the main effect is that "MAXSMP" represents what's really
> usable for an architecture based on other factors.  The limit of
> NODES_SHIFT = 15 is that it's represented in some places as a signed
> 16-bit value, so 15 is the hard limit without coding changes, not
> an architecture limit.


This is the x86-specific Kconfig file that presents the x86 specific 
limits to the users.

If NODES_SHIFT=15 is offered to the user although it's higher than the 
current architecture limit on x86 then this is simply a bug that should 
be fixed.


> Thanks,
> Mike

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

