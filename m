Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbYDSRt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbYDSRt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 13:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYDSRtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 13:49:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753736AbYDSRtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 13:49:21 -0400
Date: Sat, 19 Apr 2008 10:49:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, tglx@linutronix.de
Subject: Re: x86: 4kstacks default
Message-Id: <20080419104911.07d299ef.akpm@linux-foundation.org>
In-Reply-To: <20080419142329.GA5339@elte.hu>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 19 Apr 2008 16:23:29 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > >  config 4KSTACKS
> > >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > > -	depends on DEBUG_KERNEL
> > >  	depends on X86_32
> > > +	default y
> > 
> > This patch will cause kernels to crash.
> 
> what mainline kernels crash and how will they crash?

There has been a dribble of reports - I don't have the links handy, nor did
I search for them.

> Fedora and other 
> distros have had 4K stacks enabled for years:
> 
>   $ grep 4K /boot/config-2.6.24-9.fc9
>   CONFIG_4KSTACKS=y
> 
> and we've conducted tens of thousands of bootup tests with all sorts of 
> drivers and kernel options enabled and have yet to see a single crash 
> due to 4K stacks.

I doubt if you're testing things like nfsd-on-xfs-on-md-on-porky-scsi-driver.

Enable CONFIG_DEBUG_STACK_USAGE.  Monitor the results.  It's so scary that
I wonder if the feature is busted.

> So basically the kernel default just follows the 
> common distro default now. (distros and users can still disable it)

Apparently not.  I wouldn't enable it if I had a distro.

Anyway.  We should be having this sort of discussion _before_ a patch
gets merged, no?
