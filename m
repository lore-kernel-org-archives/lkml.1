Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbXEBMOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbXEBMOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbXEBMOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:14:20 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:54272 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbXEBMOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=uHT3W/FbB0dbf243pvoRKxWBROwywovRPxJjpW8dtcsJ8cYYHPWKrU67YZVyLnF7d8zdgfQHvqpwJSt6OxshZQZXxHV0Ql4Zfb/Dk2mgCDLHa6AvoQSQOeaz09dJdlfHFKvY6W9KsSt0wfKnU2QOGlpUdBe+UhJvFw3Y+o4w9HY=
Message-ID: <3ae72650705020514m1e36caadtc9d64b5439b0cd03@mail.gmail.com>
Date: Wed, 2 May 2007 14:14:11 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: 2.6.21-rc7-mm2 crash: Eeek! page_mapcount(page) went negative! (-1)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Tilman Schmidt" <tilman@imap.cc>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <20070502074305.GA7761@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	 <46338AEB.2070109@imap.cc>
	 <20070428141024.887342bd.akpm@linux-foundation.org>
	 <4636248E.7030309@imap.cc>
	 <20070430112130.b64321d3.akpm@linux-foundation.org>
	 <46364346.6030407@imap.cc>
	 <20070430124638.10611058.akpm@linux-foundation.org>
	 <46383742.9050503@imap.cc>
	 <20070502001000.8460fb31.akpm@linux-foundation.org>
	 <20070502074305.GA7761@suse.de>
X-Google-Sender-Auth: 8fd062d885d0b227
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Greg KH <gregkh@suse.de> wrote:
> On Wed, May 02, 2007 at 12:10:00AM -0700, Andrew Morton wrote:
> > On Wed, 02 May 2007 09:01:22 +0200 Tilman Schmidt <tilman@imap.cc> wrote:
> >
> > > Am 30.04.2007 21:46 schrieb Andrew Morton:
> > > > Not really - everything's tangled up.  A bisection search on the
> > > > 2.6.21-rc7-mm2 driver tree would be the best bet.
> > >
> > > And the winner is:
> > >
> > > gregkh-driver-driver-core-make-uevent-environment-available-in-uevent-file.patch
> > >
> > > Reverting only that from 2.6.21-rc7-mm2 gives me a working kernel
> > > again.
> >
> > cripes.
> >
> > +static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
> > +                          char *buf)
> > +{
> > +       struct kobject *top_kobj;
> > +       struct kset *kset;
> > +       char *envp[32];
> > +       char data[PAGE_SIZE];
> >
> > That won't work too well with 4k stacks.

Yeah, sorry.

> Wait, even though this isn't good, it shouldn't have been hit by anyone,
> that file used to not be readable, so I doubt userspace would have been
> trying to read it...
>
> Tilman, what version of HAL and udev do you have on your machine?
>
> Kay, did you get the 'read the uevent file' code already into udev
> and/or HAL?

Only udevtest uses this at the moment, but that is only used for debugging.
It's probably the brain-dead libsysfs, which opens and reads every
file in /sys, even when nobody is interested in the data.

Thanks,
Kay
