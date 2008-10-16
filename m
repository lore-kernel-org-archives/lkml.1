Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbYJPTbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbYJPTbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbYJPTbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:31:15 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39016 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYJPTbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:31:14 -0400
Date: Thu, 16 Oct 2008 22:31:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Jiri Kosina <jkosina@suse.cz>,
       zippel@linux-m68k.org, sam@ravnborg.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: select validation (was: Re: [2.6 patch] HID: fix default
	building of all quirky devices)
Message-ID: <20081016193103.GC22554@cs181140183.pp.htv.fi>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi> <20081015073011.GE20183@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz> <alpine.LFD.2.00.0810151002120.3288@nehalem.linux-foundation.org> <Pine.LNX.4.64.0810161002240.25933@anakin> <alpine.LFD.2.00.0810161133150.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810161133150.3288@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 11:47:55AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 16 Oct 2008, Geert Uytterhoeven wrote:
> > 
> > Would it be possible for kconfig to check for invalid usage of select?
> > 
> > Like you should not use select to enable something that has
> > dependencies. However, that would fail in case both the selector option
> > and the selected option depend on the same.
> 
> Well, at least in theory you may actually want to select something that 
> has dependencies, even if you don't want to select the dependencies.
> 
> For example, some feature may be enabled by default on some architecture 
> or with some config. Example:
> 
> 	bool SUPPORT_FEATURE
> 		default y
> 		depends on EXPERIMENTAL
> 		depends on !EMBEDDED
> 		depends on X86
> 
> which is just another way of saying
> 
> 	bool SUPPORT_FEATURE
> 		default X86 && !EMBEDDED && EXPERIMENTAL

Such constructs without a prompt are for a different usecase than what 
you have in mind, there wouldn't be EXPERIMENTAL or EMBEDDED in the 
dependencies, this is used for stuff like

config X86_HT
        bool
        depends on SMP
        depends on (X86_32 && !X86_VOYAGER) || X86_64
        default y

And that's usually not the kind of symbol that should get selected.


In reality your example would be:

config SUPPORT_FEATURE
        bool "support feature" if EMBEDDED
        default y
        depends on X86 && EXPERIMENTAL


> and it's still possible that some code wants to do a
> 
> 	select SUPPORT_FEATURE
> 
> because the dependency isn't a _code_ dependency, it's a default-value 
> dependency.
>...

I'd be more concerned about dependencies that are used to make the 
kconfig UI better.

Dependencies on options like NETDEV_1000 are not code dependencies.

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

