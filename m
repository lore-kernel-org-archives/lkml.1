Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYEHAQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYEHAQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 20:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYEHAQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 20:16:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbYEHAQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 20:16:43 -0400
Date: Wed, 7 May 2008 17:15:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: 2.6.26, PAT and AMD family 6
In-Reply-To: <48224361.5080102@zytor.com>
Message-ID: <alpine.LFD.1.10.0805071707150.3024@woody.linux-foundation.org>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl>
 <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, H. Peter Anvin wrote:
> > 
> > What a lovely way of syncing reality with your definitions. The kernel
> > _does_ see that my CPU features PAT, it just refuses to use it because
> > it doesn't trust it enough. Vital difference. Maybe not to the kernel,
> > but definitely to me, the user. /proc/cpuinfo is a user interface.
> > 
> 
> No, /proc/cpuinfo is informing the user about the kernel's view of the CPU.
> It has always been the "cooked" view of CPUID, whether or not you like it.

Indeed. If people want to know what the CPU itself reports, they should 
just use the "cpuid" instruction directly. The /proc/cpuinfo file has 
been a window into the kernels notion of what is going on, and disabling 
kernel features have disabled the bits in that file as appropriate (eg 
"clearcpuid=xyzzy" and "mem=nopentium" etc).

Of course, the *common* case is that the two will match 100% in features. 
But the kernel view has some of its very own set of CPU features too.

And it is possible that the "PAT as the kernel sees it" should be a 
*separate* bit from "PAT as the cpu itself reports to support it". We do 
that for quite a lot of the "synthesized" features, eg there is the "TSC" 
feature as the CPU reports it, and then we have the "CONSTANT_TSC" feature 
that is the kernel version of it that says that we have a TSC _and_ it 
runs at a constant rate too (or the "UP" bit, or the "Mfence synchronizes 
RDTSC" bit etc etc).

So it's possible that we should do the same thing for PAT - and allow 
people to see the CPU view _and_ the kernel view as two separate issues. 
In many ways that would be the logical thing to do. Hmm?

		Linus
