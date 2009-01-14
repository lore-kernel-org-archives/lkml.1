Return-Path: <linux-kernel-owner+w=401wt.eu-S1759094AbZANVHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094AbZANVHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbZANVHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:07:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054AbZANVHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:07:30 -0500
Date: Wed, 14 Jan 2009 13:06:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
       andi@firstfloor.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
       pmorreale@novell.com, SDietrich@novell.com, dmitry.adamushko@gmail.com,
       hannes@cmpxchg.org
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-Id: <20090114130642.cf2b18b2.akpm@linux-foundation.org>
In-Reply-To: <20090114205122.GC6519@elte.hu>
References: <1231864854.7141.8.camel@twins>
	<alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	<1231867314.7141.16.camel@twins>
	<1231952436.14825.28.camel@laptop>
	<20090114183319.GA18630@elte.hu>
	<20090114105300.66bd014d.akpm@linux-foundation.org>
	<20090114190008.GA13203@elte.hu>
	<20090114113638.c818fcf8.akpm@linux-foundation.org>
	<20090114201435.GA6519@elte.hu>
	<20090114123017.9acf42d7.akpm@linux-foundation.org>
	<20090114205122.GC6519@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 21:51:22 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > > Do people enable CONFIG_SCHED_DEBUG?
> > > 
> > > If they suspect performance problems and want to analyze them?
> > 
> > The vast majority of users do not and usually cannot compile their own 
> > kernels.
> 
> ... which they derive from distro kernels or some old .config they always 
> used, via 'make oldconfig'. You are arguing against well-established facts 
> here.
> 
> If you dont believe my word for it, here's an analysis of all kernel 
> configs posted to lkml in the past 8 months:
> 
>    $ grep ^CONFIG_SCHED_DEBUG linux-kernel | wc -l
>    424
> 
>    $ grep 'CONFIG_SCHED_DEBUG is not' linux-kernel | wc -l
>    109
> 
> i.e. CONFIG_SCHED_DEBUG=y is set in 80% of the configs. A large majority 
> of testers has it enabled and /sys/debug/sched_features was always a good 
> mechanism that we used for runtime toggles.

You just disproved your own case :(

> > > Note that CONFIG_SCHED_DEBUG=y is also the default.
> > 
> > akpm:/usr/src/25> echo $ARCH
> > x86_64
> > akpm:/usr/src/25> make defconfig
> > *** Default configuration is based on 'x86_64_defconfig'
> 
> x86 defconfig is used too, but it's a pretty rare usage.
> 
> Under default i mean the customary meaning of default config: it's the 
> default if you come via 'make oldconfig' or if you derive your config from 
> a distro config:
> 
> | config SCHED_DEBUG
> |        bool "Collect scheduler debugging info"
> |        depends on DEBUG_KERNEL && PROC_FS
> |        default y
> 

This simply isn't reliable.
