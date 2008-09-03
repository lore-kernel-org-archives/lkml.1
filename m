Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbYICBuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbYICBuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 21:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYICBu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 21:50:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbYICBu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 21:50:28 -0400
Date: Tue, 2 Sep 2008 18:49:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809030055490.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809021652160.5436@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809022239220.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021446360.3160@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809030055490.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Sep 2008, Thomas Gleixner wrote:
> 
> Except for the couple of exceptions, where the readout of the old PIT
> timer is broken. See arch/x86/kernel/i8253.c:pit_read()

Well, the VIA problem, for example, is not an issue if you just make it do 
the maximum timeout (ie count down from zero), which is what you want 
_anyway_ in order to get the maximum range.

So that one is simply avoided by just programming the timer to count the 
maximum possible range.

However, the counter latching itself does seem to stop the counting until 
it is read, which is rather irritating. It means that you can't just latch 
and read in a tight loop. An while I actually have a patch that works very 
well for me, it depends on not latching, which is not strictly correct 
either.

So yeah, I suspect using the current code and trying to just see when it 
isn't reliable (and the "max time" seems good for that) is probably the 
best option.

		Linus
