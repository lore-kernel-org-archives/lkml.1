Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZG3Uh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZG3Uh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 16:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZG3UhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 16:37:24 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60167 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZG3UhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 16:37:23 -0400
Date: Thu, 30 Jul 2009 22:37:23 +0200
From: Andreas Mohr <andi@lisas.de>
To: Daniel Walker <dwalker@fifo99.com>
Cc: john stultz <johnstul@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][patch 00/12] clocksource / timekeeping rework V2
Message-ID: <20090730203723.GA20820@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248977320.6046.66.camel@desktop>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Thu, 2009-07-30 at 10:16 -0700, john stultz wrote:
> > Clocksources as modules was one of the initial design goals I had way
> > back. The benefit being that an older distro kernel could be made to
> > support newer stranger hardware via a clocksource driver. While the
> > hardware vendors have for the most part consolidated on HPET/ACPI PM
> > which has mostly avoided the need, I still think its worth preserving.
> 
> If the PIT case is a real use case for unregister than we can keep it
> around. If not, then that path just becomes unused and all unused code
> is open for removal from my perspective.
> 
> If the case you describe above is a good one, then someone eventually
> will add back the unregister path. Which should come with a good reason
> and with an actual user of the code..
> 
> Daniel

I'm still having a tendency towards unhappiness about my snd-azf3328
PCI soundcard driver and its new use of clock_event_device,
without a proper unload path existing (read: clock_event_device is the sole one
of about 7 different driver components - PCM, I2S, OPL3, MPU401, AC97 mixer,
joystick, ALSA sequencer timer / clock_event_device - which now suddenly
managed to prevent the driver from being unloadable for the first time
in its entire history) and not too many explanations as to how to
get this working optimally...

Would that be enough of a justification? ;-P

Plus [OT], would anyone perhaps have an explanation why I'm getting stalls
every couple seconds (probably a race between set_next_event() programming
the next value already and timer-related interrupt handling causing a
nearby trigger to get lost, but I don't know how to resolve this
- how do other drivers manage to handle this easily racey activity??).
BTW mouse interrupt activity does NOT manage to cancel these stalls.
This is especially noticeable during video playback.

Thanks,

Andreas Mohr
