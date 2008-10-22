Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbYJVKIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbYJVKIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYJVKIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:08:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:54042 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbYJVKIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:08:13 -0400
Message-ID: <48FEFB65.3090902@windriver.com>
Date: Wed, 22 Oct 2008 05:07:33 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: kgdb 2.6.28 merge plans
References: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com><20081021234911.3813f17d@lxorguk.ukuu.org.uk><48FE8B6F.3050406@windriver.com> <20081022093413.23245ab6@lxorguk.ukuu.org.uk>
In-Reply-To: <20081022093413.23245ab6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Oct 2008 10:07:32.0796 (UTC) FILETIME=[FFE23FC0:01C9342D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>       tty: Fix sparse static warning for tty_driver_lookup_tty
>>       kgdboc, tty: Add the rx polling call back capability
>>       kgdboc, 8250: rx polling hook for the 8250 driver
>>       kgdboc, amba-pl011: rx polling hook for the amba-pl011 driver
>
> NAK.

The kgdb merge request queue has had any serial and tty changes
removed.

The only changes that remain are to the kgdb core for the
purpose of moving the blackfin off its existing kgdb stub over to the
common kgdb core API.

>
> In addition to which random hooks in random mixtures of uart drivers are
> not a practical sensible way to manage general purpose interfaces to
> debug tools.
>

This is a discussion that needs to be hashed out.  It is a question of
where would you like it discussed (IE: new thread in lmkl,
linux-serial@...)?

It is a discussion more about general polled vs interrupt driven
serial/tty APIs, not all of which are used for debuggers.  I am open
to help fix/change/extend/refactor the existing kernel's CONSOLE_POLL
API or even deprecate it in favor of something else so long as it
leads to an interface which can allow the sharing of the hardware
among various contexts with early_printk, console, tty, debugger,
etc...

If it was all obvious and easy, it would have already been done.  Rome
was not built in a day after all. :-)

Cheers,
Jason.
