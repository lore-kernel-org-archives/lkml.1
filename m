Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbYGaQub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbYGaQub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYGaQuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:50:17 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:51147 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbYGaQuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:50:15 -0400
Date: Thu, 31 Jul 2008 19:49:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       matthew@wil.cx, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080731164918.GE20212@cs181140183.pp.htv.fi>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.969460336@free-electrons.com> <20080731135319.GA20212@cs181140183.pp.htv.fi> <20080731162007.285938e0@surf> <20080731153757.GB20212@cs181140183.pp.htv.fi> <20080731182616.4c20f0db@surf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080731182616.4c20f0db@surf>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 06:26:16PM +0200, Thomas Petazzoni wrote:
> Le Thu, 31 Jul 2008 18:37:57 +0300,
> Adrian Bunk <bunk@kernel.org> a écrit :
> 
> > I'm just not a fan of adding config options for each few kB of code - 
> > we have to maintain them and the more complex the configuration
> > becomes the more often it breaks.
> 
> I'm not a fan of these too, but are there other solutions ?

There are many things that can be done to reduce the kernel size or try 
to minimize the growth of the kernel.

E.g. working on --combine -fwhole-program (where David once had 
preliminary patches for the per-module approach) might be better.

> > What became bigger was most likely not related to the patches you
> > sent.
> 
> No, it is not.
> 
> > Where and why did the kernel become bigger?
> 
> It's not up-to-date with 2.6.26 and 2.6.27-rc1, but Bloatwatch
> <http://www.selenic.com/bloatwatch/>, by Matt Mackall, is here to
> answer these questions. I haven't made the analysis for
> 2.6.26->2.6.27-rc1.

It can only give some hints where to start searching.

But it tracks a defconfig, and e.g. the nearly doubled size between
2.6.18 and 2.6.19 is both expected and not a problem for embedded
systems.

The real work is to figure out in which areas that are relevant for 
embedded systems the kernel became bigger.

> > Why did CONFIG_FW_LOADER get enabled?
> > Due to alnoconfig disabling CONFIG_EMBEDDED?
> 
> I don't know. Haven't made the analysis for now.
> 
> > A user will ask:
> > I'm using $applications with $libraries, can I safely disable this
> > option?
> 
> Hard to tell in the general case.
> 
> > And e.g. according to a quick grep through the sources uClibc's 
> > updwtmp() seems to cease working without flock().
> 
> Correct. But on many embedded systems, we don't care about logging past
> user logins. We might even not care about logins at all.

And for embedded systems with which applications is it 100% safe to 
disable this option?

And don't answer "doesn't use flock()", I want a real-life example of a 
device where you could guarantee a developer that disabling this option 
in his product would be safe.

> > It costs us maintainance of the option and the #ifdef's and gives
> > users one way more to shoot themselves into the foot in nontrivial to
> > detect ways.
> 
> That's correct, and as I said previously, I fully understand the
> maintainance problem of all these new configuration options. I must
> admit that I do not really have more objective technical arguments that
> would help us deciding whether the code size reduction vs. code
> maintainance choice should be made in one direction or the other.

My personal criteron for this patch is still how many real-life systems 
can safely disable it.

> Sincerly,
> 
> Thomas

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

