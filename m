Return-Path: <linux-kernel-owner+w=401wt.eu-S1753637AbZKOURG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbZKOURG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 15:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbZKOURF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 15:17:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46409 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753531AbZKOURE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 15:17:04 -0500
Date: Sun, 15 Nov 2009 20:18:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?UHJ6ZW15c8WCYXcgUGF3ZcWCY3p5aw==?= 
	<przemyslaw@pawelczyk.it>
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: consolechars switches tty since 8b92e87 vt: add an event 
 interface
Message-ID: <20091115201855.2e046427@lxorguk.ukuu.org.uk>
In-Reply-To: <40e92d5b0911151121l68ef89e5s315b6c2b017bfaad@mail.gmail.com>
References: <40e92d5b0911150530y67878707yed776478a51a34c@mail.gmail.com>
	<20091115170339.59528e49@lxorguk.ukuu.org.uk>
	<40e92d5b0911151121l68ef89e5s315b6c2b017bfaad@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ioctl(3, VIDIOC_G_COMP or VT_ACTIVATE, 0x2) = 0

Switch to VT 2
> ioctl(3, VIDIOC_S_COMP or VT_WAITACTIVE, 0x2) = 0

Wait for VT 2 to activate

> ioctl(3, PIO_UNIMAPCLR, 0x7fff042a0160) = 0
> ioctl(3, PIO_UNIMAP, 0x7fff042a0730)    = 0

Set maps

> ioctl(3, VIDIOC_G_COMP or VT_ACTIVATE, 0x1) = 0

Switch back to VT 1

> ioctl(3, VIDIOC_S_COMP or VT_WAITACTIVE, 0x1) = 0

Wait for VT1 to activate.

Nothing odd there, definitely looks like a kernel problem.

> I have one thing to add. It looks like that is not fully deterministic
> behavior, at least not at f278a2f^ I'm using now. Occasionally tty
> isn't switched. I wasn't aware of this before.

The console switch is asynchronously handled so a race or a bug in the
handling of the event wait which is what I suspect would indeed show up
that behaviour. X and other apps don't do sudden fast switch and switch
backs which would hide such a bug.
 
> I just booted that f278a2f^ (i.e. 569ec4c) while consolechars were
> limited only to console-setup script, but this time tty1 remained on
> the screen and I didn't get "INIT: open(/dev/console): Input/output
> error" I was seeing before. I'm not sure whether it is relevant here.

The I/O error is a different bug (technically a user space one), but the
new behaviour was different, not at all expected and was fixed back to
the old sane behaviour.
