Return-Path: <linux-kernel-owner+w=401wt.eu-S1763966AbXGFToV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763966AbXGFToV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 15:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbXGFToI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 15:44:08 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:33903 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762135AbXGFToF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 15:44:05 -0400
From: Chr <chunkeey@web.de>
To: "Gaston, Jason D" <jason.d.gaston@intel.com>
Subject: Re: [patch 2.6.22-rc6] ATA: add a PCI ID for Intel Santa Rosa PATA controller
Date: Fri, 6 Jul 2007 21:45:01 +0200
User-Agent: KMail/1.9.7
Cc: "Thorsten Leemhuis" <thl@ct.heise.de>,
       "Thorsten Leemhuis" <fedora@leemhuis.info>,
       "Chuck Ebbert" <cebbert@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <39B20DF628532344BC7A2692CB6AEE070181E0EA@orsmsx420.amr.corp.intel.com>
In-Reply-To: <39B20DF628532344BC7A2692CB6AEE070181E0EA@orsmsx420.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707062145.01928.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX19R1ss8cINt5bBlqNyRcMIN+yqzJuuySN/z59Fb
	50BABM6o0PeupALFwjwgurhJL8E5pD9ACqSwnI3zHRBk8WZurQ
	1Y5/zgWRk=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 6. July 2007, Gaston, Jason D wrote:
> >> > On the other hand, we can leave it, because of a 
> >"off-by-one error" in ata_piix.c, 
> >> > do_pata_set_dmamode, line ~770:
> >> > [...]
> >> 
> >
> >Thanks,
> >	Chr.
> >
> >
> 
> I quickly tried this patch on an ICH7-R system with an ATA133 Maxtor HD
> and it did not seem to do anything bad.  I see no difference in function
> or performance with the patch.
> 
> Jason
> 

Thanks for testing, but you forgot some numbers. ;)
(bonnie++? hdparm -i && hdparm -t...)

Because, I don't think that Maxtor HD's mechanics is faster than 100MB/s.. 
The only thing that can keep up with > 100MB/s are the few MB of Cache on every HDD... 
(so, does anyone have a good idea to check the HDD's cache performance?
hdparm -t reads too much data) 

I came up with something like:
"dd if=/dev/sdX of=/dev/null bs=4M count=1 iflag=direct"

and run it 10 times in a row.

here's a test run with a SATA I WD2500YD-01N ( hdparm -t performance: ~57MB/s)
4194304 bytes (4.2 MB) copied, 0.0897687 seconds, 46.7 MB/s
4194304 bytes (4.2 MB) copied, 0.0776731 seconds, 54.0 MB/s
4194304 bytes (4.2 MB) copied, 0.0711224 seconds, 59.0 MB/s
4194304 bytes (4.2 MB) copied, 0.0679675 seconds, 61.7 MB/s
4194304 bytes (4.2 MB) copied, 0.0603272 seconds, 69.5 MB/s
4194304 bytes (4.2 MB) copied, 0.0543068 seconds, 77.2 MB/s
4194304 bytes (4.2 MB) copied, 0.0522881 seconds, 80.2 MB/s
4194304 bytes (4.2 MB) copied, 0.0520612 seconds, 80.6 MB/s
4194304 bytes (4.2 MB) copied, 0.0444805 seconds, 94.3 MB/s
4194304 bytes (4.2 MB) copied, 0.0338407 seconds, 124 MB/s
4194304 bytes (4.2 MB) copied, 0.0333174 seconds, 126 MB/s 

Thanks,
	Chr
