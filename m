Return-Path: <linux-kernel-owner+w=401wt.eu-S1754269AbYICJL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbYICJL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 05:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbYICJLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 05:11:50 -0400
Received: from www.tglx.de ([62.245.132.106]:58823 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYICJLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 05:11:49 -0400
Date: Wed, 3 Sep 2008 11:11:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] Fix TSC calibration issues
In-Reply-To: <alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Linus Torvalds wrote:
> This is "wrongish".
> 
> You really should do the
> 
> 	tsc1 = tsc_read_refs(&pm1, hpet ? &hpet1 : NULL);   
> 	...
> 	tsc2 = tsc_read_refs(&pm2, hpet ? &hpet2 : NULL);
> 
> around the whole loop, because they get more exact with more time inside, 
> and they don't improve from looping around.

True. Just kept them at the place where my debug patches had left them.
 
> Also, that code is already _too_ unreadable. How about starting by just 
> moving the PIT calibration into a function of its own, like the appended 
> patch. And then as a separate patch, improving the heuristics for just the 
> PIT calibration.

Yeah, should have done that. But I was too tired to touch anything in
the code more complex than adding a few comments.
 
Thanks,

	tglx
