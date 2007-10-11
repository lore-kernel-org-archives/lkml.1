Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbXJKJuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbXJKJuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 05:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbXJKJub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 05:50:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:15929 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbXJKJu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E8GM8lT5YqfaooH22LSm5kyulcgc5hitp9jVPDY6vlppXecPt/SNGw0zLLP2adu6ncLqdgNVFPsEkn0HjZAioz6RmuMR0xlbTkahQ66+yQMcemcdPTanI85uX4W+e4RkzI6WQ8yghBFhA/WRgzrTAeOriRVVe7c7A1P/lGAnw2A=
Message-ID: <c8b4dbe10710110250w10ddfc0du6ae4b6bb95cb2d2f@mail.gmail.com>
Date: Thu, 11 Oct 2007 10:50:28 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Cc: "Chuck Ebbert" <cebbert@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <d9def9db0710102159q2e5f9dadr341b409285f262e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192053794.15601.47.camel@gaivota>
	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
	 <d9def9db0710101624t5e0a3523p12c367dc1d414349@mail.gmail.com>
	 <470D61CF.3070307@redhat.com>
	 <d9def9db0710102159q2e5f9dadr341b409285f262e0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> On 10/11/07, Chuck Ebbert <cebbert@redhat.com> wrote:
> > On 10/10/2007 07:24 PM, Markus Rechberger wrote:
> > >
> > > To point to more changes within the available driver which hasn't been
> > merged
> > > within the last 1 1/2 years:
> > > * it supports non usbaudio based video devices.
> > > * has support for dvb-t/atsc
> > > * allows multiple device node access in case of analogue TV
> > > * has teletext/VBI support for PAL.
> > > * it supports modules which are now in userspace instead of
> > > kernelspace due disagreements with some developers for 1 1/2 years.
> > > * I do not agree with certain developers who do not have any experience
> > > with certain parts of the code for redoing it a 4th time now. My patience
> > > is over, which includes the company support in my back to get those
> > > devices supported.
> > >
> >
> > Do you plan on maintaining your own private driver tree for all of eternity?
> >
>
> I plan to tidy it up for inclusion and put everything together to get
> it work properly.
> The code which is in the kernel is around 5 % done, the code which is
> available on mcentral.de is around 50% done. It still requires some
> work to get _all_ devices supported, and keeping the development
> process in an endless loop and depending on people who have no idea
> and don't care about certain requirements is no option.
> The upcoming devices which use other chips and which have more
> features will at least also use those drivers. I expect that it will
> pump up the driver to support more than 100 devices within the next
> year.

I looked at this recently, and I'm not sure the core em28xx code was
really that different (at least, pre-userspace). Most of the core
changes seemed to be related to Markus' driver having (semi-working)
VBI support. I haven't tried this recently; I disabled it a while back
because it had a bug that caused a kernel panic half the time when
attempting to record something with MythTV.

The in-kernel driver looks mostly sound, though I can't test it
myself. (One other interesting thing that was added in Markus' driver
is various v4l1 ioctls, which may be useful to some people.)

Incidentally, I notice you appear to be developing userspace drivers
for the tvp5150 and zl10353. Is that really necessary?

> * I do not agree with certain developers who do not have any experience
> with certain parts of the code for redoing it a 4th time now. My patience
> is over, which includes the company support in my back to get those
> devices supported.

Are you threatening to deliberately sabotage company support for these
devices by v4l/linuxtv in favour of your userspace drivers?

Also, I'm not sure reworking the non-userspace version of the code to
a mergable state is actually that hard. (I'm cleaning up bits of it in
my spare time, because I may have to port it to newer kernels myself
in the future and it's annoying to work with as-is.) Eliminating the
need for changes to the core v4l/dvb code appears to be the easy bit;
the main difficulty is finding and fixing the unexpected breakages due
to the interesting coupling between bits of the code. (The other
difficulty is keeping track of whether analog or digital firmware is
currently loaded in the xc3028 in hybrid devices; I'm using an iffy
solution, but I think better ones exist.) As I recall, the changes to
core code were the major roadblock in the way of merging.

Aidan
