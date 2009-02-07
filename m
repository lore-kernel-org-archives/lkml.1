Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZBGKwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZBGKwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 05:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbZBGKw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 05:52:26 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42702 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbZBGKwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 05:52:25 -0500
Date: Sat, 7 Feb 2009 11:52:19 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
To: Frank Seidel <fseidel@suse.de>
Cc: Jean Delvare <khali@linux-fr.org>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org, frank@f-seidel.de,
       w.sang@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
Message-ID: <20090207105219.GA12371@strlen.de>
References: <498C3EEA.5060508@suse.de> <20090206183542.GB6361@strlen.de> <498C96B0.7050408@suse.de> <20090206222314.6c2b36f7@hyperion.delvare> <498D647C.8070107@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498D647C.8070107@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 11:37:48AM +0100, Frank Seidel wrote:
> Jean Delvare wrote:
> > Default log level? That's news to me. Care to elaborate?
> 
> printk (in kernel/printk.c) uses vprintk and vprintk:
> asmlinkage int vprintk(const char *fmt, va_list args)
> {
>         int printed_len = 0;
>         int current_log_level = default_message_loglevel;
> ...
> and default_message_loglevel in include/linux/kernel.h:
> 
> #define default_message_loglevel (console_printk[1])
> 
> and console_printk[1] is (in kernel/printk.c)
> DEFAULT_MESSAGE_LOGLEVEL
> 
> and in kernel/printk.c:
> #define DEFAULT_MESSAGE_LOGLEVEL 4 /* KERN_WARNING */
> 
> => so as far as i could see KERN_WARNING is the
> default loglevel of messages.
one little note:  This is changable writing to /proc/sys/kernel/printk.

So the patch introduces at least a little change in behaviour.
IMHO this is OK though.

Best regards
Uwe
