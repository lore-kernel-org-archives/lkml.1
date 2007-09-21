Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbXIUNZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbXIUNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbXIUNZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:25:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:10372 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbXIUNZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RTYqN62nPGXuQehid27+jyWzxk1c5iqRaWO6vI/38RetQNgZ7pV+PIecL2OUULSlrfN/4DIi5dzY7M9LZZgl8PT26UVndJl8qc+WpR8TzQl2uy5yhpmjF+4f3eOtSjOvyn6HIarF3Lkx0SKNokUYtWWF0Fv3PjExA/7i+T51zNM=
Message-ID: <851fc09e0709210625l6a2d2ed9oeac921fbd5414f84@mail.gmail.com>
Date: Fri, 21 Sep 2007 21:25:13 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH 1/2 -mm] kexec based hibernation -v3: kexec jump
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Nigel Cunningham" <ncunningham@crca.org.au>, nigel@suspend2.net,
       "Pavel Machek" <pavel@ucw.cz>, "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       "Kexec Mailing List" <kexec@lists.infradead.org>,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <200709211356.30291.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1190266447.21818.17.camel@caritas-dev.intel.com>
	 <200709211120.00448.ncunningham@crca.org.au>
	 <20070920184106.79e1858a.akpm@linux-foundation.org>
	 <200709211356.30291.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi Andrew,
>
> On Friday, 21 September 2007 03:41, Andrew Morton wrote:
> > On Fri, 21 Sep 2007 11:19:59 +1000 Nigel Cunningham <ncunningham@crca.org.au> wrote:
> >
> > > Hi.
> > >
> > > On Friday 21 September 2007 11:06:23 Andrew Morton wrote:
> > > > On Fri, 21 Sep 2007 10:24:34 +1000 Nigel Cunningham
> > > <nigel@nigel.suspend2.net> wrote:
> > > >
> > > > > Hi Andrew.
> > > > >
> > > > > On Thursday 20 September 2007 20:09:41 Pavel Machek wrote:
> > > > > > Seems like good enough for -mm to me.
> > > > > >
> > > > > >                                                                       Pavel
> > > > >
> > > > > Andrew, if I recall correctly, you said a while ago that you didn't want
> > > > > another hibernation implementation in the vanilla kernel. If you're going
> > > to
> > > > > consider merging this kexec code, will you also please consider merging
> > > > > TuxOnIce?
> > > > >
> > > >
> > > > The theory is that kexec-based hibernation will mainly use preexisting
> > > > kexec code and will permit us to delete the existing hibernation
> > > > implementation.
> > > >
> > > > That's different from replacing it.
> > >
> > > TuxOnIce doesn't remove the existing implementation either. It can
> > > transparently replace it, but you can enable/disable that at compile time.
> >
> > Right.  So we end up with two implementations in-tree.  Whereas
> > kexec-based-hibernation leads us to having zero implementations in-tree.
>
> Well, I don't quite agree.
>
> For now, the kexec-based approach is missing the handling of devices, AFAICS.
> Namely, it's quite easy to snapshot memory with the help of kexec, but the
> state of devices gets trashed in the process, so you need some additional code
> saving the state of devices for you, executed before the kexec.
>
> Moreover, on ACPI systems the transition to the S4 sleep state and back to S0
> (working state) is more complicated than a system checkpointing, because we
> are supposed to take the platform firmware into consideration in that case.
> The more I think about this, the more it seems to me that it just can't be done
> on top of kexec in a reasonable fashion.  Of course, we could avoid handling
> the ACPI S4, but that would leave some people (including me ;-)) with
> semi-working hardware after the "restore".  I don't think that's generally
> acceptable in the long run.
>
> IMHO, for ACPI systems the way to go is to harden suspend to RAM (with s2ram
> in place and the graphics adapters specifications from Intel and AMD released
> we are in a good position to do that) and build the S4 transition mechanism
> on top of that.  It can be done easlily by adapting the current hibernation
> code, but not on top of kexec (I'm afraid).

Yes. ACPI is a biggest issue of kexec based hibernation now. I will
try to work on that. At least I can prove whether kexec based
hibernation is possible with ACPI.

> [Besides, the current hibernation userland interface is used by default by
> openSUSE and it's also used by quite some Debian users, so we can't drop
> it overnight and it can't be implemented in a compatible way on top of the
> kexec-based solution.]

Best Regards,
Huang Ying
