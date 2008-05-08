Return-Path: <linux-kernel-owner+w=401wt.eu-S1761093AbYEHCZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093AbYEHCZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 22:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbYEHCZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 22:25:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275AbYEHCZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 22:25:17 -0400
Date: Wed, 7 May 2008 19:24:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: introduce a new Linux defined feature flag for PAT
 support
In-Reply-To: <4822614B.6080706@zytor.com>
Message-ID: <alpine.LFD.1.10.0805071923030.3024@woody.linux-foundation.org>
References: <48210A71.1060409@keyaccess.nl> <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com> <20080507124650.GD29935@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de> <48221AE3.6020602@keyaccess.nl>
 <482233F0.7040000@zytor.com> <48224318.8020209@keyaccess.nl> <48224361.5080102@zytor.com> <48224507.8010102@keyaccess.nl> <alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org> <48224930.9030901@keyaccess.nl> <48225DEC.2030502@keyaccess.nl>
 <alpine.LFD.1.10.0805071857430.3024@woody.linux-foundation.org> <4822614B.6080706@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, H. Peter Anvin wrote:
> 
> Indeed it wasn't, and at least I have no interest of maintaining what is in
> effect an in-kernel version of x86info(1).

Umm. We already do, since we effectively ignore what the actual hardware 
says, and replace it with our own version.

> *Certainly* I don't want anything like this crap:
> 
> > -    if (cpu_has_pat)
> > +    if (cpu_has_pat && cpu_has_pat_good)

This in fact is likely the best part of it.

Because that at least guarantees that we never say we have a good PAT when 
the hardware doesn't even report it.

As it is, we seem to just blindly override hardware. It may be correct for 
all the models we override, but still..

		Linus
