Return-Path: <linux-kernel-owner+w=401wt.eu-S1763024AbZJOVFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763024AbZJOVFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758665AbZJOVFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:05:22 -0400
Received: from foo.birdnet.se ([213.88.146.6]:35190 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758389AbZJOVFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:05:21 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Oct 2009 17:05:21 EDT
Message-ID: <20091015205803.30544.qmail@stuge.se>
Date: Thu, 15 Oct 2009 22:58:03 +0200
From: Peter Stuge <peter@stuge.se>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Hardware initialization in line discipline - ldisc_open() ?
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm writing a line discipline for a serial port multiplexing hardware
which turns one "upstream" serial port into 0-8 slower "downstream"
serial ports, according to the number of modules installed on the
multiplexer.

The attaching program transfers no data on the upstream port, all
data will be to/from the ldisc itself, or to/from the downstream
ports.

To know which modules are installed, and their configuration, the
ldisc needs to perform a handshake using the same packet format as
downstream port data transfers.

It would be nice to do this handshake in ldisc_open() so that the
attach can fail if the hardware is not responding or just not
connected.

Since the packet format is the same it would be easy to reuse the
normal ldisc receive path for the handshake, however the ldisc would
not see the response until after ldisc_open() has succeeded.
Catch-22!

I'm hoping to use ldattach for attaching the ldisc because it's nice
to have a standard utility, because it's nice to not duplicate the
packet formatting/parsing code, and because the ldisc has to know
which modules are installed in the hardware anyway, to create the
correct downstream ports.

Can you suggest a solution to this problem? Ideally one that can be
contained in the ldisc.


Thanks

//Peter
