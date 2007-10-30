Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbXKAOdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbXKAOdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbXKAOdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:33:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4268 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755216AbXKAOdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:33:01 -0400
Date: Tue, 30 Oct 2007 14:48:39 +0000
From: Pavel Machek <pavel@ucw.cz>
To: jack@antonello.org
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
Subject: Re: [PATCH] backlight dimmer
Message-ID: <20071030144838.GD7742@ucw.cz>
References: <4724B48D.6090405@antonello.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4724B48D.6090405@antonello.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-10-28 17:10:53, jack@antonello.org wrote:
> Hello,
> this patch implements a macbook like backlight dimmer on 
> top of backlight.c.
> 
> The dimmer is entirely in kernelspace and is suitable 
> for an embedded context in order to avoid the overhead 
> of a daemon controlling the backlight. Implementing this 
> functionality in userspace has other advantages and is a 
> perfectly reasonable alternative, so this patch is
> not the definitive solution.
> 
> activate dimmer:
> echo 1 > /sys/devices/virtual/backlight/*/dimmer_control
> 
> other attributes (britness levels & timeout):
> /sys/devices/virtual/backlight/*/dimmer_high_level
> /sys/devices/virtual/backlight/*/dimmer_low_level
> /sys/devices/virtual/backlight/*/dimmer_timeout

I'd say that userspace makes sense here. I'd want backlight to go down
slowly, for example.

But... maybe undimming should be done in kernel, so it keeps
low,latency?

Hmm, maybe existing screen blanking infrastructure can be reused?

> --- linux-2.6.23.1/include/linux/backlight.h 2007-10-12 
> 18:43:44.000000000 +0200
> +++ b/include/linux/backlight.h	2007-10-28 
> 13:45:21.000000000 +0100
> @@ -11,6 +11,7 @@
> #include <linux/device.h>
> #include <linux/mutex.h>
> #include <linux/notifier.h>
> +#include <linux/timeout.h>
> 
> /* Notes on locking:

Your mail client damages patches?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
