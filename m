Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbXGUQlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbXGUQlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 12:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbXGUQlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 12:41:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:59836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXGUQlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 12:41:44 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Date: Sat, 21 Jul 2007 18:41:39 +0200
User-Agent: KMail/1.9.6
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>, "Greg KH" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, rdunlap@xenotime.net,
       LKML <linux-kernel@vger.kernel.org>
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com> <a781481a0707210136l272fc4fauaf14afce4178d9e4@mail.gmail.com> <6bffcb0e0707210900h505f04aaq98e0f4b17139d94b@mail.gmail.com>
In-Reply-To: <6bffcb0e0707210900h505f04aaq98e0f4b17139d94b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707211841.39339.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007 18:00:52 Michal Piotrowski wrote:
> Hi Andi,
> 
> On 21/07/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> > On 7/21/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> > > Satyam Sharma pisze:
> > > > [...]
> > > > Gargh! My system obviously cannot boot without libata. Guess it's
> > > > time to go through git log and see how to fix that build breakage
> > > > myself ...
> > > >
> > > > Michal, how did you even manage to build / boot this kernel!
> > >
> > > I commented origin.patch and mm.patch in series file, reverted xfs patches,
> > > fixed libata build, deselected unionfs.
> > >
> > > Here is a patch for libata
> > >
> > > --- linux-work3-clean/drivers/ata/libata-core.c 2007-07-20 16:53:26.000000000 +0200
> > > +++ linux-work3/drivers/ata/libata-core.c       2007-07-20 17:26:30.000000000 +0200
> > > @@ -2036,7 +2036,7 @@ int ata_dev_configure(struct ata_device
> > >                 dev->max_sectors = min_t(unsigned int, ATA_MAX_SECTORS_128,
> > >                                          dev->max_sectors);
> > >
> > > -       if (ata_device_blacklisted(dev) & ATA_HORKAGE_ALPM) {
> > > +       if (ata_dev_blacklisted(dev) & ATA_HORKAGE_ALPM) {
> > >                 dev->horkage |= ATA_HORKAGE_ALPM;
> > >
> > >                 /* reset link pm_policy for this port to no pm */
> >
> >
> > And to think I went through all those hoops just to avoid *this* ... :-(
> > Anyway, please apply the attached patch and let's verify if we're both
> > actually bit by the same bug. A screenshot of my case is available at:
> >
> > http://www.cse.iitk.ac.in/users/ssatyam/mtrr.show-bug.jpg
> 
> Yep, the same bug here.
> 
> My hunt file shows me this
> 
> GOOD
> x86_64-mm-i386-string-out-of-line.patch
> BAD
> 
> Andi?


Does it still happen with the i386-string-out-of-line version from
firstfloor.org:/pub/ak/x86_64/quilt/patches/ ? 

I fixed some issues there.

-Andi

