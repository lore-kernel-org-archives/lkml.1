Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZBEK1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZBEK1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZBEK1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:27:14 -0500
Received: from ns2.suse.de ([195.135.220.15]:35764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZBEK1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:27:13 -0500
From: Andreas Schwab <schwab@suse.de>
To: Floris Kraak <randakar@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Robert Hancock <hancockrwd@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	<20090204221451.GA27254@uranus.ravnborg.org>
	<adavdrplty2.fsf@cisco.com> <498A295A.4090008@gmail.com>
	<adaskmtjsnn.fsf@cisco.com>
	<56e1b5710902050026s5a8fd48fhf4a65c05a533dbc3@mail.gmail.com>
	<56e1b5710902050215l5b34adb1ofb8a972318ebe353@mail.gmail.com>
X-Yow: Toes, knees, NIPPLES.  Toes, knees, nipples, KNUCKLES...
 Nipples, dimples, knuckles, NICKLES, wrinkles, pimples!!
 I don't like FRANK SINATRA or his CHILDREN.
Date: Thu, 05 Feb 2009 11:27:10 +0100
In-Reply-To: <56e1b5710902050215l5b34adb1ofb8a972318ebe353@mail.gmail.com>
	(Floris Kraak's message of "Thu, 5 Feb 2009 11:15:12 +0100")
Message-ID: <jeab91w54x.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Floris Kraak <randakar@gmail.com> writes:

> Example:
>
> kernel/power/main.c:717: warning: format not a string literal and no
> format arguments
>
> This complains about:
> ..
>         if (!rtc) {
>                 printk(warn_no_rtc);
>                 goto done;
>         }
> ..
>
> So what is this "warn_no_rtc" thing?
>
>         static char             warn_no_rtc[] __initdata =
>                 KERN_WARNING "PM: no wakealarm-capable RTC driver is ready\n";

Does it help to make it const?

> That's pretty much GCC failing to recognize that the format is a
> string literal and then complaining that it isn't.

Since it's a non-const variable it cannot be a string literal.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
