Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbXLZUZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbXLZUZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 15:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXLZUYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 15:24:55 -0500
Received: from smtp.nokia.com ([192.100.122.230]:56559 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbXLZUYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 15:24:54 -0500
Subject: Re: [linux-pm] [RFC] sleepy linux
From: Igor Stoppa <igor.stoppa@nokia.com>
Reply-To: igor.stoppa@nokia.com
To: ext Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
In-Reply-To: <20071225230731.GA29030@elf.ucw.cz>
References: <20071225230731.GA29030@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: OSSO
Date: Wed, 26 Dec 2007 22:09:59 +0200
Message-Id: <1198699799.21629.13.camel@mort>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-OriginalArrivalTime: 26 Dec 2007 20:24:19.0693 (UTC) FILETIME=[4B5FD9D0:01C847FD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Wed, 2007-12-26 at 00:07 +0100, ext Pavel Machek wrote:
> This is RFC. It does not even work for me... it sleeps but it will not
> wake up, because SATA wakeup code is missing. Code attached for illustration.
> 
> I wonder if this is the right approach? What is right interface to the
> drivers?
> 
> 
> 		Sleepy Linux
> 		~~~~~~~~~~~~
> 
> Copyright 2007 Pavel Machek <pavel@suse.cz>
> 	  GPLv2
> 
> Current Linux versions can enter suspend-to-RAM just fine, but only
> can do it on explicit request. But suspend-to-RAM is important, eating
> something like 10% of power needed for idle system. Starting suspend
> manually is not too convinient; it is not an option on multiuser
> machine, and even on single user machine, some things are not easy:
> 
> 1) Download this big chunk in mozilla, then go to sleep
> 
> 2) Compile this, then go to sleep

Why can't these cases be based on CPUIdle?

> 3) You can sleep now, but wake me up in 8:30 with mp3 player

This is about setting up properly the wakeup sources which means:

- the wakeup source is really capable of generating wakeups for the
target idle state

- the wakeup source is not actually capable of genrating wakeups from
the target idle state, which can be solved in 2 ways:

	- if the duration of the activity is known, set up an alarm 
	  (assuming alarms are proper wakeup sources) so that the
	   system is ready just in time, in a less efficient but more
	   responsive power saving state

	- if the duration of the activity is unknown choose the more 
	  efficient amongst the following solutions:

		- go to deep sleep state and periodically wakeup and
		  poll, with a period compatible with the timing 
		  of the event source

		- prevent too deep sleep states till the event happens

> Todays hardware is mostly capable of doing better: with correctly set
> up wakeups, machine can sleep and successfully pretend it is not
> sleeping -- by waking up whenever something interesting happens. Of
> course, it is easier on machines not connected to the network, and on
> notebook computers.

It might be that some hw doesn't provide deep power saving state for
some devices, but if the only missing feature is the wakeup capability,
it could be effectively replaced by some HW timer.


> Requirements:
> 
> 0) Working suspend-to-RAM, with kernel being able to bring video back.
> 
> 1) RTC clock that can wake up system
> 
> 2) Lid that can wake up a system,
>    or keyboard that can wake up system and does not loose keypress
>    or special screensaver setup
> 
> 3) Network card that is either down
>    or can wake up system on any packet (and not loose too many packets)

These are just few system specific case, but if you start including USB
devices, the situation is going to get quite complicated very soon, if
you explicitly include certain HW devices in your model.


-- 
Cheers, Igor

Igor Stoppa <igor.stoppa@nokia.com>
(Nokia Multimedia - CP - OSSO / Helsinki, Finland)
