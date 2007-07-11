Return-Path: <linux-kernel-owner+w=401wt.eu-S934383AbXGKWTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383AbXGKWTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765079AbXGKWTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:19:21 -0400
Received: from [212.12.190.144] ([212.12.190.144]:33028 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760166AbXGKWTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:19:19 -0400
From: Al Boldi <a1426z@gawab.com>
To: Mark Lord <lkml@rtr.ca>, Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation Redesign
Date: Thu, 12 Jul 2007 01:17:24 +0300
User-Agent: KMail/1.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, jeremy@goop.org,
       pavel@ucw.cz, nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <87644rcc7a.fsf@jbms.ath.cx> <46954212.7060105@rtr.ca>
In-Reply-To: <46954212.7060105@rtr.ca>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707120117.24549.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Jeremy Maitin-Shepard wrote:
> > I'll certainly admit the kexec idea is vaporware currently,

Your idea is starting to become a reality with this thread:
"[PATCH 0/2] Kexec jump: The first step to kexec base hibernation"

> > but it does
> > differ in a significant way from freezer-based approaches, such that I
> > don't think it should be referred to as just another implementation of a
> > freezer.  Specifically, it doesn't require that the "old kernel" be in a
> > "consistent" state to a greater extent than suspend to ram; it is the
> > case that all of the devices must be quiesced or shut down to some
> > extent, but doing this without races and deadlocks (and without the
> > freezer) is certainly very, very similar to what needs to be done for
> > suspend to ram, which will need to be solved anyway.  Unlike the
> > existing hibernate approaches, however, it will not be necessary to use
> > any of the driver infrastructure once switched to the "save image"
> > kernel, and thus it will not matter what locks are held, for instance.
>
> I really doubt that kexec(a special kernel) is going to solve anything
> here. The new kernel will have to initialize, probe for devices, etc.
> Which will take time.
> Which will slow down hibernate to an unacceptable degree.
> Right now, it (TuxOnIce) is *very* fast.
> Adding 10 seconds or so for reprobing/resetting/reiniting devices
> is not going to be useful.
> And modifying all of the drivers to *not* do their usual probe sequence
> sounds rather intrusive and is likely also a non-starter here.
>
> Or is it?

Well, it's definitely less intrusive than readying drivers for the freezer.  
And, it's not even necessary for a modular kernel, where you would only 
build in the drivers you need to hibernate.


Thanks!

--
Al

