Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYLCRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYLCRxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 12:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYLCRxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 12:53:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38027 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751751AbYLCRxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:53:05 -0500
Date: Wed, 3 Dec 2008 17:52:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Pavel Machek <pavel@suse.cz>, Theodore Tso <tytso@mit.edu>,
       Chris Friesen <cfriesen@nortel.com>,
       kernel list <linux-kernel@vger.kernel.org>, aviro@redhat.com
Subject: Re: writing file to disk: not as easy as it looks
Message-ID: <20081203175223.5694ca76@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0812031754040.25439@artax.karlin.mff.cuni.cz>
References: <20081202094059.GA2585@elf.ucw.cz>
	<20081202140439.GF16172@mit.edu>
	<20081202152618.GA1646@ucw.cz>
	<20081202163720.GB18162@mit.edu>
	<49356EF2.7060806@nortel.com>
	<20081202205558.GD20858@mit.edu>
	<20081202224403.GA8277@elf.ucw.cz>
	<20081203050709.GL20858@mit.edu>
	<20081203084639.GB1944@ucw.cz>
	<Pine.LNX.4.64.0812031637050.5406@artax.karlin.mff.cuni.cz>
	<20081203155449.6ea98768@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0812031754040.25439@artax.karlin.mff.cuni.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> error reported for one filesystem may belong to the data written by other 
> filesystem. So should some flag "there was an error" be set for all 
> partitions and report it to every filesystem when it does cache flush? Or 
> record the time of the last error in the driver and let the filesystem 
> query it (so that the filesystem can tell if the error happened before or 
> after it was mounted).

Good question - not working that high up the stack I don't know the right
answer there.
> 
> BTW. how does SCSI report cache flush errors? Does it report them on 
> SYNCHRONIZE CACHE command or does it report them on defered senses?

Not sure. I thought the same way.

> Another point is that unless the sector remap table is full, there should 
> be no cache flush errors.

You can get them on partial writes to large sector devices, assorted
errors on SSD devices and various 'catastrophic' errors.

> I meant for example loose cable or so --- does it make sense to retry 
> indefinitely (until the admin plugs the cable or unmounts the filesystem) 
> or return error to the filesystem after few retries?

At the low level we have to return an error so that RAID and the like can
work.

Alan
