Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYBDTpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYBDTpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYBDToy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:44:54 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:4583 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYBDTox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:44:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ZP3dvq9hAkcf4TLeOgs3NAtQX38V+W5vJv5dFhfRryGnNoIJ/9iJiW9GtDB4FDEHnWdiJ0qbwdRMwyGrY6uU5q68D/qby7s4PGcO3V2AZYVhZEkMVBtjaNNlsTKoucnLcJMannbFlEw+RNXpVLuX/C7ntJGBPiLbq6JwbywmGYQ=
Message-ID: <3efb10970802041144j6b4e6893j293819238b5b82e8@mail.gmail.com>
Date: Mon, 4 Feb 2008 20:44:51 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Cc: michael <trimarchi@gandalf.sssup.it>, fabio@gandalf.sssup.it,
       "Andrew Victor" <linux@maxim.org.za>,
       "Chip Coldwell" <coldwell@redhat.com>,
       "Marc Pignat" <marc.pignat@hevs.ch>,
       "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080204133925.73733f5f@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129224316.GA23155@gandalf.sssup.it>
	 <20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	 <47A051A7.7030004@gandalf.sssup.it>
	 <20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>
	 <47A09723.7020000@gandalf.sssup.it>
	 <20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>
	 <47A12A2E.5040309@gandalf.sssup.it>
	 <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>
	 <3efb10970801311136y12670f12x6e4fdd44de3677b9@mail.gmail.com>
	 <20080204133925.73733f5f@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 2783dbf42de6fd71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

> That's what I was thinking too. If this is indeed the cause, the
> dev_err() added by the debug patch I posted should trigger and we may
> consider boosting the priority of the tasklet (using
> tasklet_hi_schedule.)

Notice that we are talking about Preempt-RT here. Everything is
running in thread context, even tasklets, softirqs etc. They are _all_
preemptible, and if Michael has some RT-thread in the system that has
a higher priority than this tasklet or softirq, than the buffer will
eventually overflow.
I wonder also if Michael has set the RT-priorities correctly, on RT
_every_ softirq/irq thread starts by default on priority 50,
SCHED_FIFO. If they are still at 50, any other softirq/tasklet, or irq
can make this behavior worse.
Notice that the default 50 thingy rarely gives a decent behaving
system. (But any other default will also give problems anyway, so it
_has_ to be customized/tuned by the end user)

Kind Regards,

Remy
