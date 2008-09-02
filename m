Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYIBVNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYIBVNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYIBVNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:13:39 -0400
Received: from www.tglx.de ([62.245.132.106]:34782 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbYIBVNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:13:37 -0400
Date: Tue, 2 Sep 2008 23:13:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809022239220.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Linus Torvalds wrote:
> 
> You're definitely right that this could easily be the _real_ problem. 
> Especially as your TSC min value of 2160 is (a) pretty close to the 
> expected time of a microsecond and (b) so stable that I actually do not 
> believe that the PIT itself is at all emulated or the problem.

On that box, the PIT is probably real hardware or a damned good
emulation. When you look at the 10 loop values you see that it does
50% perfectly fine calibration loops. The others are just SMI
interruptions caused by random unknown crap in the BIOS.
 
> Btw - as to caring about the average value: that's pointless. If you only 
> look at the average time the PIT read takes place, then it is going to 
> approximate that "pit_count" thing in the end that I already did. 
> 
> Why? Because the average value should essentially end up being "(end_tsc - 
> start_tsc) / pit_count". And if you just compare that to "min_tsc", then 
> that should always be about a microsecond (on normal machines where the 
> PIT is essentially on the old emulated internal "ISA" bus on the 
> southbridge). So you end up with what I already posted, and you already 
> dismissed.
> 
> So average TSC is not any more interesting than "pit_count". 

Yeah, you're right. Math is hard :)

Thanks,

	tglx
