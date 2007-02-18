Return-Path: <linux-kernel-owner+w=401wt.eu-S933215AbXBRLNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbXBRLNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 06:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933222AbXBRLNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 06:13:13 -0500
Received: from tim.rpsys.net ([194.106.48.114]:60947 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933215AbXBRLNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 06:13:12 -0500
Subject: Re: [PATCH] input: extend EV_LED
From: Richard Purdie <rpurdie@rpsys.net>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <freemail.20070118084500.15225@fm07.freemail.hu>
References: <freemail.20070118084500.15225@fm07.freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sun, 18 Feb 2007 11:12:41 +0000
Message-Id: <1171797161.5816.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-18 at 08:45 +0100, Németh Márton wrote:
> A blinking led is basically a PWM (Pulse Width Modulation)
> signal. A PWM signal has three different attribute. The
> first one is the amplitude, this attribute is already
> provided by the led subsystem as "brightness". There are two
> more attributes, which are the frequency [Hz] and the duty
> cycle [%], or the on-time [ms] and off-time [ms].
> 
> The frequency [Hz] and duty cycle [%] parameters has the
> problem, that if we are limited to integers, it is not
> possible to express slower blinks than 1Hz. We could also
> use [mHz] (milli-Hertz), but it is not very common unit.
> 
> The on-time [ms] and off-time [ms] seems to be easier to
> handle (and this is also easier to simulate from software if
> ever needed). An RO attribute could be introduced:
> 'pwm_available', which can contain parameter pairs separated
> by space, and the new parameter pair is in new line. An RW
> attribute 'pwm' could accept a parameter pair separated by
> space.

We already have a timer trigger which takes an on time and an off time
for the reason you mention above (floating point would get ugly).

The problem is mainly about finding ways to enable hardware acceleration
of the existing timer trigger (where possible) and maybe implementing a
simpler blink trigger which could be hardware accelerated when the full
blown timer trigger couldn't. 

Regards,

Richard

