Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYIFUzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYIFUzg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYIFUz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:55:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600AbYIFUz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:55:27 -0400
Date: Sat, 6 Sep 2008 13:55:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809061347120.3117@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809061351170.3117@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <20080904205236.GA3864@elte.hu> 
 <alpine.LFD.1.10.0809041403450.3117@nehalem.linux-foundation.org>  <20080904213350.GA15678@elte.hu> <1220653095.14401.72.camel@alok-dev1> <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061347120.3117@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Sep 2008, Linus Torvalds wrote:

> 
> 
> On Sat, 6 Sep 2008, Thomas Gleixner wrote:
> > 
> > Just checked. The -tip version still has the expect-- in the for()
> > which might lead to stupid results depending on the gcc madness level.
> 
> Umm. What? You're on some odd drugs.

Oh, you mean te "--expect" in the last pit_expect_msb(). Yeah, that one 
looks bogus, but I don't understand what it has to do with gcc at all.

"expect" is an unsigned char. There are absolutely _zero_ issues with 
overflow, underflow, random phases of the moon, madness levels or anything 
else. But yes, it does look like Ingo screwed up when adding that final 
check, since expect was already decremented at the end of the loop.

Ingo? Did you actually test it?

		Linus
