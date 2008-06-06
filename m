Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYFFKEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYFFKEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbYFFKEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:04:41 -0400
Received: from www.tglx.de ([62.245.132.106]:43023 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbYFFKEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:04:41 -0400
Date: Fri, 6 Jun 2008 12:04:23 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, akpm@linux-foundation.org, lethal@linux-sh.org,
       tglx@linutronix.de
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080606100423.GA3213@local>
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se> <20080604101144.GA3207@local> <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605064945.GA32554@digi.com> <aec7e5c30806051955q5f812e41y9c2f322d98333232@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aec7e5c30806051955q5f812e41y9c2f322d98333232@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 11:55:30AM +0900, Magnus Damm wrote:
> Hi Uwe,
> 
> On Thu, Jun 5, 2008 at 3:49 PM, Uwe Kleine-König
> <Uwe.Kleine-Koenig@digi.com> wrote:
> > Hello Magnus,
> >
> > Magnus Damm wrote:
> >> ... "Unique IRQ Mode". ...
> > BTW, I wouldn't call it "Unique IRQ Mode" because the non-shared irq is
> > only a result from automatically disabling the irq.  IMHO something like
> > "No IRQ Handler Mode" is more suitable.
> 
> That may be a good idea. Any name is fine with me.
> 
> Hopefully a better name will make people less confused. =)

I didn't criticize the name. My objection is that you want to introduce
an optional special handling for cases where the interrupt line is not
shared, e.g. a GPIO line. In that case, the handler _could_ look like
this:

static irqreturn_t my_handler(int irq, struct uio_info *info)
{
	irq_disable(MY_GPIO_LINE);
	return IRQ_HANDLED;
}

This solution is only second best, if possible, the irq should be
properly acknowledged within the chip, but it could be done like this.
Note that this doesn't work on every platform, it assumes that each GPIO
line has its own irq number. (Did you ever think about fixing Kconfig so
that this option is disabled on platforms where it is not possible or
not sensible to do this?)

You now suggest that if somebody doesn't fill in an irq handler, we
should make the above the default. This would save somebody the trouble
to add the above 5 lines to the 30 lines of board/platform support code
he has to write anyway. That's the only gain, and that is not enough.

Giving it a different name doesn't make it better.

Thanks,
Hans

