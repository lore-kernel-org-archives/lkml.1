Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZBGP7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZBGP7M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 10:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZBGP65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 10:58:57 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:26465 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbZBGP64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 10:58:56 -0500
Date: Sat, 7 Feb 2009 16:58:43 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Uwe =?ISO-8859-15?B?S2xlaW5lLUv2bmln?= <ukleinek@strlen.de>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org, frank@f-seidel.de,
       w.sang@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
Message-ID: <20090207165843.6017c78a@hyperion.delvare>
In-Reply-To: <20090207105219.GA12371@strlen.de>
References: <498C3EEA.5060508@suse.de>
	<20090206183542.GB6361@strlen.de>
	<498C96B0.7050408@suse.de>
	<20090206222314.6c2b36f7@hyperion.delvare>
	<498D647C.8070107@suse.de>
	<20090207105219.GA12371@strlen.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Feb 2009 11:52:19 +0100, Uwe Kleine-König wrote:
> On Sat, Feb 07, 2009 at 11:37:48AM +0100, Frank Seidel wrote:
> > Jean Delvare wrote:
> > > Default log level? That's news to me. Care to elaborate?
> > 
> > printk (in kernel/printk.c) uses vprintk and vprintk:
> > asmlinkage int vprintk(const char *fmt, va_list args)
> > {
> >         int printed_len = 0;
> >         int current_log_level = default_message_loglevel;
> > ...
> > and default_message_loglevel in include/linux/kernel.h:
> > 
> > #define default_message_loglevel (console_printk[1])
> > 
> > and console_printk[1] is (in kernel/printk.c)
> > DEFAULT_MESSAGE_LOGLEVEL
> > 
> > and in kernel/printk.c:
> > #define DEFAULT_MESSAGE_LOGLEVEL 4 /* KERN_WARNING */
> > 
> > => so as far as i could see KERN_WARNING is the
> > default loglevel of messages.
> one little note:  This is changable writing to /proc/sys/kernel/printk.

OK, thanks for the information. I admit I am surprised that there is
such a default log level and that it is considered important enough to
be changeable through /proc/sys, and that on the other hand it is
considered bad to not have a log level for every message. That's
somewhat contradictory.

> So the patch introduces at least a little change in behaviour.
> IMHO this is OK though.

The aim of Frank's patch shouldn't be to preserve the behavior, as
there is no guarantee that the behavior is correct. In fact, for some
of the messages it is very obvious that it is not. The aim should be to
pick the appropriate log level for every message. If not then I don't
see any point in fixing the messages.

-- 
Jean Delvare
