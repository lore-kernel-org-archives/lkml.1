Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYA1Kk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYA1Kk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYA1KkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:40:15 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:20325 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYA1KkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:40:13 -0500
X-IronPort-AV: E=Sophos;i="4.25,258,1199682000"; 
   d="scan'208";a="61042902"
Subject: Re: [rfc] exposing MMR's of on-chip peripherals for debugging
	purposes
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <cooloney.lkml@gmail.com>
In-Reply-To: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>
References: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 28 Jan 2008 18:40:11 +0800
Message-Id: <1201516811.7547.46.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 28 Jan 2008 10:40:11.0809 (UTC) FILETIME=[28D6E910:01C8619A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-28 at 05:16 -0500, Mike Frysinger wrote:
> we have guys who maintain xml descriptions of all Blackfin processors.
>  these include an exhaustive list of all the peripherals and their
> MMRs.  for example, there is an element that binds the address, the
> MMR name (as described in the processor's hardware manual), the bit
> size of it, and all those fun details.  i feed these xml files through
> an xsl to generate a C file that populates /sys/kernel/debug/blackfin/
> by using the standard debugfs functions.  so when i'm debugging the
> watchdog driver, i can simply go into
> /sys/kernel/debug/blackfin/watchdog/ and see the watchdog-specific
> MMRs and cat/echo them on the fly.  it's been quite handy and feedback
> from customers/developers is that it's nicely filled a small void in
> the development process.
> 

Mike is a quick developer, I am trying to keep up with him.
Exactly, the MMR debug FS interface helps very much for developers and
customers.

> the trouble is that this file currently weighs in at ~1.8 megs.  this
> is because it contains all the information for all Blackfin processors
> we support (which currently, is about ~23 variants).  it's only going
> to get bigger as we support more.  Bryan cringes at the thought of
> submitting it to LKML :).  so i'm fishing around for alternatives ...
> the code was originally developed against 2.6.21, so UIO was not a
> possibility.  i'm still not sure if it is ... i'd have to research it
> a bit more and play with things.
> 

The main reason I am not willing to submit this to mainline is the file
size. It's almost the biggest file in the kernel source. And it will be
bigger and bigger when more and more new Blackfin processors supported
by Linux kernel.

My suggestion is:
 - move the large MMR table to user space
 - add an interface of debug FS which let uses space app to send the large table to debug FS
 - debug FS will take care of the rest HW things according to each architecture. 

Or more deeper thought:
 - we don't need all the MMR setup at the same time for debugging. for example, maybe for some developer, he/she only needs one driver MMR for debugging such as watchdog/usb/spi/i2c ....
 - How about split the debug MMR table to each drivers or processors?
 - watchdog driver implements a debug FS interface for debugging watchdog MMR and other drivers implement their own things.

I am not familiar with UIO, is it easy interactive with debug FS?

Thanks
-Bryan Wu
