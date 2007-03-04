Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXCDCqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXCDCqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 21:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932798AbXCDCqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 21:46:37 -0500
Received: from 206-72-67-168.dsl.dock.net ([206.72.67.168]:41502 "EHLO
	elektro.pacujo.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932780AbXCDCqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 21:46:36 -0500
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is the clockevent resolution fine-grained enough?
References: <m3649kweyj.fsf@elektro.pacujo.net>
	<1172851546.24738.62.camel@localhost.localdomain>
	<m3k5xzy2w3.fsf@elektro.pacujo.net>
	<1172912070.24738.99.camel@localhost.localdomain>
Date: 03 Mar 2007 18:46:35 -0800
In-Reply-To: <1172912070.24738.99.camel@localhost.localdomain>
Message-ID: <m3fy8lybck.fsf@elektro.pacujo.net>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Delivery-Agent: TMDA/1.0.3 (Seattle Slew)
From: Marko Rauhamaa <marko@pacujo.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de>:

> 100khz on a stock kernel with real world hardware:
> 
> ROTFL, You made my day. 

I don't know why you find that rate unbelievable.

> Sorry man. Did you actually read what I wrote ? 
> 
> > The clockevent subsystem operates on absolute time, so there is no
> > cummulative error

You are right. I misunderstood what you meant by "absolute time".

> timer_function()
> {
> 	do_whatever_you_need_to_do();
> 
> 	next_event += interval;
> 	set_next_event(yokto_seconds_to_nsec(next_event), ABSOLUTE);
> }
> 
> Please read _AND_ understand the clockevents code. Your uber_clockevents
> patch is solving PEBKAC.

I tried to quickly reconstruct the API from a recent clockevent patch I
found with google (<URL:
http://www.mail-archive.com/mm-commits@vger.kernel.org/msg09566.html>).
I saw the enum "CLOCK_EVT_MODE_PERIODIC" and automatically thought of
using that since my application is periodic. I imagined you wouldn't
have to keep on ordering the notification again in every callback. It's
also difficult to estimate how expensive an operation the explicit
rearming would be in the clock event device (the periodic notifications
can probably be optimized effectively).

You are right. By calling set_next_event() in every callback I can
implement what I want (provided that the API guarantees that the
absolute time can be in the past).


Marko

-- 
Marko Rauhamaa      mailto:marko@pacujo.net     http://pacujo.net/marko/
