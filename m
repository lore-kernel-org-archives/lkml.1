Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZHBWs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZHBWs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 18:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZHBWs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 18:48:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46691 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750718AbZHBWs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 18:48:26 -0400
Date: Sun, 2 Aug 2009 23:48:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
Message-ID: <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
References: <20090802120120.GA3097@localdomain.by>
	<alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
	<20090802190514.GA3278@localdomain.by>
	<alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
	<87k51l9apo.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's just a classic example of some of the crazy hacks we have in the 
> tty layers. I do wonder whether it's even necessary any more. Maybe we 
> could just hang things up forcefully now and get rid of that console 
> handling special case.
> 
> But I guess that all does explain why it only happens in single-user mode. 
> 
> So exactly what _does_ happen if we get rid of that hack?

Serial console breaks if I remember rightly because the hangup takes out
the port and printk can't then use the resources that were attached to
it.

redirected_tty_write should I think count for the redirection to
hung_up_tty_fops, but I'm not sure you want to do the hangup instead of
close.

You could just finish the ldisc refcounting. The last set of patches you
had off me split tty->ldisc from struct tty ready to do exactly that and
I don't think there is anything left that stops it happening now (It was
just not ready in time)

