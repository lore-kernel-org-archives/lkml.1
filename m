Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbXGUSL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbXGUSL2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbXGUSLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:11:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:9395 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbXGUSLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:11:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uKIfh4uh+yH+0RXlksEIL97NFu23sG9BYyZ/+kUB3SRDSnbCyt5JBNH/vtit8D+jPc3xxQd33Rjh5XqWplIQk6HKaCivCo2+LaqzE7+ILEi1onk/eU2KJKvEdO0jIr0OeaQCr42bZ1EBvwVNUKbEaPvFal9R6cQKTZOaohA9rwI=
Message-ID: <6bffcb0e0707211111g32684615k5d526be182b53cc@mail.gmail.com>
Date: Sat, 21 Jul 2007 20:11:16 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>, "Greg KH" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, rdunlap@xenotime.net,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200707211841.39339.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	 <a781481a0707210136l272fc4fauaf14afce4178d9e4@mail.gmail.com>
	 <6bffcb0e0707210900h505f04aaq98e0f4b17139d94b@mail.gmail.com>
	 <200707211841.39339.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/07, Andi Kleen <ak@suse.de> wrote:
> On Saturday 21 July 2007 18:00:52 Michal Piotrowski wrote:
> > Hi Andi,
> >
> > On 21/07/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > > On 7/21/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > > > Satyam Sharma pisze:
> > > > > [...]
> > > > > Gargh! My system obviously cannot boot without libata. Guess it's
> > > > > time to go through git log and see how to fix that build breakage
> > > > > myself ...
> > > > >
> > > > > Michal, how did you even manage to build / boot this kernel!
> > > >
> > > > I commented origin.patch and mm.patch in series file, reverted xfs patches,
> > > > fixed libata build, deselected unionfs.
> > > >
> > > > Here is a patch for libata
> > > >
> > > > --- linux-work3-clean/drivers/ata/libata-core.c 2007-07-20 16:53:26.000000000 +0200
> > > > +++ linux-work3/drivers/ata/libata-core.c       2007-07-20 17:26:30.000000000 +0200
> > > > @@ -2036,7 +2036,7 @@ int ata_dev_configure(struct ata_device
> > > >                 dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
> > > >                                          dev->max_sectors);
> > > >
> > > > -       if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
> > > > +       if (ata_dev_blacklisted(dev) & ATA_HORKAGE_ALPM) {
> > > >                 dev->horkage |= ATA_HORKAGE_ALPM;
> > > >
> > > >                 /* reset link pm_policy for this port to no pm */
> > >
> > >
> > > And to think I went through all those hoops just to avoid *this* ... :-(
> > > Anyway, please apply the attached patch and let's verify if we're both
> > > actually bit by the same bug. A screenshot of my case is available at:
> > >
> > > http://www.cse.iitk.ac.in/users/ssatyam/mtrr.show-bug.jpg
> >
> > Yep, the same bug here.
> >
> > My hunt file shows me this
> >
> > GOOD
> > x86_64-mm-i386-string-out-of-line.patch
> > BAD
> >
> > Andi?
>
>
> Does it still happen with the i386-string-out-of-line version from
> firstfloor.org:/pub/ak/x86_64/quilt/patches/ ?
>
> I fixed some issues there.

I confirm that the bug is fixed.

Yet another one:
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/00004.jpg
it looks very weird ;)

Why "Linux 2/6/22-git14 #14 SMP..." banner is displayed 5 times?

Andrew, is this a known issue?

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
