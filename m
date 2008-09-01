Return-Path: <linux-kernel-owner+w=401wt.eu-S1751895AbYIAXZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbYIAXZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbYIAXZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:25:00 -0400
Received: from www.tglx.de ([62.245.132.106]:50088 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbYIAXY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:24:59 -0400
Date: Tue, 2 Sep 2008 01:24:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809011545020.12958@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0809020117260.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011500460.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033060.3243@apollo.tec.linutronix.de>
 <alpine.LFD.1.10.0809011545020.12958@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2008, Linus Torvalds wrote:
> On Tue, 2 Sep 2008, Thomas Gleixner wrote:
> > > 
> > > Umm. Which one. The 32-bit or the 64-bit?
> > 
> > The 32 bit version.
> 
> So then the PIT isn't going to work on that machine. Do you have HPET?
> 
> Because if so, the most obvious choice would be to say:
> 
>  - on old machines, the PIT is likely more reliable than PM_TIMER
> 
>  - on new machines, the HPET is likely more reliable than PIT
> 
> and there's actually a fairly obvious place to distinguish between old and 
> new: if ti has a HPET, consider it a new one.
> 
> But that just means that there's never any reason to use PM_TIMER anyway, 
> and the proper patch would probably be to just ignore it. No?

There is a HPET timer on that machine, but it is only available by
enforcing the address via black magic because the BIOS does advertise
it on the wrong location and the newest BIOS version does not
advertise it at all.

I have not seen a single bug report against PM timer aside of those K6
area systems, but we have

- HPETs which are not advertised at all
- HPETs which are advertised at the wrong address
- HPETs which do not count at all
- HPETs which tell us bogus operating frequencies
- HPETs which have bogus interrupt routings

So why should we rely on the HPET ?

The whole ACPI code relies pretty much on PM_TIMER and as I said
before there are no PM-TIMER related bug reports aside of those
documented K6 ones, which Alok did probably not know about and I
forgot them as well. Yeah, that's my fault.

Thanks,

	tglx
