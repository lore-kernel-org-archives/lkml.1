Return-Path: <linux-kernel-owner+w=401wt.eu-S1762433AbZFKOnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762433AbZFKOnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZFKOnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:43:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44306 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZFKOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:43:31 -0400
Date: Thu, 11 Jun 2009 16:43:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] printk: add halt_delay parameter for printk delay in
	halt phase
Message-ID: <20090611144326.GB2572@ucw.cz>
References: <a8e1da0906020254s34dd0cd9id1b88655cab6d72d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0906020254s34dd0cd9id1b88655cab6d72d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-06-02 17:54:52, Dave Young wrote:
> Add a halt_delay module parameter in printk.c used to read the printk
> messages in halt/poweroff/restart phase, delay each printk messages
> by halt_delay milliseconds. It is useful for debugging if there's no
> other way to dump kernel messages that time.
> 
> halt_delay default value is 0, change it by:
> 
> echo xxx > /sys/module/printk/parameters/halt_delay

Well, stopping oopses from scrolling offscreen was very useful for me
in past.

> +static inline void halt_delay_msec(void)
> +{
> +	if (halt_delay == 0 || !(system_state == SYSTEM_HALT
> +				|| system_state == SYSTEM_POWER_OFF
> +				|| system_state == SYSTEM_RESTART))
> +		return;
> +
> +	mdelay(halt_delay);

...but this will not trigger for oops, right?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
