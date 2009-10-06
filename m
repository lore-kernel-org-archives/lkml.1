Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbZJFOdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbZJFOdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932799AbZJFOdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:33:39 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:58637 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798AbZJFOdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:33:38 -0400
X-IronPort-AV: E=Sophos;i="4.44,513,1249272000"; 
   d="scan'208";a="5414773"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
Date: Tue, 6 Oct 2009 15:32:56 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E3F46A7@limkexm3.ad.analog.com>
In-Reply-To: <20091006135836.GA3926@rakim.wolfsonmicro.main>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
thread-index: AcpGjR7nFKqu+3r2Q9S/bJWcxQ4LsQAAbzrQ
References: <1253682664-27040-1-git-send-email-vapier@gentoo.org> <1254815071-15822-1-git-send-email-vapier@gentoo.org> <20091006115543.GH27168@sirena.org.uk> <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com> <20091006123658.GA31079@rakim.wolfsonmicro.main> <8A42379416420646B9BFAC9682273B6D0E3F4420@limkexm3.ad.analog.com> <20091006135836.GA3926@rakim.wolfsonmicro.main>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
CC: "Mike Frysinger" <vapier@gentoo.org>,
       "Samuel Ortiz" <sameo@linux.intel.com>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>, "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 06 Oct 2009 14:32:59.0161 (UTC) FILETIME=[E6E77090:01CA4691]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>On Tue, Oct 06, 2009 at 01:55:45PM +0100, Hennerich, Michael wrote:
>> >From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>
>> >I'm not sure what the association with virtual gpios is?  This is
all
>> >separate to gpiolib except in that it would mean that a gpio driver
for
>> >the device would be able to export these interrupts to its clients.
>
>> This is what I meant.
>> So you propose having the MFD Core as well as its subdevs requesting
the
>> ADP5520 IRQ (client->irq) IRQF_SHARED? I think we already excluded us
>> from using this option when we were asked to move to the NEW threaded
>> irqs?
>
>No, I'm suggesting implementing an IRQ controller driver for the device
>- register an irq_chip for the interrupt controller on it.  Support for
>doing this on I2C devices was added at pretty much the same time as the
>IRQ_ONESHOT support.  This gives access to all the genirq infrastrure
>features rather than having to implement a custom IRQ handling stack.
>
>Like I say, I'm not sure what you meant when you were talking about
>virtual gpios.

This is not an interrupt controller.
The only ADP5520 subdev that needs to be notified is the adp5520-keys
input driver, if present.
Sounds like overshoot, registering a irq_chip using
set_irq_chip_and_handler() and friends, for exactly one dedicated and
known consumer.

-Michael
