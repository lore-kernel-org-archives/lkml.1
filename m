Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbZDPQi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbZDPQi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbZDPQin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:38:43 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:57906 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128AbZDPQim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:38:42 -0400
Date: Thu, 16 Apr 2009 17:38:36 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: BUG: using rootfstype=ext4 causes oops
Message-ID: <20090416163835.GB433@sucs.org>
References: <20090415205926.GA28246@sucs.org> <20090416041945.GK21586@mit.edu> <20090416104758.GA433@sucs.org> <20090416145357.GM21586@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416145357.GM21586@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 10:53:57AM -0400, Theodore Tso wrote:
> OK, can you confirm that you tried using ext4 with either 2.6.29 or
> 2.6.28, and it was working previously?  That would make it a
> regression which Rafael would track.

I've tested this with a local GFS2 mount (which uses barriers too) and
the same bug occurs. Apologies for making it seem like an ext4 bug.  I'm
currently waiting for a kernel to build with Bartlomiej's patch so we'll
see how that goes.

> Also, I'd suggest sending Bartolmiej details about what IDE controller
> you have (the dmesg during a boot under ext3 or ext4 w/ barrier=0
> would also be useful), so he can track it down.  It might be specific
> to a particular IDE controller/device, and not be a generalized IDE
> problem, after all.

00:0f.1 IDE interface [0101]: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571] (rev 06) (prog-if 8a [Master SecP PriP])
        Subsystem: ASUSTeK Computer Inc. A7V600/K8V-X/A8V Deluxe motherboard [1043:80ed]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 20
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
        Region 4: I/O ports at fc00 [size=16]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: VIA_IDE

> Anyway, I'll hand this bug off to Raefael's and/or Bartlomiej's very
> capable hands, since I suspect you could also reproduce this using
> rootfstype=ext3 rootfsflags=barrier=1, and that this is purely an IDE
> driver problem.

Thanks Ted.

> P.S.  Where in the documentation file do we have the mount option as
> "barriers=0".  I went looking for it, and I couldn't find it.  What I
> see is:
> <snip>

Further up in that file in the last paragraph of the 'Quick usage
instructions' it says:

[...]
'-o barriers=[0|1]' mount option for both ext3 and ext4 filesystems
[...]

(I searched the file for barrier and it was the first chunk of text
which matched.)

--
Andrew Price
