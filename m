Return-Path: <linux-kernel-owner+w=401wt.eu-S965305AbXBLS4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965305AbXBLS4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbXBLSz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:55:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54717 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965305AbXBLSz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:55:58 -0500
Date: Mon, 12 Feb 2007 19:08:35 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Martin A. Fink" <fink@mpe.mpg.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Message-ID: <20070212190835.20f9b92f@localhost.localdomain>
In-Reply-To: <200702121856.29729.fink@mpe.mpg.de>
References: <200702121502.17130.fink@mpe.mpg.de>
	<200702121727.17108.fink@mpe.mpg.de>
	<p731wkvi5go.fsf@bingen.suse.de>
	<200702121856.29729.fink@mpe.mpg.de>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Feb 2007 18:56:29 +0100
"Martin A. Fink" <fink@mpe.mpg.de> wrote:

> I have to store big amounts of data coming from 2 digital cameras to disk. 
> Thus I have to write blocks of around 1 MB at 30 to 50 frames per second for 
> a long period of time. So it is important for me that the harddisk drive is 
> reliable in the sense of "if it is capable of 50 MB/s then it should operate 
> at this speed. Constantly."

Hard disks don't do this. They support operations/second based upon
physical and rotational latency constraints, vibration levels, mechanism,
internal layout policy and the need to do housekeeping. 

If you have an ATA7 drive with suitable firmware sets you can talk to it
directly via the SG_IO interface and use the streaming feature set which
is quite different to filesystem type operations and lets you ask the
drive to do this sort of stuff - if you can find any general PC firmware
ones that support it anyway.

I'm not sure you'll get 50MB/sec sustained to work although you might
with a good current drive used for nothing else, a linear stream of data
(no seeking and file system overhead), and a non PCI controller (PCI
Express, host chipset bus etc). 

If you are using a file system then the more you fsync the more I'd
expect you to see stalling as you keep draining whats effectively an 8MB
plus pipeline on a modern drive precisely because fsync does "hitting
disk" guarantees. You also want to be sure you are not journalling data.

Alan


