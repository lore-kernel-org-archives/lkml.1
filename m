Return-Path: <linux-kernel-owner+w=401wt.eu-S1752378AbZA1ATm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbZA1ATm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZA1ATe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:19:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbZA1ATd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:19:33 -0500
Date: Tue, 27 Jan 2009 16:19:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
In-Reply-To: <497FA2F5.2040806@zytor.com>
Message-ID: <alpine.LFD.2.00.0901271616130.3123@localhost.localdomain>
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <497F9740.4000505@zytor.com> <alpine.LFD.2.00.0901271527340.3123@localhost.localdomain> <497FA2F5.2040806@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Jan 2009, H. Peter Anvin wrote:

> Linus Torvalds wrote:
> > 
> > Do you think the "fix headers_check" patches spend lots of time analyzing
> > things? I bet no. They just try to make the warning go away, so you don't
> > actually end up with any more "coverage" anyway. Quite the reverse - instead
> > of having a simple rule ("CONFIG_xyz options simply do not exist in user
> > space"), you end up having ad-hoc hacks on a per-fix basis.
> > 
> 
> This is probably true.  I think we should add this as one more of the
> preprocessing rules which we really should just do, as well as automatic
> mangling of integer types.

Btw, the really scary thing is that I bet there are programs out there 
that "know" about kernel internals, and do things like

	#define CONFIG_SMP 1
	#define __KERNEL__ 1
	#include <asm/atomic.h>

in order to get the atomic helpers from the kernel, and using CONFIG_xyz 
markers to force the exact version they want.

And we will inevitably always end up breaking stuff like that. Nothing we 
can do about it - in the end, users can do infinitely odd things and know 
about our internals, and whatever changes we do will occasionally break 
some of the more incestuous code.

			Linus
