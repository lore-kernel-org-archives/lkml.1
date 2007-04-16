Return-Path: <linux-kernel-owner+w=401wt.eu-S1030835AbXDPQSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030835AbXDPQSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030838AbXDPQSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:18:50 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:60560 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030835AbXDPQSt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:18:49 -0400
From: CIJOML <cijoml@volny.cz>
To: Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates
Date: Mon, 16 Apr 2007 18:18:26 +0200
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <1176653207.10849.5.camel@localhost> <20070416141535.GB10338@stusta.de> <462397A0.4040603@linuxtv.org>
In-Reply-To: <462397A0.4040603@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704161818.26686.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dne pondělí 16 duben 2007 17:34 Michael Krufky napsal(a):
> Adrian Bunk wrote:
> > On Sun, Apr 15, 2007 at 08:33:38PM -0400, Michael Krufky wrote:
> >> Mauro,
> >>
> >> I've been out of town for the past few days... I just got home and saw
> >> this:
> >>
> >> Mauro Carvalho Chehab wrote:
> >>>    - Fix 1/3 for bug 7819: fixed frontend hotplug issue
> >>>    - Fix 2/3 for bug 7819: demux and dvr
> >>>    - Fix 3/3 for bug 7819: fixed hotplugging for dvbnet
> >>
> >> I don't think that this is 2.6.21 material.  These patches have not yet
> >> received
> >> enough testing to be sent to mainline.
> >>
> >> I have tested them, and they seem to work for my cxusb device, but we
> >> have yet to hear test results from users of usb dvb devices that do not
> >> use the dvb-usb framework.  (ttusb, flexcop-usb, cinergyT2, for example)
> >>
> >> The bug that these patches fix has been around throughout the entire
> >> kernel history of the dvb subsystem.  The bug is not a regression -- it
> >> has always been
> >> there.  In my opinion, it is too late in 2.6.21 development to apply
> >> this change.
> >> Because these fixes are not obvious, I think we should let them get some
> >> more testing, and have them queued for 2.6.22 .
> >
> > Unless I misunderstand anything, this should fix [1].
> >
> > And this is a bug that was reported to be present in 2.6.21-rc but not
> > in 2.6.20 (and it's therefore a regression, no matter whether the
> > underlying problem was older and only exposed by some other change).
>
> Not true.  The DVB subsystem has NEVER been hot-unpluggable.  I confirm
> that the patches SEEM to be correct, but this has not yet been verified. 
> None of the authors of dvb-core gave their ACK on these changesets.
>
> The DVB hotplug issue has been around since the very beginning.  I assure
> you, that I consider this fix to be very important, and I really would love
> to see it hit mainline.  However, given the situation, it is not
> appropriate to push these in during -rc7
>
> I have doubts on CIJOML's testing method -- there is no way he could have
> unplugged the device while in use, while running 2.6.20.y and not receive
> an OOPS.  CIJOML, please see the bottom of this email for
>
> Sure, this will prevent an OOPS on some, and hopefully all devices...  but
> what if it causes a regression for those untested?
>
> Why do we have a merge window, if new changesets are going to be rushed
> into late -rc kernels without proper testing, and without the ack of a dvb
> subsystem maintainer?
>
> Are we prepared to go for another -rc and 3 or 4 weeks of testing to
> confirm that this fix doesn't cause new regressions?  I don't think so.
>
> Markus Rechberger wrote:
> > The patch has been around on the dvb mailinglist ([PATCH][RFC] DVB
> > Hotplug Fix, 5. April 2007),
>
> The patch was merged into the development repository at the same time the
> pull request was issued to Linus.  This has NOT been tested on a wide
> scale.  It should go to -mm for a while before being merged to mainline.
>
> Mauro Carvalho Chehab wrote:
> > I also explicitly warned at DVB ML that I were about to send this patch,
> > together with other fixes, asking the community for more tests. After
> > that, I received two positive answers on my mailbox from people that
> > tested and noticed that this really fixed the issue.
>
> One of those positive answers was me -  I explained that it worked for me,
> but we need others to test.
>
> You waited ONE DAY after sending this "warning" to the dvb mailing list?  (
> http://linuxtv.org/pipermail/linux-dvb/2007-April/017204.html ) I saw that
> email after seeing the pull request to Linus.  We dont have users testing
> the repositories after each commit -- you _really_ need to give some more
> time to allow for such testing.
>
> CIJOML wrote:
> > Hi,
> >
> > I have tested these patches with:
> >
> > Freecom DVB-T dongle
> > Pluto2 pcmcia card
> > Leadtek WinFast DTV dongle 1st generation
> > Leadtek WinFast DTV dongle 2nd generation
> >
> > These are 4 different devices with 4 different hw and modules.
> > All works. Please apply.
>
> Well, that helps...  But it would still be nice to hear test results on a
> CinergyT2 or flexcop-usb.
>
> Which driver supports those Winfast dongles?  We already know for sure that
> the patches work correctly for any driver based on the dvb-usb framework.
>
> If you had the device open, and then disconnect it from the usb bus, no
> matter what kernel version you're running, you should hit the OOPS.  I
> confirm that these patches prevent that OOPS from occurring, but I have
> trouble believing that you did NOT experience such an OOPS in 2.6.20.y
>
> Could you please describe the method in which your test caused an OOPS
> using 2.6.21-rc and did NOT cause an oops in 2.6.20.y ?

Hi,

I have tested these patches with 2.6.20-mh1 + v4l-dvb-b5be3479f070 patchset.
I also tried 2.6.21-rc6 + v4l-dvb-b5be3479f070 patchset and this combination 
also works without OOPS.

Winfast dongles are both dvb-usb based (DiBcom 3000M-C and DiBcom DiB7000P), 
but pluto2 is cardbus (pci) based.

I think we can include these patches into 2.6.21 and if we receive any 
problem, we still have 2.6.21.Z for fixing, don't we?

Michal
