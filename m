Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbZBGKiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbZBGKiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 05:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZBGKiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 05:38:15 -0500
Received: from ns2.suse.de ([195.135.220.15]:44840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbZBGKiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 05:38:14 -0500
Message-ID: <498D647C.8070107@suse.de>
Date: Sat, 07 Feb 2009 11:37:48 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= <ukleinek@strlen.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org, frank@f-seidel.de,
       w.sang@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
References: <498C3EEA.5060508@suse.de>	<20090206183542.GB6361@strlen.de>	<498C96B0.7050408@suse.de> <20090206222314.6c2b36f7@hyperion.delvare>
In-Reply-To: <20090206222314.6c2b36f7@hyperion.delvare>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Default log level? That's news to me. Care to elaborate?

printk (in kernel/printk.c) uses vprintk and vprintk:
asmlinkage int vprintk(const char *fmt, va_list args)
{
        int printed_len = 0;
        int current_log_level = default_message_loglevel;
...
and default_message_loglevel in include/linux/kernel.h:

#define default_message_loglevel (console_printk[1])

and console_printk[1] is (in kernel/printk.c)
DEFAULT_MESSAGE_LOGLEVEL

and in kernel/printk.c:
#define DEFAULT_MESSAGE_LOGLEVEL 4 /* KERN_WARNING */

=> so as far as i could see KERN_WARNING is the
default loglevel of messages.

Thanks,
Frank
