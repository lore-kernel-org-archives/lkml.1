Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0BLNlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 08:41:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39943 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0BLNlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 08:41:07 -0500
Date: Fri, 12 Feb 2010 14:41:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Stanislav O. Bezzubtsev" <stas@lvk.cs.msu.su>
Cc: Bill Gatliff <bgat@billgatliff.com>, linux-embedded@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 2/5] Emulates PWM hardware using a high-resolution
	timer and a GPIO pin
Message-ID: <20100212134103.GA24949@atrey.karlin.mff.cuni.cz>
References: <cover.1265094517.git.bgat@billgatliff.com> <2d73f9b2fd175fd3e482920baebcd3028206f02e.1265094517.git.bgat@billgatliff.com> <20100211200702.GB1487@ucw.cz> <4B746A02.9060306@billgatliff.com> <20100211205801.GA29159@elf.ucw.cz> <A8919B3D-43EF-4EA5-8334-F1B52AE97E5A@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A8919B3D-43EF-4EA5-8334-F1B52AE97E5A@lvk.cs.msu.su>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 11.02.2010, ? 23:58, Pavel Machek ???????(?):
> 
> > On Thu 2010-02-11 14:35:14, Bill Gatliff wrote:
> >> Pavel Machek wrote:
> >>>> +static void
> >>>> +gpio_pwm_work (struct work_struct *work)
> >>>> +{
> >>>> +	struct gpio_pwm *gp = container_of(work, struct gpio_pwm, work);
> >>>> +
> >>>> +	if (gp->active)
> >>>> +		gpio_direction_output(gp->gpio, gp->polarity ? 1 : 0);
> >>>> +	else
> >>>> +		gpio_direction_output(gp->gpio, gp->polarity ? 0 : 1);
> >>>> +}
> >>>> 
> >>> 
> >>> ...polarity ^ active ?
> >>> 
> >> 
> >> ... except that if polarity and/or active are >1, I don't send the
> >> values 1 or 0 to gpio_direction_output.  I don't know if the API is
> >> specifically intended to accept nonzero values that are greater than 1.
> > 
> > !polarity ^ !active ? :-).
> 
> 
> One the one hand that wouldn't be 100% right because according to
> ANSI C !(0) is just != 0 but no one says it is 1.

I believe you are wrong here.

!!x is common idiom using to turn anything into 0/1, used all over kernel.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
