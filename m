Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbXHIWFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbXHIWFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 18:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbXHIWFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 18:05:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbXHIWFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 18:05:08 -0400
Date: Thu, 9 Aug 2007 15:04:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       "Kristofer T. Karas" <ktk@enterprise.bidmc.harvard.edu>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>
Subject: Re: 2.6.23-rc2-mm1
Message-Id: <20070809150454.42eea7c5.akpm@linux-foundation.org>
In-Reply-To: <46BB88C4.5010107@googlemail.com>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
	<46BB88C4.5010107@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Aug 2007 23:36:04 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:

> 
> ...
> 
> > +pci-align-bar-settings-for-legacy-mode-ide.patch
> > +pci-align-bar-settings-for-legacy-mode-ide-fix.patch
> > 
> >  2.6.23 material, but these belong to subssytem trees
> >
> 
> ...
> 
>  
> These broke the IDE controller , using libata on my Dell Workstation .. 
> 
> Reverting both fixes the problem.
> 
> 
> ..
> 
> [   28.828484] 0000:00:1f.1: cannot adjust BAR0 (not I/O)
> [   28.828487] 0000:00:1f.1: cannot adjust BAR1 (not I/O)
> [   28.828489] 0000:00:1f.1: cannot adjust BAR2 (not I/O)
> [   28.828491] 0000:00:1f.1: cannot adjust BAR3 (not I/O)
> ...
> 
> [   44.564308] ata_piix 0000:00:1f.1: version 2.11
> [   44.564365] ata_piix 0000:00:1f.1: no available native port
> 
> ...
> 
> And my CDROM and second ide disc gone.
> 
> $ lspci -vvvxxx
> 
> ...
> 
> 00:1f.1 IDE interface: Intel Corporation 82801BA IDE U100 Controller (rev 04) (prog-if 80 [Master])
>         Subsystem: Dell Unknown device 00d8
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
>         Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
>         Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
>         Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
>         Region 4: I/O ports at ffa0 [size=16]
> 00: 86 80 4b 24 05 00 80 02 04 80 01 01 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: a1 ff 00 00 00 00 00 00 00 00 00 00 28 10 d8 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 07 e3 03 e3 00 00 00 00 05 00 01 02 00 00 00 00
> 50: 00 00 00 00 50 10 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
>  
> ...
> 
> config is attched.
> 

Great, thanks for working that out.  I'll drop them, thereby breaking other
people's stuff.  This is rather a disaster.


