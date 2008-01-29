Return-Path: <linux-kernel-owner+w=401wt.eu-S1759697AbYA2C2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697AbYA2C2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 21:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYA2C2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 21:28:10 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:48886 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYA2C2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 21:28:09 -0500
Subject: Re: [PATCH] correct inconsistent ntp interval/tick_length usage
From: john stultz <johnstul@us.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <Pine.LNX.4.64.0801251349120.17507@scrub.home>
References: <1201142334.6383.40.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801251349120.17507@scrub.home>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 18:28:06 -0800
Message-Id: <1201573686.6766.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-25 at 15:07 +0100, Roman Zippel wrote:
> Hi,
> 
> On Wed, 23 Jan 2008, john stultz wrote:
> 
> > This difference in calculation was causing the clocksource correction
> > code to apply a correction factor to the clocksource so the two
> > intervals were the same, however this results in the actual frequency of
> > the clocksource to be made incorrect. I believe this difference would
> > affect all clocksources, although to differing degrees depending on the
> > clocksource resolution.
> 
> Let's look at why the correction is done in first place. The update steps 
> don't add up precisely to 1sec (LATCH*HZ != CLOCK_TICK_RATE), so a small 
> addjustment is used to make up for it. The problem here is that if the 
> update frequency changes, the addjustment isn't correct anymore.
> The simple fix is to just omit the addjustment in these cases in ntp.c:
> 
> #if NTP_INTERVAL_FREQ == HZ
> ...
> #else
> #define CLOCK_TICK_ADJUST	0
> #endif

Hmmm, although this doesn't explain why the issue is seen when
NTP_INTERVAL_FREQ == HZ (as it is in my system's case). Or am I missing
something?

Regardless, current_tick_length() really is the base interval we're
using in the error accumulation loop, so it seems the cleanest interface
to use (just to avoid redundancy at least) when establishing the
clocksource's interval length. Or do you not agree?

thanks
-john






