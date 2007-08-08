Return-Path: <linux-kernel-owner+w=401wt.eu-S934776AbXHHWlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934776AbXHHWlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759905AbXHHWlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:41:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759496AbXHHWli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:41:38 -0400
Date: Wed, 8 Aug 2007 15:41:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: turn serial console suspend a boot rather than
 compile time option
Message-Id: <20070808154130.9cc3a30e.akpm@linux-foundation.org>
In-Reply-To: <20070808183535.2a2c6edf.dilinger@queued.net>
References: <20070808183535.2a2c6edf.dilinger@queued.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 18:35:35 -0400
Andres Salomon <dilinger@queued.net> wrote:

> Currently, there's a CONFIG_DISABLE_CONSOLE_SUSPEND that allows one to stop
> the serial console from being suspended when the rest of the machine goes
> to sleep.  This is incredibly useful for debugging power management-related
> things; however, having it as a compile-time option has proved to be
> incredibly inconvenient for us (OLPC).  There are plenty of times that we
> want serial console to not suspend, but for the most part we'd like serial
> console to be suspended.
> 
> This drops CONFIG_DISABLE_CONSOLE_SUSPEND, and replaces it with a kernel
> boot parameter (no_console_suspend).  By default, the serial console will
> be suspended along with the rest of the system; by passing
> 'no_console_suspend' to the kernel during boot, serial console will remain
> alive during suspend.
> 
> I have another version of this patch which keeps #ifdefs around; however,
> it's uglier.  I prefer this version of the patch, and don't feel that it
> increases bloat.  If people strongly disagree, let me know and I'll submit
> the other patch.
> 

yep, compile-time options suck.

> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -172,6 +172,8 @@ extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
>  extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>  				unsigned int interval_msec);
>  
> +extern int console_suspend;
> +

That's a somewhat vague-sounding identifier.  Could we call it
console_suspend_enabled or something?

