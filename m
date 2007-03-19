Return-Path: <linux-kernel-owner+w=401wt.eu-S965883AbXCSPUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965883AbXCSPUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965884AbXCSPUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:20:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965883AbXCSPUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:20:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning
Date: Mon, 19 Mar 2007 16:20:00 +0100
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Trent Waddington" <trent.waddington@gmail.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
References: <200703191611.13849.jesper.juhl@gmail.com> <200703191613.04223.ak@suse.de> <9a8748490703190816w2f4bc4b5je8d5c17d232f15c9@mail.gmail.com>
In-Reply-To: <9a8748490703190816w2f4bc4b5je8d5c17d232f15c9@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200703191620.00179.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 March 2007 16:16, Jesper Juhl wrote:
> On 19/03/07, Andi Kleen <ak@suse.de> wrote:
> >
> > >
> > > -             device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
> > > +             err = device_create_file(&floppy_device[drive].dev, &dev_attr_cmos);
> > > +             if (err)
> > > +                     printk(KERN_WARNING "Unable to create sysfs attribute "
> > > +                             "file for floppy device: %s\n",
> > > +                             floppy_device[drive].name);
> >
> > That change looks pretty useless. Either the error should be handled correctly
> > by bailing out or the warn_unused_results should be dropped.
> >
> At least letting the user know that something failed is better than
> the current situation of just failing silently I'd say.

I don't think so. That's just bloat.

-Andi
