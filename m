Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXD1Ugd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXD1Ugd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbXD1Ugd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:36:33 -0400
Received: from www.osadl.org ([213.239.205.134]:60934 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752440AbXD1Ugb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:36:31 -0400
Subject: Re: Flaws with "UIO: Add the User IO core code" (with patch)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, Benedikt Spranger <b.spranger@linutronix.de>
In-Reply-To: <20070428212416.5768cc04@the-village.bc.nu>
References: <20070427224957.GA17967@kroah.com>
	 <11777142582534-git-send-email-gregkh@suse.de>
	 <20070428001923.15074234@the-village.bc.nu>
	 <200704282052.45489.hjk@linutronix.de>
	 <20070428212416.5768cc04@the-village.bc.nu>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 22:38:35 +0200
Message-Id: <1177792715.7646.300.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 21:24 +0100, Alan Cox wrote:
> > > AFAIK we don't currently have any platform that runs binaries with
> > > different sizes of "int" but this is a) an unsigned value anyway, and b)
> > > should be a fixed type (eg u32)
> > 
> > I reviewed the code once more and find it OK. There is only one legal
> > value for the parameter "count" of uio_read(), and that's sizeof(int).
> 
> If you are a box with multiple supported binary types how big is an
> "int". We use explicit sizes to ensure that uio_read() will work when/if
> we get platforms which support binaries with differing ideas of the size
> of "int". Thus it should use s32 or s64 or similar.

Well, it is kind of academic, as probably half of the user space
interfaces will explode, but in theory you are right.

Hans, let's change it to u32 to get this out of the way.

	tglx


