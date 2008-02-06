Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbYBFTmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbYBFTmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbYBFTlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:41:52 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:18194 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758385AbYBFTlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Z6fAXg+AW6vjViBP+w3Orr2/tDu2s9Lf71VttgS3nGnFBt+v0PYdBgwMn5xqNcToErncScpKxL1o6e4geQ3sfkLlNZsDPVtIGuJIzzwfiliFxjSJyNAB2LFy/5jHnx1C9rUXb8BuwHtG05StbSATM/RuJKY1lPxf04i4GHNToQY=
Message-ID: <3efb10970802061141x5fdecefao8f617265aed7cb6f@mail.gmail.com>
Date: Wed, 6 Feb 2008 20:41:49 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: michael <trimarchi@gandalf.sssup.it>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>, fabio@gandalf.sssup.it,
       "Andrew Victor" <linux@maxim.org.za>,
       "Chip Coldwell" <coldwell@redhat.com>,
       "Marc Pignat" <marc.pignat@hevs.ch>,
       "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <47A9A5B5.3060800@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129224316.GA23155@gandalf.sssup.it>
	 <20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
	 <47A09723.7020000@gandalf.sssup.it>
	 <20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
	 <47A12A2E.5040309@gandalf.sssup.it>
	 <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
	 <3efb10970801311136y12670f12x6e4fdd44de3677b9@mail.gmail.com>
	 <20080204133925.73733f5f@dhcp-252-066.norway.atmel.com>
	 <3efb10970802041144j6b4e6893j293819238b5b82e8@mail.gmail.com>
	 <47A9A5B5.3060800@gandalf.sssup.it>
X-Google-Sender-Auth: b4fdbe6b7e8fc012
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

> the serial driver works fine. The problem seems to be related to the
> tclib, when I use it as a clocksource.

tclib as a clocksource should be no problem on Preempt-RT, do not use
it as clockevent device, it will not work properly on preempt-rt on
at91* yet, especially with the NO_HZ config.

> The numbers of overruns depends on the type of
> files too. It is possible?

I am still very curious to your (RT-) thread-prio layout. The problems
you mention can also be caused by a weird configuration of these
threads on preempt-rt.

Remy


2008/2/6, michael <trimarchi@gandalf.sssup.it>:
> Hi,
>
> the serial driver works fine. The problem seems to be related to the
> tclib, when I use
> it as a clocksource. The numbers of overruns depends on the type of
> files too.
> It is possible?
>
> Regards
> Michael
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
