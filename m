Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbYIFVIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbYIFVIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 17:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYIFVIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 17:08:09 -0400
Received: from www.tglx.de ([62.245.132.106]:34987 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbYIFVII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 17:08:08 -0400
Date: Sat, 6 Sep 2008 23:07:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809061356270.3117@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809062301520.3243@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <1220653095.14401.72.camel@alok-dev1>
 <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809062240170.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061356270.3117@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008, Linus Torvalds wrote:
> On Sat, 6 Sep 2008, Thomas Gleixner wrote:
> > 
> > If Alok has the second check in place and is actually worried about
> > that 288us impact, then we can add the following (untested), which
> > does not impact the speed of the check.
> 
> Guys, please. 
> 
> Show some _taste_.

Tell the hardware dudes who made that crap so difficult
 
> Dammit, stop adding random crap to "native_calibrate_tsc()" and make it 
> look like total and utter SHIT.
> 
> If you want to do that
> 
> 	tsc1 = tsc_read_refs(&ref1, hpet);
> 	..
> 	tsc2 = tsc_read_refs(&ref1, hpet);
> 
> around calibration and comparing it, then do it *once*. Do it over the 
> whole thing. Do it in a function of its own, instead of making this 
> horrible and unreadable mess.

Over which _whole_ thing ? You want to have the very very fast thing,
which is not reliable under all circumstances as Alok pointed out and
I merily added a sanity check around that for testing.

> This patch may be fine as a "let's check if it works" thing, but please 
> don't send out total SH*T to public lists.

Why not ? We want to figure out if it solves the problem and sending
it to public lists is the fastest way to get it tested.

> Some _tasted_ in programming, please!

What we apply finally is a totally different thing.

Thanks,

	tglx
