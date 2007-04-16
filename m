Return-Path: <linux-kernel-owner+w=401wt.eu-S1030837AbXDPQQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030837AbXDPQQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030835AbXDPQQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:16:58 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:17978 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030837AbXDPQQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HHV/1KSY4mTta/ZZxfMtPpUdynWhF79bxKq8MsG+njY0//ADmVnoUvvJyzu967ESXQxnHWv+o64aHUAmSCLht9DoUypGLOP32lxyOzbNU6FTU1esRwzmcIwf7df+Klk+PwTLVAODfJRNhmv3aA3K9IWg6WHP4FNWwRLEMg/Fz24=
Message-ID: <d9def9db0704160916y16f43c02l350e1687b2e5d8f@mail.gmail.com>
Date: Mon, 16 Apr 2007 18:16:54 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB updates
Cc: "Adrian Bunk" <bunk@stusta.de>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org, CIJOML <cijoml@volny.cz>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, daniel@qanu.de,
       holger@qanu.de
In-Reply-To: <462397A0.4040603@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176653207.10849.5.camel@localhost> <4622C462.8020505@linuxtv.org>
	 <20070416141535.GB10338@stusta.de> <462397A0.4040603@linuxtv.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Michael Krufky <mkrufky@linuxtv.org> wrote:
> Adrian Bunk wrote:
> > On Sun, Apr 15, 2007 at 08:33:38PM -0400, Michael Krufky wrote:
> >> Mauro,
> >>
> >> I've been out of town for the past few days... I just got home and saw
> this:
> >>
> >>
> >> Mauro Carvalho Chehab wrote:
> >>>    - Fix 1/3 for bug 7819: fixed frontend hotplug issue
> >>>    - Fix 2/3 for bug 7819: demux and dvr
> >>>    - Fix 3/3 for bug 7819: fixed hotplugging for dvbnet
> >> I don't think that this is 2.6.21 material.  These patches have not yet
> >> received
> >> enough testing to be sent to mainline.
> >>
> >> I have tested them, and they seem to work for my cxusb device, but we
> have
> >> yet to hear test results from users of usb dvb devices that do not use
> the
> >> dvb-usb framework.  (ttusb, flexcop-usb, cinergyT2, for example)
> >>
> >> The bug that these patches fix has been around throughout the entire
> kernel
> >> history of the dvb subsystem.  The bug is not a regression -- it has
> >> always been
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
> Not true.  The DVB subsystem has NEVER been hot-unpluggable.  I confirm that
> the
> patches SEEM to be correct, but this has not yet been verified.  None of the
> authors of dvb-core gave their ACK on these changesets.
>
> The DVB hotplug issue has been around since the very beginning.  I assure
> you,
> that I consider this fix to be very important, and I really would love to
> see it
> hit mainline.  However, given the situation, it is not appropriate to push
> these
> in during -rc7
>
> I have doubts on CIJOML's testing method -- there is no way he could have
> unplugged the device while in use, while running 2.6.20.y and not receive an
> OOPS.  CIJOML, please see the bottom of this email for
>
> Sure, this will prevent an OOPS on some, and hopefully all devices...  but
> what
> if it causes a regression for those untested?
>
> Why do we have a merge window, if new changesets are going to be rushed into
> late -rc kernels without proper testing, and without the ack of a dvb
> subsystem
> maintainer?
>
> Are we prepared to go for another -rc and 3 or 4 weeks of testing to confirm
> that this fix doesn't cause new regressions?  I don't think so.
>

The problem I see with the cinergyT2 is that this driver reimplements
the frontend code and doesn't even use the dvb-core template, so a
proper fix would also be to reimplement that fix in the cinergyT2
device.
I don't think Daniel Mack or Holger Waechtler manage this driver
anymore because they didn't comment the last few fixes that were
applied to that driver (though I put them into CC here) As far as I
remember someone wrote that they didn't want to use the dvb_frontend
code back then for any reason.

So the only driver I'd take into account would be the flexcop driver.

Currently tested drivers are: dvb-usb based devices, and em28xx/em2880
based devices

Markus

>
> Markus Rechberger wrote:
> > The patch has been around on the dvb mailinglist ([PATCH][RFC] DVB
> > Hotplug Fix, 5. April 2007),
>
> The patch was merged into the development repository at the same time the
> pull
> request was issued to Linus.  This has NOT been tested on a wide scale.  It
> should go to -mm for a while before being merged to mainline.
>
> Mauro Carvalho Chehab wrote:
> > I also explicitly warned at DVB ML that I were about to send this patch,
> > together with other fixes, asking the community for more tests. After
> > that, I received two positive answers on my mailbox from people that
> > tested and noticed that this really fixed the issue.
>
> One of those positive answers was me -  I explained that it worked for me,
> but
> we need others to test.
>
> You waited ONE DAY after sending this "warning" to the dvb mailing list?  (
> http://linuxtv.org/pipermail/linux-dvb/2007-April/017204.html ) I saw that
> email
> after seeing the pull request to Linus.  We dont have users testing the
> repositories after each commit -- you _really_ need to give some more time
> to
> allow for such testing.
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
> the
> patches work correctly for any driver based on the dvb-usb framework.
>
> If you had the device open, and then disconnect it from the usb bus, no
> matter
> what kernel version you're running, you should hit the OOPS.  I confirm that
> these patches prevent that OOPS from occurring, but I have trouble believing
> that you did NOT experience such an OOPS in 2.6.20.y
>
> Could you please describe the method in which your test caused an OOPS using
> 2.6.21-rc and did NOT cause an oops in 2.6.20.y ?
>
> --
> Michael Krufky
>
>
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
>


-- 
Markus Rechberger
