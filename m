Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab0BKU6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:58:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38265 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab0BKU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:58:07 -0500
Date: Thu, 11 Feb 2010 21:58:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 2/5] Emulates PWM hardware using a high-resolution
 timer and a GPIO pin
Message-ID: <20100211205801.GA29159@elf.ucw.cz>
References: <cover.1265094517.git.bgat@billgatliff.com>
 <2d73f9b2fd175fd3e482920baebcd3028206f02e.1265094517.git.bgat@billgatliff.com>
 <20100211200702.GB1487@ucw.cz>
 <4B746A02.9060306@billgatliff.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B746A02.9060306@billgatliff.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-02-11 14:35:14, Bill Gatliff wrote:
> Pavel Machek wrote:
> >> +static void
> >> +gpio_pwm_work (struct work_struct *work)
> >> +{
> >> +	struct gpio_pwm *gp = container_of(work, struct gpio_pwm, work);
> >> +
> >> +	if (gp->active)
> >> +		gpio_direction_output(gp->gpio, gp->polarity ? 1 : 0);
> >> +	else
> >> +		gpio_direction_output(gp->gpio, gp->polarity ? 0 : 1);
> >> +}
> >>     
> >
> > ...polarity ^ active ?
> >   
> 
> ... except that if polarity and/or active are >1, I don't send the
> values 1 or 0 to gpio_direction_output.  I don't know if the API is
> specifically intended to accept nonzero values that are greater than 1.

!polarity ^ !active ? :-).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
