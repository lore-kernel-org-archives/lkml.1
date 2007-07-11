Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbXGKUs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbXGKUs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbXGKUsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:48:20 -0400
Received: from rtr.ca ([64.26.128.89]:3803 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758156AbXGKUsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:48:19 -0400
Message-ID: <46954212.7060105@rtr.ca>
Date: Wed, 11 Jul 2007 16:48:18 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, a1426z@gawab.com,
       jeremy@goop.org, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com>	<200707111304.40504.rjw@sisk.pl>	<E1I8a6Y-0008Sm-00@dorka.pomaz.szeredi.hu>	<200707112211.23420.nigel@nigel.suspend2.net> <87644rcc7a.fsf@jbms.ath.cx>
In-Reply-To: <87644rcc7a.fsf@jbms.ath.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Maitin-Shepard wrote:
>>
> I'll certainly admit the kexec idea is vaporware currently, but it does
> differ in a significant way from freezer-based approaches, such that I
> don't think it should be referred to as just another implementation of a
> freezer.  Specifically, it doesn't require that the "old kernel" be in a
> "consistent" state to a greater extent than suspend to ram; it is the
> case that all of the devices must be quiesced or shut down to some
> extent, but doing this without races and deadlocks (and without the
> freezer) is certainly very, very similar to what needs to be done for
> suspend to ram, which will need to be solved anyway.  Unlike the
> existing hibernate approaches, however, it will not be necessary to use
> any of the driver infrastructure once switched to the "save image"
> kernel, and thus it will not matter what locks are held, for instance.

I really doubt that kexec(a special kernel) is going to solve anything here.
The new kernel will have to initialize, probe for devices, etc.
Which will take time.
Which will slow down hibernate to an unacceptable degree.
Right now, it (TuxOnIce) is *very* fast.
Adding 10 seconds or so for reprobing/resetting/reiniting devices
is not going to be useful.
And modifying all of the drivers to *not* do their usual probe sequence
sounds rather intrusive and is likely also a non-starter here.

Or is it?

Cheers
