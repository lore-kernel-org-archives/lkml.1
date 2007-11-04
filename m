Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbXKDDMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbXKDDMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 23:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbXKDDMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 23:12:09 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2805 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbXKDDMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 23:12:08 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: CLOCK_TICK_RATE in NTP code
Date: Sun, 4 Nov 2007 05:08:51 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20071101152914.GA19732@linux-mips.org>
In-Reply-To: <20071101152914.GA19732@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711040408.52404.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 01 November 2007, Ralf Baechle wrote:

> kernel/time/ntp.c contains the following piece of code:
>
> #define CLOCK_TICK_OVERFLOW     (LATCH * HZ - CLOCK_TICK_RATE)
> #define CLOCK_TICK_ADJUST       (((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC)
> / \ (s64)CLOCK_TICK_RATE)
>
> static void ntp_update_frequency(void)
> {
>         u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
>                                 << TICK_LENGTH_SHIFT;
>         second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
>         second_length += (s64)time_freq << (TICK_LENGTH_SHIFT -
> SHIFT_NSEC);
>
>         tick_length_base = second_length;
>
>         do_div(second_length, HZ);
>         tick_nsec = second_length >> TICK_LENGTH_SHIFT;
>
>         do_div(tick_length_base, NTP_INTERVAL_FREQ);
> }
>
> So it uses CLOCK_TICK_RATE which on many systems but not all is defined to
> the i8253 input clock.  But timekeeping on anything remotely modern makes
> little use of the i8253 so I wonder the intent was here.

The basic idea is to provide a base frequency adjustment, when I wrote this I 
already wasn't entirely happy that it was hardcoded like this, but in the end 
I simply reimplemented what the old code did.
It's not strictly needed, so if someone wants to add something like:

#ifndef CLOCK_TICK_RATE
#define CLOCK_TICK_ADJUST 0
#else
...

it would be fine with me.

bye, Roman
