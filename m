Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0BKUFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:05:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36765 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab0BKUFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:05:05 -0500
Date: Thu, 11 Feb 2010 21:04:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bill Gatliff <bgat@billgatliff.com>
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PWM PATCH 1/5] API to consolidate PWM devices behind a common
	user and kernel interface
Message-ID: <20100211200456.GA1487@ucw.cz>
References: <cover.1265094517.git.bgat@billgatliff.com> <c5873aa7c5d20254a9e54fc1ff179345b77c16b5.1265094517.git.bgat@billgatliff.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5873aa7c5d20254a9e54fc1ff179345b77c16b5.1265094517.git.bgat@billgatliff.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +Challenges
> +
> +One of the difficulties in implementing a generic PWM framework is the
> +fact that pulse-width-modulation applications involve real-world
> +signals, which often must be carefully managed to prevent destruction
> +of hardware that is linked to those signals.  A DC motor that
> +experiences a brief interruption in the PWM signal controlling it
> +might destructively overheat; it could suddenly change speed, losing
> +synchronization with a sensor; it could even suddenly change direction
> +or torque, breaking the mechanical device connected to it.

Stop right here. Linux is not hard realtime os, nor is it an os that
never crashes.

> +(A generic PWM device framework is not directly responsible for
> +preventing the above scenarios: that responsibility lies with the
> +hardware designer, and the application and driver authors.  But it

Exactly; if your hw can be damaged by software, it was misdesigned.

Is the paragraph #1 really neccessary?

> +Using the API to Generate PWM Signals -- Basic Functions for Users
> +
> +
> +pwm_request() -- Returns a pwm_channel pointer, which is subsequently
> +passed to the other user-related PWM functions.  Once requested, a PWM
> +channel is marked as in-use and subsequent requests prior to
> +pwm_free() will fail.
> +
> +The names used to refer to PWM devices are defined by driver authors.
> +Typically they are platform device bus identifiers, and this
> +convention is encouraged for consistency.
> +
> +
> +pwm_free() -- Marks a PWM channel as no longer in use.  The PWM device
> +is stopped before it is released by the API.

free is normally used for something else. Rename to open/close?

> +pwm_start(), pwm_stop() -- Turns the PWM signal on and off.  Except
> +where stated otherwise by a driver author, signals are stopped at the
> +end of the current period, at which time the output is set to its
> +inactive state.

What does it mean to stop a signal? What is the difference between 0%
duty cycle and stop() ?

> +pwm_polarity() -- Defines whether the PWM signal output's active
> +region is "1" or "0".  A 10% duty-cycle, polarity=1 signal will
> +conventionally be at 5V (or 3.3V, or 1000V, or whatever the platform
> +hardware does) for 10% of the period.  The same configuration of a
> +polarity=0 signal will be at 5V (or 3.3V, or ...) for 90% of the
> +period.

Is polarity realy required? Can't driver just replace duty with
100%-duty?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
