Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbZJ1R7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbZJ1R7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZJ1R7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:59:35 -0400
Received: from foo.birdnet.se ([213.88.146.6]:53469 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751645AbZJ1R7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:59:35 -0400
Message-ID: <20091028175937.27472.qmail@stuge.se>
Date: Wed, 28 Oct 2009 18:59:37 +0100
From: Peter Stuge <peter@stuge.se>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>
Subject: Dropped characters in serial connection without flow control
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Stuge wrote:
> I'm writing a line discipline for a serial port multiplexing
> hardware

There is no(!) support for flow control in the hardware.

Is there anything I can do to reduce serial port interrupt latency or
otherwise try to mitigate this in my ldisc or in Linux in general? I
realize that it will never be quite reliable without any flow
control.

Baud rate is currently 115200 but could become 57600.

Is there something in particular that I can do wrong or right in
the ldisc?

Might it be a good idea to add a circ_buf in the receiver path and
move out any and all attempts at parsing incoming data? Currently
it has a simple message buffer and a state machine in there.

Characters are dropped both going out and coming in. Nothing to do
about the out direction, but maybe input can be made reliable?

I don't expect it, but maybe you know a trick?


//Peter
