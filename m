Return-Path: <linux-kernel-owner+w=401wt.eu-S1031260AbXD1UUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031260AbXD1UUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031203AbXD1UUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:20:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35279 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbXD1UUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:20:33 -0400
Date: Sat, 28 Apr 2007 21:24:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: Flaws with "UIO: Add the User IO core code" (with patch)
Message-ID: <20070428212416.5768cc04@the-village.bc.nu>
In-Reply-To: <200704282052.45489.hjk@linutronix.de>
References: <20070427224957.GA17967@kroah.com>
	<11777142582534-git-send-email-gregkh@suse.de>
	<20070428001923.15074234@the-village.bc.nu>
	<200704282052.45489.hjk@linutronix.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > AFAIK we don't currently have any platform that runs binaries with
> > different sizes of "int" but this is a) an unsigned value anyway, and b)
> > should be a fixed type (eg u32)
> 
> I reviewed the code once more and find it OK. There is only one legal
> value for the parameter "count" of uio_read(), and that's sizeof(int).

If you are a box with multiple supported binary types how big is an
"int". We use explicit sizes to ensure that uio_read() will work when/if
we get platforms which support binaries with differing ideas of the size
of "int". Thus it should use s32 or s64 or similar.

> The data that is actually read is the element "event" of struct uio_device,
> which is of type atomic_t. The latter has the size of an int.

The latter is the size of a kernel "int".

Other patch looks fine.
