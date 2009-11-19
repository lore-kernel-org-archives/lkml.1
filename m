Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZKSQZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZKSQZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 11:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756740AbZKSQZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 11:25:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33213 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756651AbZKSQZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 11:25:41 -0500
Date: Thu, 19 Nov 2009 16:27:38 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 4/5] pata: Update experimental tags
Message-ID: <20091119162738.7e8e5665@lxorguk.ukuu.org.uk>
In-Reply-To: <200911191645.29885.bzolnier@gmail.com>
References: <20091117144450.15430.83450.stgit@localhost.localdomain>
	<200911191550.25476.bzolnier@gmail.com>
	<20091119152245.479dc38d@lxorguk.ukuu.org.uk>
	<200911191645.29885.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > already have a buggy cable detection (since ->pre_reset ignores the mandatory
> > 
> > Wrong.
> 
> You cannot know it unless you know how chip operates internally.  That's it.

Read the code. How the chip operates is irrelevant.

> You are taking chances that the controller does what most of similar hardware
> do.  Unfortunately we have seen so many counterexamples of this in the past
> (i.e. I wouldn't be so surprised if some hosts just snoop IDENTIFY data to get
> their cable info) that I prefer to stick to safe approaches.

I would be very suprised indeed because neither IDE stack nor the
reference drivers would work in that case.

Even then switch to cable_detect would make no difference. Read the code.

> > Have a free hint. If the host detects the cable type then we don't ask
> > the drive. See the standard if you don't understand why. Even if we
> > didn't the code would still be correct because we properly evaluate
> > the speed configuration from all the data sources.
> 
> Please spare your 'free hints' and preaching tone.

If you don't know or follow the standards you'll get bugs. Thats why I
went to so much trouble researching and digging out the rules on cable
detect in detail, and fixing them in libata so that unlike the old IDE
stack they got them right (and more stuff probes correctly). (And Davem -
those did partly - drive ordering at least get pushed into old IDE too)

The reason it doesn't matter beyond style is this. Libata doesn't mangle
drive and host cable state into one thing. The ap->cbl field reflects the
cable type as measured by the controller. The forty wire decision is made
later on a combination of both controller and drive information, trusting
the controller first because the controller is the correct source if it
knows the information (as per the spec). [1]

Thus all the rubbish you spouted earlier doesn't matter at all. The
cable_detect logic was very carefully added so it didn't break back
compatibility with old drivers or re-order stuff wrongly.

For the other stuf "Talk to the maintainer" to quote yourself. I've
been working on other things for the past couple of years.

Alan
[1] The one specific exception here is the SATA cable setting when a
drive reports that it is SATA. There isn't an obvious way to de-uglify
that aspect of it.
