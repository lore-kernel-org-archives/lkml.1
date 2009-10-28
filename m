Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZJ1SPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZJ1SPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZJ1SPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:15:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34404 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753182AbZJ1SPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:15:17 -0400
Date: Wed, 28 Oct 2009 18:16:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Stuge <peter@stuge.se>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: Dropped characters in serial connection without flow control
Message-ID: <20091028181659.5a97daab@lxorguk.ukuu.org.uk>
In-Reply-To: <20091028175937.27472.qmail@stuge.se>
References: <20091028175937.27472.qmail@stuge.se>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no(!) support for flow control in the hardware.

So do XON/XOFF ?

> Is there anything I can do to reduce serial port interrupt latency or
> otherwise try to mitigate this in my ldisc or in Linux in general? I
> realize that it will never be quite reliable without any flow
> control.
> 
> Baud rate is currently 115200 but could become 57600.

The core tty buffering code tops out at about 40Mbits on a decent PC
system so you shouldn't be seeing problems from that. Our internal
buffering is about 64K which at 115200 is actually over 5 seconds.

> Is there something in particular that I can do wrong or right in
> the ldisc?
> 
> Might it be a good idea to add a circ_buf in the receiver path and
> move out any and all attempts at parsing incoming data? Currently
> it has a simple message buffer and a state machine in there.

ldisc processing is not done in the receiver path

> Characters are dropped both going out and coming in. Nothing to do
> about the out direction, but maybe input can be made reliable?
> 
> I don't expect it, but maybe you know a trick?

Without knowing more about the hardware and the code and the like its a
bit tricky to even guess what your problems are.
