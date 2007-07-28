Return-Path: <linux-kernel-owner+w=401wt.eu-S938629AbXG1Acq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938629AbXG1Acq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 20:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938070AbXG1Acj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 20:32:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:58076 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937082AbXG1Aci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 20:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YGLRR5b5e+oKDYCeGAGpj4S3ImuBX0k7ZgbL934fEUhQ/tyvic8yEEdYT2AyslDyf3X3FJdv2EAQw/Ac1Bh7mrQ3jKdJf0vV3rVxwp5FsHp8MDE6QLpSBcFnIkA58ZCPYHYcP9Jxximpz5viMIfAsLfq/72kW0DYNson67NfiGw=
Message-ID: <92a12cdb0707271732l1d61f0aajfbd72c62d7ded3b6@mail.gmail.com>
Date: Sat, 28 Jul 2007 01:32:37 +0100
From: "Adrian McMenamin" <adrianmcmenamin@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: Problems with framebuffer in 2.6.22-git17
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <1185578576.26603.16.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <1185146563.6370.8.camel@daplas>
	 <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
	 <1185406433.5046.23.camel@daplas>
	 <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
	 <92a12cdb0707271318t141ee32bs69cb9dab22eabba2@mail.gmail.com>
	 <1185571890.26603.7.camel@daplas>
	 <92a12cdb0707271525i46970157ke1b2b2e6575682d6@mail.gmail.com>
	 <1185578576.26603.16.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> On Fri, 2007-07-27 at 23:25 +0100, Adrian McMenamin wrote:
> > On 27/07/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > > On Fri, 2007-07-27 at 21:18 +0100, Adrian McMenamin wrote:
> > > > On 27/07/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
> > > >
> > > > > With the patch reverted and 24bpp, it oopses before freezing (with two
> > > > > odd looking boot logos on the screen):
> > > > >
> > > > Tested this further and it fails on:
> > > >
> > > > rev = fb_readl(par->mmio_base + 0x04);
> > >
> > > Doubtful if this line is the point of failure, this line is executed
> > > only once, on initialization.
> >
> >
> > par->mmio_base is corrupted in some way during the call to
> > register_framebuffer - still investigating how/why.
>
> Possible, par->mmio_base is the last field in struct pvr2fb_par,
> after that is the pseudo_palette. The oops did not manifest when the
> pseudo_palette was written as u16, but oops'ed when written as u32.
> Memory alignment problems?
>
> Try the patch I posted before, might help.
>
Apologies, missed the patch before.

With the patch applied the Dreamcast no longer crashes or locks with
either 16, 24 or 32 bpp, so that's good.

With 24bpp everything is doubled up (eg two boot logos on screen) and
about twice (?) the size it should be - though with a black screen.

With 32 bpp everything is about 4 (?) times the size it should be and
all on a yellow background.

With 16bpp then everything is on a blue background as before, but is
also the correct size (as before).

So, it's better certainly, but there are still a few issues with the
driver, though nothing that takes down the box.

So thanks!

Adrian
