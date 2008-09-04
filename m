Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbYIDEAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbYIDEAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 00:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYIDD7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 23:59:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754062AbYIDD7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 23:59:49 -0400
Date: Wed, 3 Sep 2008 20:59:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Alok Kataria <akataria@vmware.com>, Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Fix TSC calibration issues
In-Reply-To: <20080903201602.2ab6c449@infradead.org>
Message-ID: <alpine.LFD.1.10.0809032041130.3515@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de> <1220490884.22734.83.camel@alok-dev1> <alpine.LFD.1.10.0809031817430.3515@nehalem.linux-foundation.org> <20080903201602.2ab6c449@infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Sep 2008, Arjan van de Ven wrote:
> 
> but at some point, even doing things in parallel/asynchronous isn't
> helping, "parallel shit is still shit" :)

Well, the thing is, you can't call ti "shit" when the fact is that we 
don't have any other options than to wait.

The only frequency we can trust on 99% of all machines is the PIT, and 
it's a very uncomfortable programming model due to all the history (it is 
one of the few truly 8-bit things left in a modern PC). The other options 
are just not reliably there, or are known to not have a stable frequency.

So how would you suggest we do it? Lowering the wait to 5ms (times 5, so 
it's really 25ms, although we can probably stop early if the first 
iterations are very consistent) will work, but it _will_ reduce precision. 
And it's still real time.

But we simply don't have alternatives. That 'shit' is originally from the 
company you work for, btw, and while it was good for its time, the 
replacement (HPET) was horribly misdesigned by the same company, and is 
deficient in many ways (not the least of which is the idiotic enumeration: 
another ACPI braindamage), and it often isn't even exposed.

As a result, the PIT remains to this day the most reliable source of a 
reference timer. That includes even on really modern machines (ie the one 
I have from Intel that contains hardware not even released yet!).

			Linus
