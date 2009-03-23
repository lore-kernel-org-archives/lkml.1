Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZCWALW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZCWALW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 20:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZCWALN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 20:11:13 -0400
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:51415 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028AbZCWALM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 20:11:12 -0400
From: Frans Pop <elendil@planet.nl>
To: John Stultz <johnstul@us.ibm.com>
Subject: Re: [BUG,2.6.28,s390] Fails to boot in Hercules S/390 emulator - hang traced
Date: Mon, 23 Mar 2009 01:11:06 +0100
User-Agent: KMail/1.9.9
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903080230.10099.elendil@planet.nl> <200903181307.44867.elendil@planet.nl> <1237391338.32698.9.camel@jstultz-laptop>
In-Reply-To: <1237391338.32698.9.camel@jstultz-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903230111.08814.elendil@planet.nl>
X-OriginalArrivalTime: 23 Mar 2009 00:11:09.0580 (UTC) FILETIME=[DE36CCC0:01C9AB4B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009, John Stultz wrote:
> > Ever increasing error with tod on 2.6.28.8 (with Martin's patch
> > applied):
> > 0.672655! timekeeping: clock source changed from jiffies to tod (shift: 12)
> > 0.676889! tod/12 (150): xtime.tv: 1237377507/55524946 -> 1237377507/55524947
> > 0.677020!    clock->xtime: 0 -> -4096, error: 0 -> -4294967296
> > 0.680788! tod/12 (151): xtime.tv: 1237377507/55524947 -> 1237377507/55524948
[...]
> > 491.860765! tod/12 (37189): xtime.tv: 1237377998/55561985 -> 1237377998/55561986
> > 491.860886!  clock->xtime: -4096 -> -4096, error: -159081293676544 -> -159085588643840
>
> Hrm. Is the box otherwise working ok? The TOD clock should not be
> affected by the second issue (one shot mode) discussed.

Yes, the box^Wsystem works fine. I've now also seen the eventual correction
of the error in action: after 35 mins of uptime clock->multi changed from
1000 to 999 (with tod).

So the only issue left, though only indirectly related to the hang, is
the initial behavior with clocksource jiffies where clocksource_bigadjust
gets called every time update_wall_time is called (I've confirmed that).

And possibly the cleanup change of clock->xtime_nsec to S64.

I'll happily leave those to you as I readily admit my understanding of the
whole timekeeping thing is still very limited. But if you'd like patches
tested, feel free to CC me.

Thanks again for you excellent work on tracking down the real cause of the
hangs.

Cheers,
FJP
