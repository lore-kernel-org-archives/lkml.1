Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbXKJVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbXKJVFu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 16:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189AbXKJVFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 16:05:43 -0500
Received: from rtr.ca ([76.10.145.34]:2534 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbXKJVFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 16:05:42 -0500
Message-ID: <47361D24.8020708@rtr.ca>
Date: Sat, 10 Nov 2007 16:05:40 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-usb-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       mdharm-usb@one-eyed-alien.net, dbrownell@users.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: USB storage: corrupted data transfers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Something may be broken in USB / usb-storage land.

I've got a 2GB USB stick here.
I want to copy it to an image file on my hard drive:

    cat /dev/sdb > usbkey.image1

Make a second copy, with or without unplugging/replugging the stick:

    cat /dev/sdb > usbkey.image2

After doing this, the two copies *differ*.

So I wrote a little program to compare them and determine *how* they differ,
and the result is very interesting.

Periodically, or or the other file has 8192 *zero* bytes inserted
in place of it's data.   Not replacing it's data, just inserted
into the stream, causing the real data (which follows) to be offset by 8192.

If one skips over the inserted 8192 bytes in the file, the data from that point
onward matches the other file, until another 8192 zeros are encountered.

The total sizes of the two image files match each other,
but that's probably just due to the logic in the 'cat' program.

I wonder where those extraneous pairs of zero pages are coming from?

This makes USB drives somewhat unreliable for backups and the like,
which unfortunately is exactly what just about everybody uses them for.

This (so far) is with 2.6.23.1 (w/slab allocater), and 2.6.24-rc2,
on two different machines (both Intel based, but different chipset, CPU, RAM, ...).

I suspect not all brands/models of USB sticks would give the same results,
but it is rather worrisome that it happens at all.

Mmmmmm  ????
