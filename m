Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbYAFUVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbYAFUVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 15:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYAFUVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 15:21:15 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:40792 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbYAFUVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 15:21:14 -0500
Message-ID: <47813835.3020508@tlinx.org>
Date: Sun, 06 Jan 2008 12:21:09 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: Believed resolved: SATA kern-buffRd read slow: based on promise
 driver bug
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>	<4777E08C.4000603@shaw.ca>	<4779870E.5070507@tlinx.org>	<20080101015812.59e9ebf0@the-village.bc.nu>	<477BEF8D.8090307@tlinx.org>	<477C2B71.7040504@shaw.ca>	<477C63AA.8080006@tlinx.org>	<18300.40661.199761.488061@harpo.it.uu.se>	<477D9C00.8060600@tlinx.org> <18302.5940.173422.967902@harpo.it.uu.se>
In-Reply-To: <18302.5940.173422.967902@harpo.it.uu.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Linda Walsh writes:
>  > Mikael Pettersson wrote:
>  > > Linda Walsh writes:
>  > >  > > Linda Walsh wrote:
>  > >  > >>>> read rate began falling; (.25 - .3); 
>  > >  > more importantly; a chronic error message associated
>  > >  > with drive may be causing some or all of the problem(s):
>  > >  > ---
>  > >  > ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
>  > >  > ata1.00: port_status 0x20080000
>  > >  > ata1.00: cmd c8/00:10:30:06:03/00:00:00:00:00/e0 tag 0 cdb 0x0 data 8192 in
>  > >  >          res 50/00:00:3f:06:03/00:00:00:00:00/e0 Emask 0x2 (HSM violation)
>  > >  > ata1: limiting SATA link speed to 1.5 Gbps
>  > >
>  > > Looks like the Promise ASIC SG bug. Apply
>  > > <http://user.it.uu.se/~mikpe/linux/patches/sata_promise/patch-sata_promise-1-asic-sg-bug-fix-v3-2.6.23>
>  > > and let us know if things improve.
>  > > /Mikael
>  > ---
>  >     Yep!  Hope that's making it into a patch soon or, at least 2.6.24.
>  >     Kernel buffered
> Good to hear that it solved this problem.
> The patch is in 2.6.24-rc2 and newer kernels, and will be sent
> to -stable for the 2.6.23 and 2.6.22 series.
>   
---
    Will 'likely' wait till -stable since I use the machine as a 'server'
for just about any/everything that needs "serving" or "proxy" services.
>  >  That and I'd like to find out why TCQ/NCQ doesn't work with the Seagate drives --
>
> The driver doesn't yet support NCQ.
----
    Is 'main' diff between NCQ/TCQ that TCQ can re-arrange 'write'
priority under driver control, whereas NCQ is mostly a FIFO queue?

    On a Journal'ed file system, isn't "write-order" control required
for integrity?  That would seem to imply TCQ could be used, but
NCQ doesn't seem to offer much benefit, since the higher level
kernel drivers usually have a "larger picture" of sectors that need
to be written.  The only advantage I can see for NCQ drives might
be that the kernel may not know the drive's internal physical
structure nor where the disk is in its current revolution.  That could
allow drive write re-ordering where based on the exact-current state
of the drive that the kernel might not have access to, but it seems
this would be a minor benefit -- and, depending on firmware,
possibly higher overhead in command processing?

Am trying to differentiate NCQ/TCQ and SAS v. SCSI benefits.
It seems both support (SAS & SATA) some type of port-multiplier/
multiplexor/ option to allow more disks/port.

However, (please correct?) SATA uses a hub type architecture while
SAS uses a switch architecture.  My experience with network hubs vs.
switches is that network hubs can be much slower if there is
communication contention.  Is the word 'hub' being used in the
"shared-communication media sense", or is someone using the term
'hub' as a [sic] replacement for a 'switch'?




