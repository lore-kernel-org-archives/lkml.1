Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYIFVLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYIFVLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 17:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYIFVK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 17:10:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873AbYIFVKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 17:10:55 -0400
Date: Sat, 6 Sep 2008 14:10:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Alok Kataria <akataria@vmware.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Dan Hecht <dhecht@vmware.com>,
       Garrett Smith <garrett@vmware.com>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
In-Reply-To: <alpine.LFD.1.10.0809062253030.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809061406150.3117@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org>  <20080904160036.GA18382@elte.hu>  <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041021110.3400@nehalem.linux-foundation.org> 
 <20080904190728.59634020@lxorguk.ukuu.org.uk>  <alpine.LFD.1.10.0809041114030.3400@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809041303530.4112@nehalem.linux-foundation.org>  <20080904204305.GA29065@elte.hu> <1220653095.14401.72.camel@alok-dev1>
 <alpine.LFD.1.10.0809051522410.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809061803470.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809061328400.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062233500.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809061347120.3117@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809062253030.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Sep 2008, Thomas Gleixner wrote:
>  
> Where is a guarantee, that excpect is not decremented before we break
> out of the loop ? 

Quite the reverse. We have a guarantee that it _is_ decremented.

Adn that guarantee is very much about the C language.

		for (a ; b ; c) {
			..
		}

translates as

		a;
		while (b) {
			..
	continue:
			c;
		}

And this has absolutely _nothing_ to do with any gcc oddity or anything 
else. 

The fact is, the code that Ingo added was totally bogus. The real bug was 
that he did a totally bogus "--expect" in the argument to that last call. 

Because 'c' *will* have been done after the last iteration of the loop.

			Linus
