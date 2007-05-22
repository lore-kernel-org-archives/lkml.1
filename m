Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXEVVSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXEVVSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758188AbXEVVRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:17:53 -0400
Received: from thunk.org ([69.25.196.29]:49150 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902AbXEVVRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:17:53 -0400
Date: Tue, 22 May 2007 14:01:59 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ext3-users@redhat.com
Subject: Re: fs periodic check (was Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted)
Message-ID: <20070522180158.GA4668@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
	Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
	ext3-users@redhat.com
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com> <20070518143529.GB14611@ribosome.natur.cuni.cz> <20070518215731.GB10655@thunk.org> <20070520195526.GA5235@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070520195526.GA5235@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 07:55:26PM +0000, Pavel Machek wrote:
> > #1, This is why periodic checks are a good thing; it catches problems
> > that could stay hidden and result in data loss sooner rather later.
> 
> Actually, I see something funny with periodic checks here. It claims
> 'filesystem check on next boot' for >10 boots now.
> 
> It is sharp zaurus machine, and the filesystem tends to _never_ be
> unmounted correctly (broken scripts), so I get journal replay each
> time.

The Sharp Zaurus is a PDA which is almost always running on battery,
right?   You need to add to /etc/e2fsck.conf:

[options]
	defer_check_on_battery = false

See the e2fsck.conf man page for more details, but basically, e2fsck
was optimized for x86 laptops that have such lousy batttery life that
people generally try to run AC adapters to avoid killing the laptop
battery --- and for which running a spinning hard drive platters for
an extended time to fsck a 100GB drive might not be such a hot idea.
So we try to defer the periodic fsck until the laptop is back on AC
power.  But for a PDA running a flash drive which is almost always
running on battery you'll want to change the default using
e2fsck.conf.

						- Ted

