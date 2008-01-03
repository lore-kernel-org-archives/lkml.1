Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYACIpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYACIpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYACIpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:45:31 -0500
Received: from aun.it.uu.se ([130.238.12.36]:62050 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYACIpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:45:30 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18300.40661.199761.488061@harpo.it.uu.se>
Date: Thu, 3 Jan 2008 09:37:41 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Linda Walsh <lkml@tlinx.org>
Cc: Robert Hancock <hancockr@shaw.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: SATA kernel-buffered read VERY slow (not raid, Promise TX300
 card); 2.6.23.1(vanilla)
In-Reply-To: <477C63AA.8080006@tlinx.org>
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>
	<4777E08C.4000603@shaw.ca>
	<4779870E.5070507@tlinx.org>
	<20080101015812.59e9ebf0@the-village.bc.nu>
	<477BEF8D.8090307@tlinx.org>
	<477C2B71.7040504@shaw.ca>
	<477C63AA.8080006@tlinx.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh writes:
 > Robert Hancock wrote:
 > > Linda Walsh wrote:
 > >> Alan Cox wrote:
 > >>>> rate began falling; at 128k block-reads-at-a-time or larger, it 
 > >>>> drops below
 > >>>> 20MB/s (only on buffered SATA).
 > >>> Try disabling NCQ - see if you've got a drive with the 'NCQ = no
 > >>> readahead' flaw.
 > > http://linux-ata.org/faq.html#ncq
 > ---
 >     When drive initializes, dmesg says it has NCQ (depth 0/32)
 >     Reading the queue_depth under /sys, shows a queuedepth of "1".
 > 
 > But more importantly -- I notice a chronic error message associate
 > with this drive that may be causing some or all of the problem:
 > ---
 > Jan  2 20:06:10 Ishtar kernel: ata1.00: exception Emask 0x0 SAct 0x0 
 > SErr 0x0 action 0x2
 > Jan  2 20:06:10 Ishtar kernel: ata1.00: port_status 0x20080000
 > Jan  2 20:06:10 Ishtar kernel: ata1.00: cmd 
 > c8/00:10:30:06:03/00:00:00:00:00/e0 tag 0 cdb 0x0 data 8192 in
 > Jan  2 20:06:10 Ishtar kernel:          res 
 > 50/00:00:3f:06:03/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
 > Jan  2 20:06:13 Ishtar kernel: ata1: limiting SATA link speed to 1.5 Gbps
 > Jan  2 20:06:13 Ishtar kernel: ata1.00: exception Emask 0x0 SAct 0x0 
 > SErr 0x0 action 0x6
 > Jan  2 20:06:13 Ishtar kernel: ata1.00: port_status 0x20080000
 > Jan  2 20:06:13 Ishtar kernel: ata1.00: cmd 
 > c8/00:10:00:8b:04/00:00:00:00:00/e0 tag 0 cdb 0x0 data 8192 in
 > Jan  2 20:06:13 Ishtar kernel:          res 
 > 50/00:00:0f:8b:04/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
 > Jan  2 20:06:14 Ishtar kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 
 > 0x0 action 0x3
 > Jan  2 20:06:14 Ishtar kernel: ata1: hotplug_status 0x80
 > Jan  2 20:06:15 Ishtar kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 
 > 0x0 action 0x3
 > Jan  2 20:06:15 Ishtar kernel: ata1: hotplug_status 0x80
 > ---
 > What da heck?

Looks like the Promise ASIC SG bug. Apply
<http://user.it.uu.se/~mikpe/linux/patches/sata_promise/patch-sata_promise-1-asic-sg-bug-fix-v3-2.6.23>
and let us know if things improve.

/Mikael
