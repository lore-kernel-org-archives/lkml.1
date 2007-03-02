Return-Path: <linux-kernel-owner+w=401wt.eu-S2992549AbXCBQAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992549AbXCBQAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 11:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992543AbXCBQAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 11:00:06 -0500
Received: from www.osadl.org ([213.239.205.134]:34433 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992550AbXCBQAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 11:00:04 -0500
Subject: Re: Is the clockevent resolution fine-grained enough?
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Marko Rauhamaa <marko@pacujo.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <m3649kweyj.fsf@elektro.pacujo.net>
References: <m3649kweyj.fsf@elektro.pacujo.net>
Content-Type: text/plain; charset=utf-8
Date: Fri, 02 Mar 2007 17:05:46 +0100
Message-Id: <1172851546.24738.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 18:34 -0800, Marko Rauhamaa wrote:
> It would appear the new clockevent API has a one-nanosecond resolution.
> It certainly looks sufficiently fine-grained, but I'm afraid it's too
> coarse for some applications.

That's an academic exercise, or are you talking about some real world
hardware which runs Linux ?

> In our application, we need periodic clock interrupts at about 100 kHz.

With a stock kernel ?

> If the (programmable) frequency must be rounded to the nearest
> nanosecond, we have a cumulative error of
> 
>    100,000 * 0.5 ns/s = 50 µs/s
> 
> We need to maintain the cumulative error within, say, 1 ms/day, or
> 11 ns/s. (The error is not measured against real time, but between
> different parts of our hardware that are run off of the same clock.)

clockevents is based on the monotonic system clock and depends on the
accuracy of that and the device which deliveres the interrupts.

> For our needs, we have built our own "clockevent" system that has a
> nominal one-femtosecond precision. The nanosecond resolution would be
> sufficient if there was a way to "nudge" the next interrupt by a
> nanosecond from the interrupt handler.

There is nothing to nugde. The clockevent subsystem operates on absolute
time, so there is no cummulative error, except you setup your timers
relative per event.

	tglx


