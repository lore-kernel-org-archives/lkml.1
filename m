Return-Path: <linux-kernel-owner+w=401wt.eu-S965168AbXG0XXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965168AbXG0XXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765640AbXG0XXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:23:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:41897 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761020AbXG0XXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:23:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RK4XSVDIaKNnP2zVQMIJ/9JF0Z6XCiiQTdHz83R3Cw5FoTyL+eWClgAn/0Gb6mCNbGpaAGy9tuwdfGrfVnL3WYlUk+UhzcFiR2Mfp2LfCV5/oT0V9Tf/LqND6d6HVk4IVZgMNS9B5X97oINbsC6RU+Cv7dr8gGDgz7ZQ6irWe2k=
Subject: Re: Problems with framebuffer in 2.6.22-git17
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian McMenamin <adrianmcmenamin@gmail.com>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       lethal@users.sourceforge.net
In-Reply-To: <92a12cdb0707271525i46970157ke1b2b2e6575682d6@mail.gmail.com>
References: <92a12cdb0707221141i4398d6fdxa7994c5f1f809b0a@mail.gmail.com>
	 <1185146563.6370.8.camel@daplas>
	 <8b67d60707241445l2764d9f1odb72848342135048@mail.gmail.com>
	 <1185406433.5046.23.camel@daplas>
	 <92a12cdb0707271247s727993b8i33999a9652b2ca20@mail.gmail.com>
	 <92a12cdb0707271318t141ee32bs69cb9dab22eabba2@mail.gmail.com>
	 <1185571890.26603.7.camel@daplas>
	 <92a12cdb0707271525i46970157ke1b2b2e6575682d6@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 28 Jul 2007 07:22:56 +0800
Message-Id: <1185578576.26603.16.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-27 at 23:25 +0100, Adrian McMenamin wrote:
> On 27/07/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> > On Fri, 2007-07-27 at 21:18 +0100, Adrian McMenamin wrote:
> > > On 27/07/07, Adrian McMenamin <adrianmcmenamin@gmail.com> wrote:
> > >
> > > > With the patch reverted and 24bpp, it oopses before freezing (with two
> > > > odd looking boot logos on the screen):
> > > >
> > > Tested this further and it fails on:
> > >
> > > rev = fb_readl(par->mmio_base + 0x04);
> >
> > Doubtful if this line is the point of failure, this line is executed
> > only once, on initialization.
> 
> 
> par->mmio_base is corrupted in some way during the call to
> register_framebuffer - still investigating how/why.

Possible, par->mmio_base is the last field in struct pvr2fb_par, 
after that is the pseudo_palette. The oops did not manifest when the
pseudo_palette was written as u16, but oops'ed when written as u32.
Memory alignment problems?

Try the patch I posted before, might help.

Tony 

