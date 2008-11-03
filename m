Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbYKCRV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbYKCRV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYKCRVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:21:48 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:8017 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750759AbYKCRVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:21:47 -0500
Date: Mon, 3 Nov 2008 20:21:46 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, Andrew Morton <akpm@linux-foundation.org>,
       Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] power_supply: change the way how wm97xx-bat driver is
	registered
Message-ID: <20081103172146.GA8913@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com> <1225271050-21171-2-git-send-email-dbaryshkov@gmail.com> <20081103151151.GB23466@oksana.dev.rtsoft.ru> <490F2CE1.8070707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <490F2CE1.8070707@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 04:54:57PM +0000, Jonathan Cameron wrote:
[...]
> It is needlessly complex for this sort of thing, but that's not it's
> purpose.  (though that's not to say it won't be able to do this sort
> of thing).  It's gotten a smigeon delayed due to a change of my own
> requirements for what it does.  As a reminder, the purpose of that
> subsystem was at least partly to provide reasonably high performance
> data capture facilities (ring buffers, triggered sampling etc alongside
> suitably powerful userspace interfaces.)  Possibly my apps are somewhat
> unusual, but the complexity is absolutely necessary for what I'm doing
> (annoyingly!)

Yeah, I understand that. But when you need simple driver for very
simple ADC device, the subsystem is a bit scary. Maybe we could just
implement "simple API" on top of it, that would hide the complexity.

Something like

value = adc_sample_pin(adc_device, "voltage");

And

struct adc_pin pins[2];
pins[0].name = "x-axis";
pins[0].num_samples = 5;
pins[1].name = "y-axis";
pins[2].num_samples = 5;

adc_sample_pins(adc_device, pins);
for (i = 0; i < ARRAY_SIZE(pins); i++) {
	for (j = 0; j < pins[i].num_samples; i++)
		process(pins[i].values[j].value);
}

That would work for most in-kernel ADC users (batteries, touchscreens).

> Anyhow, definitely not given up on it.

Great, looking forward to your patches.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
