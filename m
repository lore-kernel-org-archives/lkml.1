Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbYA1NKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbYA1NKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 08:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbYA1NK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 08:10:27 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:24106 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYA1NKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:10:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jLEe+HoNwLP2pF4+27Zcgp5b30bWihU1p5eAHAJjGHEBoBWCUyLeJGpwEoUn7Pa7XXOuC64BMqOFmJpptqq94nggaKRKyJjYee3UaqGldmX0IYcKjB7F+/k+qJQapsDpjyWC6sA3XQQ2/7KLWsXRVWi64B+L35B2jKM3l7eARqQ=
Message-ID: <8bd0f97a0801280510q42dbf5d3i947877b7e3454fe1@mail.gmail.com>
Date: Mon, 28 Jan 2008 08:10:24 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "richard kennedy" <richard@rsk.demon.co.uk>
Subject: Re: [rfc] exposing MMR's of on-chip peripherals for debugging purposes
Cc: bryan.wu@analog.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Bryan Wu" <cooloney.lkml@gmail.com>
In-Reply-To: <479DD2F3.6020209@rsk.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>
	 <1201516811.7547.46.camel@roc-laptop>
	 <8bd0f97a0801280306k5dc4410eu208bc55f1975ceb8@mail.gmail.com>
	 <479DD2F3.6020209@rsk.demon.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2008 8:04 AM, richard kennedy <richard@rsk.demon.co.uk> wrote:
> Mike Frysinger wrote:
> > On Jan 28, 2008 5:40 AM, Bryan Wu <bryan.wu@analog.com> wrote:
> >> On Mon, 2008-01-28 at 05:16 -0500, Mike Frysinger wrote:
> >>> the trouble is that this file currently weighs in at ~1.8 megs.  this
> >>> is because it contains all the information for all Blackfin processors
> >>> we support (which currently, is about ~23 variants).  it's only going
> >>> to get bigger as we support more.  Bryan cringes at the thought of
> >>> submitting it to LKML :).  so i'm fishing around for alternatives ...
> >>> the code was originally developed against 2.6.21, so UIO was not a
> >>> possibility.  i'm still not sure if it is ... i'd have to research it
> >>> a bit more and play with things.
> >> The main reason I am not willing to submit this to mainline is the file
> >> size. It's almost the biggest file in the kernel source. And it will be
> >> bigger and bigger when more and more new Blackfin processors supported
> >> by Linux kernel.
> >
> > a quick check of current git shows it is significantly larger than any other ;)
> >
> >> My suggestion is:
> >> Or more deeper thought:
> >>  - we don't need all the MMR setup at the same time for debugging. for example, maybe for some developer, he/she only needs one driver MMR for debugging such as watchdog/usb/spi/i2c ....
> >
> > splitting things up doesnt really address the original issue: there's
> > a lot of info here to be kept in the kernel
> >
> >>  - How about split the debug MMR table to each drivers or processors?
> >>  - watchdog driver implements a debug FS interface for debugging watchdog MMR and other drivers implement their own things.
> >
> > this had been mentioned before as a possibility but shot down.  you do
> > not want to tie the creation of these debug files to anything as the
> > prevents independent development of any other drivers/application that
> > use the same peripheral.
>
> there is a lot of duplication in your file, but you could slim it down a
> bit if thats the only objection.

i imagine there's a ton of duplication ... the file is auto-generated
from XML files, so i could take a look at the autogeneration producing
unified code.

> so you could have a simple function to create all the COUNTER elements
> from a given base address, then each variant only needs call that saving
> you lots of LOC.

also a possibility ... just have to be wary of the parts that have
slightly different peripherals (like the UART).
-mike
