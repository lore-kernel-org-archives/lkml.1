Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbYA1LGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbYA1LGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 06:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYA1LGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 06:06:31 -0500
Received: from hs-out-0708.google.com ([64.233.178.246]:18978 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751911AbYA1LGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 06:06:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BaDhT4fwMKEoAWYbDxA4ROBowjPpPHwr2C1kttdLVshAp9BqaoHMaL6FQS8/tKAYWzy69XD9AjZEaciRnncVpzg7OFcosF4QZ8wMRjv6aUiPwYD0GcuTAibPtR+XEwS3rEUJSv4pWACgicxB+tocnYjjK7IRnXBw6SiZCw8Em7c=
Message-ID: <8bd0f97a0801280306k5dc4410eu208bc55f1975ceb8@mail.gmail.com>
Date: Mon, 28 Jan 2008 06:06:28 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [rfc] exposing MMR's of on-chip peripherals for debugging purposes
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Bryan Wu" <cooloney.lkml@gmail.com>
In-Reply-To: <1201516811.7547.46.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>
	 <1201516811.7547.46.camel@roc-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2008 5:40 AM, Bryan Wu <bryan.wu@analog.com> wrote:
> On Mon, 2008-01-28 at 05:16 -0500, Mike Frysinger wrote:
> > the trouble is that this file currently weighs in at ~1.8 megs.  this
> > is because it contains all the information for all Blackfin processors
> > we support (which currently, is about ~23 variants).  it's only going
> > to get bigger as we support more.  Bryan cringes at the thought of
> > submitting it to LKML :).  so i'm fishing around for alternatives ...
> > the code was originally developed against 2.6.21, so UIO was not a
> > possibility.  i'm still not sure if it is ... i'd have to research it
> > a bit more and play with things.
>
> The main reason I am not willing to submit this to mainline is the file
> size. It's almost the biggest file in the kernel source. And it will be
> bigger and bigger when more and more new Blackfin processors supported
> by Linux kernel.

a quick check of current git shows it is significantly larger than any other ;)

> My suggestion is:
> Or more deeper thought:
>  - we don't need all the MMR setup at the same time for debugging. for example, maybe for some developer, he/she only needs one driver MMR for debugging such as watchdog/usb/spi/i2c ....

splitting things up doesnt really address the original issue: there's
a lot of info here to be kept in the kernel

>  - How about split the debug MMR table to each drivers or processors?
>  - watchdog driver implements a debug FS interface for debugging watchdog MMR and other drivers implement their own things.

this had been mentioned before as a possibility but shot down.  you do
not want to tie the creation of these debug files to anything as the
prevents independent development of any other drivers/application that
use the same peripheral.
-mike
