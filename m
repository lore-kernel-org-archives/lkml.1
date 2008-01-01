Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYAACOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYAACOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbYAACIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:08:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54338 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754633AbYAACIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:08:42 -0500
Date: Tue, 1 Jan 2008 01:58:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linda Walsh <lkml@tlinx.org>
Cc: Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
Message-ID: <20080101015812.59e9ebf0@the-village.bc.nu>
In-Reply-To: <4779870E.5070507@tlinx.org>
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>
	<4777E08C.4000603@shaw.ca>
	<4779870E.5070507@tlinx.org>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> rate began falling and at 128k block-reads-at-a-time or larger, it drops 
> below
> 20MB/s (again, only on buffered SATA).   It's hard to imagine what would
> slow down buffered SATA reads but not ATA and SCSI reads of the same
> size.  I'm using the 'cfq' scheduler with everything running at default

Try disabling NCQ - see if you've got a drive with the 'NCQ = no
readahead' flaw.

> priorities, but again, why only SATA slowness?  It seems that at the driver
> level, using direct reads, the SATA disk has the highest read rate (near
> 80MB/s). 

Beats me - something is wrong that your setup triggers - could be
firmware funnies or Linux ones. 

>     The only way I could tell before was using hdparm to read the 
> parameters.
> Since that doesn't work, it's hard to tell if they are set correctly, 
> but given

hdparm supports identify to read modes on drives with libata. The one
thing you cannot do is force modes right now.

>     More importantly, how does one set parameters for acoustic and power
> saving parameters?  Some of my disks are used as 'backup' devices for my

hdparm or blktool

> other computers.  With the ATA disks, they were kept "spun down" when not
> being used (only used, 'normally', in early AM hours).

Well for backup devices you can use the fact SATA is hot/warm plug.

>     Another new "problem" (not as important) -- even though SATA disks are
> called with "sdX", my ATA disks that *were* at hda-hdc are now at hde-hdg.

NOTABUG - your BIOS has decided to move them from the legacy addresses so
they move from hda-d to e-g.

