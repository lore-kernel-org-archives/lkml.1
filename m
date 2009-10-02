Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZJBJvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZJBJvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbZJBJvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:51:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37961 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757418AbZJBJvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:51:46 -0400
Date: Fri, 2 Oct 2009 10:53:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
Message-ID: <20091002105314.33d54bc5@lxorguk.ukuu.org.uk>
In-Reply-To: <20091002100430.58785957@lxorguk.ukuu.org.uk>
References: <20090924154023.GA27480@localhost>
	<200909242103.48562.oliver@neukum.org>
	<20090924202107.4730f2af@lxorguk.ukuu.org.uk>
	<20090924211459.GB27963@localhost>
	<4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
	<20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
	<m163ayzevu.fsf@fess.ebiederm.org>
	<20091002100430.58785957@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having had a look through the driver someone with docs or similar needs
to explain how the ftdi_sio does hardware and software flow control. It
has throttle/unthrottle methods but these just stall the URB queuing and
don't do any flow processing of their own at all. Does the ftdi_sio do
this in hardware when the urbs run low ?

Otherwise it can certainly be simplified a lot. In particular at the
point you get throttle event you've got about 64K of cushion to react
(flow control being async anyway) and you actually *want* to pull data
after you whack the modem lines because the other end also has a latency
to respond.

So all the clever partial processing of urb stuff is overkill. Whether it
needs not to repost urbs to the device or to implement flow control in
software I don't know without docs.

With that done the driver ought to be a good deal easier to debug.

Alan
