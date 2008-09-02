Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYIBRDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYIBRDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 13:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYIBRDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 13:03:07 -0400
Received: from main.gmane.org ([80.91.229.2]:50727 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYIBRDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 13:03:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
Date: Tue, 02 Sep 2008 13:17:34 -0400
Message-ID: <48BD752E.2000402@tmr.com>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
X-Gmane-NNTP-Posting-Host: pool-71-245-142-197.albyny.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 2 Sep 2008, Thomas Gleixner wrote:
>> We had the same problem versus the local APIC timer calibration, which
>> had basically the same algorithm as the TSC one and we changed it to
>> look at the PMTimer as well in the days where we debugged the initial
>> wreckage caused by the nohz/highres changes.
> 
> Hmm.
> 
> So then how would you discover when it's reliable and when it's not? Just 
> hardcode it for certain machines?

Looking at values for old K6 machines, I would suspect that doing the 
test three times and checking the deviation would be enough. If the 
timer is emulated the value will jump around and if it is stable it 
could be used. Considering that this is one use code you could increase 
the number of trials to five or so, keeping the high and low. If 
changing values are part of the problem, make them part of the solution.
> 
> One alternative might be to do the same "detect if it's SMM code by seeing 
> how long the read takes" for the PIT reads themselves. Right now the code 
> does it for the HPET timer read and for the PM_TIMER reads, but _not_ for 
> the PIT status register reads.
> 
>> How do you prevent the SMM brain damage, when it hits 3 times in a row ? 
> 
> Well, the biggest problem is actually _detection_.
> 
> We have three different timers, and they all have their own problems. How 
> do you reliably detect which one to use? The PM_TIMER clearly is _not_ 
> always the answer here, but the code just assumes it is!
> 
> 			Linus


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

