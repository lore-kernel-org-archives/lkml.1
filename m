Return-Path: <linux-kernel-owner+w=401wt.eu-S1751323AbZJFERK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbZJFERK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 00:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbZJFERJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 00:17:09 -0400
Received: from trinity.develer.com ([83.149.158.210]:48273 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZJFERI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 00:17:08 -0400
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
From: Bernie Innocenti <bernie@codewiz.org>
To: Mark Lord <liml@rtr.ca>
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       sysadmin <sysadmin@gnu.org>
In-Reply-To: <4ACA6904.1060509@rtr.ca>
References: <1254546642.1438.135.camel@giskard>  <4ACA6904.1060509@rtr.ca>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Sugar Labs - http://www.sugarlabs.org/
Date: Tue, 06 Oct 2009 00:16:25 -0400
Message-Id: <1254802585.1471.21.camel@giskard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Mon, 05-10-2009 a las 17:45 -0400, Mark Lord escribió:
>   0x30000040 here means "MRdPerr":
>     "bad data parity detected during PCI master read".
> 
> Which means there that a data parity error happened
> during outgoing data transfer on the PCI-X bus.
> This could happen due to noise on the bus,
> dying capacitors, or (?) bad RAM (not sure about the last one).

Oddly, we see this on two different machines.  And only on specific
ports of the second controller card.

On one of these machines, we've also found a bunch of MCEs related to
ECC errors, but we were unable to reproduce them by exercising the CPU
and the bus with tools like cpuburn or md5sum of entire drives.

The other one has been running for 2 days with no errors whatsoever.
Bother have successfully completed a 24h cycle of memtest86+.


> The expected behaviour here is for sata_mv to then perform
> perform a full SATA reset, after which the I/O will be reattempted.
>
> But it appears to lock up before that happens.
> The code does try and clear the PCI error interrupt,
> but perhaps it needs clearing in more than the one register
> where it currently does so.

I've got a few of these recoverable errors overnight (perhaps along with
the MCE errors I described above).  The bus was reset as you describe.

The PCI errors seem to cause a system freeze only during RAID
reconstruction. Perhaps the bus reset logic is not sufficiently locked
against re-entrance?


> Looking over the code and the documentation I have (NDA),
> nothing obvious springs to view.  There are some extra registers
> we could be dumping out, to show exactly what PCI phase and address
> caused the error, but reading those won't cause or prevent a lockup.
> 
> Best bet would be to try replacing the RAM in that box,
> and see if the problem goes away.

We'll try this tomorrow, thank you very much for providing these clues.

-- 
   // Bernie Innocenti - http://codewiz.org/
 \X/  Sugar Labs       - http://sugarlabs.org/

