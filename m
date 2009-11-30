Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZK3Xzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZK3Xzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbZK3Xzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:55:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38030 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752596AbZK3Xzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:55:31 -0500
Date: Mon, 30 Nov 2009 23:57:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: bluetooth cf slow (10KB/sec), lots of dmesg spam
Message-ID: <20091130235739.6dfa3d66@lxorguk.ukuu.org.uk>
In-Reply-To: <20091129164450.GA1438@ucw.cz>
References: <20091129155801.GA1634@ucw.cz>
	<20091130153915.0a6910e3@lxorguk.ukuu.org.uk>
	<20091129164450.GA1438@ucw.cz>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ioctl(3, SNDCTL_TMR_START or TCSETS, {B921600 -opost -isig -icanon -echo ...}) = 0

It's certainly trying
> 
> ...set 921K using TCSETS/B921600... and kernel says ok, but ...

Careful: termios is one of those "gotcha" ioctls. It returns 0 to say
"stuff happened" and returns a termios struct which contains the results
- which may not be what you requested.

So a set to an unsupported rate (too high for the chip clock) will
produce a response of 0 and return the baud rate you actually got given.

> ...we are still at 115200... I wonder if 921600 is the right speed to
> use after all? Any other speeds I should try? (and can 400MHz arm
> handle 921K on serial line?)

It's pushing it on an x86 with a 16550A. You've got about 14 character
times of worst case latency permitted and 14 x 10 bits isn't a lot at
that rate. Some of the clones have much bigger FIFOs so it may depend
what you actually have.

Alan
