Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbYADLbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbYADLbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYADLbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:31:22 -0500
Received: from aun.it.uu.se ([130.238.12.36]:52060 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYADLbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:31:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18302.5940.173422.967902@harpo.it.uu.se>
Date: Fri, 4 Jan 2008 12:23:32 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Linda Walsh <lkml@tlinx.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, LKML <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockr@shaw.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org
Subject: Re: Re:Believed resolved: SATA kern-buffRd read slow: based on promise
 driver bug
In-Reply-To: <477D9C00.8060600@tlinx.org>
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>
	<4777E08C.4000603@shaw.ca>
	<4779870E.5070507@tlinx.org>
	<20080101015812.59e9ebf0@the-village.bc.nu>
	<477BEF8D.8090307@tlinx.org>
	<477C2B71.7040504@shaw.ca>
	<477C63AA.8080006@tlinx.org>
	<18300.40661.199761.488061@harpo.it.uu.se>
	<477D9C00.8060600@tlinx.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh writes:
 > Mikael Pettersson wrote:
 > > Linda Walsh writes:
 > >  > Robert Hancock wrote:
 > >  > > Linda Walsh wrote:
 > >  > >>>> read rate began falling; at 128k block-reads-at-a-time or larger, it 
 > >  > >>>> drops below 20MB/s (only on buffered SATA).
 > >  > 
 > >  > But more importantly -- I notice a chronic error message associate
 > >  > with this drive that may be causing some or all of the problem:
 > >  > ---
 > >  > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
 > >  > ata1.00: port_status 0x20080000
 > >  > ata1.00: cmd c8/00:10:30:06:03/00:00:00:00:00/e0 tag 0 cdb 0x0 data 8192 in
 > >  >          res 50/00:00:3f:06:03/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
 > >  > ata1: limiting SATA link speed to 1.5 Gbps
 > >
 > >
 > > Looks like the Promise ASIC SG bug. Apply
 > > <http://user.it.uu.se/~mikpe/linux/patches/sata_promise/patch-sata_promise-1-asic-sg-bug-fix-v3-2.6.23>
 > > and let us know if things improve.
 > >
 > > /Mikael
 > >   
 > ---
 >     Yep!  Hope that's making it into a patch soon or, at least 2.6.24.
 >     Kernel buffered

Good to hear that it solved this problem.
The patch is in 2.6.24-rc2 and newer kernels, and will be sent
to -stable for the 2.6.23 and 2.6.22 series.

 >     I seem to remember reading about some problems with Promise SATA & ACPI.
 > Does this address that or is that a separate issue?  (Am using no-acpi for

sata_promise does nothing ACPI-related. It doesn't need to.
(Drives may be a different story.)

 >     Is the above bug mentioned/discussed in the linux-ide archives?

Yes.

 >  That
 > and I'd like to find out why TCQ/NCQ doesn't work with the Seagate drives --

The driver doesn't yet support NCQ.
