Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYDIVze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYDIVze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 17:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYDIVzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 17:55:24 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56525 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752918AbYDIVzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 17:55:23 -0400
Date: Wed, 9 Apr 2008 22:52:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Francis Moreau <francis.moro@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Disk geometry from /sys
Message-ID: <20080409225207.732faa4e@core>
In-Reply-To: <20080409212840.GB2160@csclub.uwaterloo.ca>
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
	<20080409212840.GB2160@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why do you want to know what cylinder size the hard disk pretents to
> have?  What use could it be?  Harddisks have varying numbers of sectors

It matters on a CHS addressed device - vaguely.

> drive.  All that matters on a modern drive is the total number of
> sectors since all access is done by requesting a specific sector number
> starting from the begining of the drive.  Where it is physically located
> is none of software's business, and it may not even be adjacent to the
> sector with a number right next to the requested one due to defect
> management and various optimizations.

And some other OS's make certain assumptions about layout that must agree
with that OS view of the disk. A good general rule is to believe the
partition table information if present and if not use SG_IO to issue an
IDENTIFY to any ATA or CFA drive to see how it has mapped the device.

Even better make use fo the existing tools whenever possible - disk
partitioning is more like magic than science

Alan
