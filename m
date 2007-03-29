Return-Path: <linux-kernel-owner+w=401wt.eu-S1030484AbXC2RRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484AbXC2RRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030493AbXC2RRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:17:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:44197 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030463AbXC2RRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:17:32 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc5-mm2 -- ACPI problems (lid switch broken, always shows running from AC, plugging in AC hangs machine)
Date: Thu, 29 Mar 2007 13:11:09 -0400
User-Agent: KMail/1.9.5
Cc: "Miles Lane" <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
References: <a44ae5cd0703281355h13f1bd70s9eb94092bfa9c3e@mail.gmail.com> <a44ae5cd0703290100q1bb80390ke66333407bbeecfd@mail.gmail.com> <20070329011503.00c89cb8.akpm@linux-foundation.org>
In-Reply-To: <20070329011503.00c89cb8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703291311.09893.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 March 2007 04:15, Andrew Morton wrote:
> On Thu, 29 Mar 2007 01:00:45 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
> 
> > On 3/28/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Wed, 28 Mar 2007 13:55:54 -0700
> > > "Miles Lane" <miles.lane@gmail.com> wrote:
> > >
> > > > My laptop (HP dv1240us) is always showing that my laptop is plugged
> > > > into AC power, even when it is running off of the battery.  When I
> > > > plug into the AC after running on the battery, the machine immediately
> > > > locks up.  Also, the laptop lid button isn't working -- pressing it
> > > > doesn't trigger a suspend.
> > >
> > > OK, thanks.
> > >
> > > If you have time, could you please test
> > >
> > > 2.6.21-rc5 +
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/origin.patch + ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/git-acpi.patch
> > > which will allow us to eliminate any non-acpi patches.
> > 
> > Okay, I tested with those patches and got the same problems with the
> > resulting build.
> > I can't reproduce the hang on plugging in the AC with either
> > 2.6.21-rc5-mm2 or the
> > build with the patches you sent.

So it sounds like the most serious problem, the hang,
is not reproducible without the reset of the -mm tree.

> > The other problems are 100% reproducible. 
> > I have some new details:
> > 
> > 1.  Power always shows up as plugged in to AC.
> > 2.  The lid button is non-operational for initiating a suspend.
> > 3.  Suspending from the Gnome shutdown menu works.   Afterwards, the
> > lid button works for resuming from suspend.
> > 4.  If I suspend, resume and then try to shutdown; when I see the
> > message "The machine will now halt" the power does not shut off.  That
> > is, the various buttons on my laptop stay lit up.  I am forced to
> > shutdown by holding down the power button for five seconds.
> > 
> 
> Thanks.  So we can conclude that all these problems are due to changes in
> 2.6.21-rc5-mm2's git-acpi.patch?

Miles,

Please apply the latest acpi patch directly on top of Linus' tree.
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/test/2.6.21/acpi-test-20070126-2.6.21-rc5.diff.gz
If Andrew and I are in sync, you should get the same issues above as above -- no hang,
but still problems 1-4.

Then revert that patch and edit it to delete all changes to ec.c
and apply it again.  ie. keep drivers/acpi/ec.c from Linus's tree and re-test.
If the symptoms 1-4 go away, then we've isolated the regression to the changes to ec.c.

Also, it might be helpful to open up a bug report here:
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
and attach to it the output from acpidump

thanks,
-Len
