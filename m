Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZHAWGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZHAWGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 18:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZHAWGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 18:06:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbZHAWGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 18:06:51 -0400
Date: Sat, 1 Aug 2009 15:04:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
In-Reply-To: <4A7499BA.2000405@zytor.com>
Message-ID: <alpine.LFD.2.01.0908011501470.3352@localhost.localdomain>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain> <4A7499BA.2000405@zytor.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 1 Aug 2009, H. Peter Anvin wrote:
> 
> This is clearly better... now the semi-obvious question becomes if there
> is any way we can get compiler support to do better and migrate to that
> as the compiler allows.

Well, even if we had compiler support, we'd have to basically then wait 
forever to make sure everybody has a supported compiler. So I think we're 
better off not worrying too much about that - it's not going to happen any 
time in the near future.

I've now tested my patch, and it seems to result in a working kernel too. 

> In particular, if I remember right the problem with using __thread for 
> percpu was exactly that the current cpuness can change almost anywhere, 
> unless preemption is disabled.

That shouldn't matter. If it uses '%gs', it should all just work 
automatically. But if gcc does something different for thread-local, it's 
basically useless.

			Linus
