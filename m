Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbYA2ECg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbYA2ECg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 23:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYA2EC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 23:02:29 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:1216 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbYA2EC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 23:02:28 -0500
Date: Tue, 29 Jan 2008 05:02:21 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: john stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
In-Reply-To: <1201573686.6766.13.camel@localhost>
Message-ID: <Pine.LNX.4.64.0801290439480.17507@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0801251349120.17507@scrub.home> <1201573686.6766.13.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 28 Jan 2008, john stultz wrote:

> Regardless, current_tick_length() really is the base interval we're
> using in the error accumulation loop, so it seems the cleanest interface
> to use (just to avoid redundancy at least) when establishing the
> clocksource's interval length. Or do you not agree?

I see, what you need to use in timex.h for !CONFIG_NO_HZ is:

#define NTP_INTERVAL_LENGTH ((s64)LATCH * NSEC_PER_SEC) / (s64)CLOCK_TICK_RATE)

this calculates the base length of a clock tick in nsec.

current_tick_length() would only work during boot. If you switch clocks 
later, it would include random adjustments specific to the old clock.

bye, Roman
