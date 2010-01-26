Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504Ab0AZCME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0AZCME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325Ab0AZCMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:12:01 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54307 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753320Ab0AZCMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:12:00 -0500
Date: Tue, 26 Jan 2010 02:13:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: William Hubbs <w.d.hubbs@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, gregkh@suse.de,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Chris Brannon <cmbrannon79@gmail.com>, Kirk Reiser <kirk@reisers.ca>
Subject: Re: request for assistance:  accessing ttys from kernel space
Message-ID: <20100126021306.16809e71@lxorguk.ukuu.org.uk>
In-Reply-To: <20100126020203.GA23551@linux1>
References: <20100126020203.GA23551@linux1>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently, speakup is using direct hardware access to communicate with
> serial ports.  Doing so, however, has limitations since we are hard
> coding port addresses and IRQ numbers.  For example, we have a user

I pointed this out several years ago

> What I would like to discuss is how we can access ttys from kernel
> space.  If we could do this, it would definitely make things much easier
> for us in speakup.

Basically - use a line discipline, that lets you sit on top of a tty and
interact with the hardware

> We need to be able to access the ttys as early as possible in the boot
> sequence.  Any help, suggestions, or guidance you could give us would be
> greatly appreciated.

We may need to make some special provision for that aspect - we already
do so for the early serial console support. The ldisc is the start point
then there may be some bits that need to be extended around it.

A bigger problem is going to be the fact non USB serial is vanishing bit
by bit. We do have a USB console but it's truely crazy stuff and
extending it scares me 8)
