Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYBTWad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYBTWad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbYBTWaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:30:22 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:53321 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752267AbYBTWaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:30:19 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Joel Becker <Joel.Becker@oracle.com>,
       Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
In-Reply-To: <47BCA275.7000504@goop.org>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
	 <20080215202336.GE26034@mail.oracle.com>
	 <1203274161.27987.6.camel@localhost.localdomain>
	 <20080218104025.GA15899@ca-server1.us.oracle.com>
	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>
	 <47BBDA20.8030105@zytor.com>
	 <1203497511.26910.39.camel@cthulhu.hellion.org.uk>
	 <47BCA275.7000504@goop.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 22:29:57 +0000
Message-Id: <1203546597.26910.74.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.25-rc1 xen pvops regression
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=vyTKKrIq8eJMZDPAxyAA:9 a=ifBV1_ro28mv8PneQ68A:7 a=YJvEYv_7sqKt30IKf86WAFUoVHMA:4 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 13:58 -0800, Jeremy Fitzhardinge wrote:
> Ian Campbell wrote:
> > On Tue, 2008-02-19 at 23:43 -0800, H. Peter Anvin wrote:
> >   
> >> Ian Campbell wrote:
> >>     
> >>> On Mon, 2008-02-18 at 02:40 -0800, Joel Becker wrote:
> >>>       
> >>>> On Sun, Feb 17, 2008 at 06:49:21PM +0000, Ian Campbell wrote:
> >>>>         
> >>>>> x86/xen: Do not scan for DMI unless the DMI region is reserved by e820.
> >>>>>           
> >>>> 	This fixed it.  I'm now booting successfully.  Thank you!
> >>>>         
> >>> Excellent. Jeremy, are you happy for this to go in?
> >>>       
> 
> I had no problem with it, but Peter's objection seems substantial enough.

Definitely.

> > As far as the actual change goes I was assuming that any machine that
> > has DMI/SMBIOS would easily be new enough to have an E820 which could be
> > expected to reserve this region. Looks like I was mistaken about how
> > long E820 had been around and/or how reliably it is used to reserve the
> > tables.
> >
> > Anyway, will have to think of another solution.
> >   
> 
> Well, the way we've handled this kind of thing elsewhere is to just 
> reserve that pseudophys address space in earlish Xen init code and fill 
> it with not-DMI things (zero, I guess).  It's a bit of a waste of 
> memory, but maybe we can recover it once DMI has given up and gone 
> away.  This also makes it easy to insert faked-up DMI info if that turns 
> out to be useful.

I'll see if I can track down where the page is getting used and have a
go at getting in there first. It must be pretty early to be allocated
already when dmi_scan_machine gets called.

It's possible that the domain builder might have already allocated a PT
at this address. I haven't checked but I think currently the domain
builder always puts PT pages after the kernel so hopefully it's only a
theoretical problem.

Another option I was thinking of was a command line option to disable
DMI, which (maybe) isn't terribly useful in itself but it introduces an
associated variable to frob with. That's similar to how the TSC was
handled in the past (well, the opposite since TSC was forced on).

Ian.
-- 
Ian Campbell

Universe, n.:
	The problem.

