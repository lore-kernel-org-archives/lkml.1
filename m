Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018AbYE2Is6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018AbYE2Is6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbYE2Isv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:48:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbYE2Isu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:48:50 -0400
Date: Thu, 29 May 2008 01:47:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Tim Waugh <tim@cyberelk.net>, Tim Waugh <twaugh@redhat.com>,
       linux-parport@lists.infradead.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PARIDE] Datastor EP-2000 problem
Message-Id: <20080529014758.b750002e.akpm@linux-foundation.org>
In-Reply-To: <483DF32B.40508@keyaccess.nl>
References: <483DF32B.40508@keyaccess.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 02:04:59 +0200 Rene Herman <rene.herman@keyaccess.nl> wrote:

> Good day.
> 
> Dug up a parallel port CD-RW consisting of a Philips CDD3801 24x/2x/2x 
> ATAPI CD-RW hooked up to a Datastor EP-2000 parallel interface chip.
> 
> The drive has been verified to work correctly when used directly as IDE 
> and the parallel interface has been verified to work correctly with some 
> random other CD-ROM drive. The combination bombs out though.
> 
> The drive is found:
> 
> root@ax6bc:~# modprobe dstr
> root@ax6bc:~# modprobe pcd
> root@ax6bc:~# dmesg | tail -6
> pcd: pcd version 1.07, major 46, nice 0
> pcd0: Sharing parport0 at 0x378
> pcd0: dstr 1.01, DataStor EP2000 at 0x378, mode 4 (EPP-32), delay 1
> pcd0: Master: R/RW 2x2x24
> pcd0: mode sense capabilities completion: alt=0x51 stat=0x51 err=0x60 
> loop=0 phase=3
> pcd0: mode sense capabilities: Sense key: 6, ASC: 29, ASQ: 0
> 
> trying to extract any data from it fails though:
> 
> root@ax6bc:~# dd if=/dev/pcd0 of=/dev/null bs=2048 count=1
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 12.5765 s, 0.0 kB/s
> 
> root@ax6bc:~# dmesg | tail -14
> pcd: pcd version 1.07, major 46, nice 0
> pcd0: Sharing parport0 at 0x378
> pcd0: dstr 1.01, DataStor EP2000 at 0x378, mode 4 (EPP-32), delay 1
> pcd0: Master: R/RW 2x2x24
> pcd0: mode sense capabilities completion: alt=0x51 stat=0x51 err=0x60 
> loop=0 phase=3
> pcd0: mode sense capabilities: Sense key: 6, ASC: 29, ASQ: 0
> pcd0: WARNING: ATAPI phase errors
> pcd0: Stuck DRQ
> pcd0: lock door before command: alt=0x58 stat=0x58 err=0x100 loop=64001 
> phase=2
> pcd0: Request sense before command: alt=0x58 stat=0x58 err=0x100 
> loop=64001 phase=2
> pcd0: generic packet before command: alt=0x58 stat=0x58 err=0x100 
> loop=64001 phase=2
> pcd0: Request sense before command: alt=0x58 stat=0x58 err=0x100 
> loop=64001 phase=2
> pcd0: unlock door before command: alt=0x58 stat=0x58 err=0x100 
> loop=64001 phase=2
> pcd0: Request sense before command: alt=0x58 stat=0x58 err=0x100 
> loop=64001 phase=2
> 
> and at this point the drive's stuck and needs a power cycle. I've tried 
> all modes available (4-bit, 8-bit, EPP-8, EPP-16 and EPP-32) and delays 
>   from 0 to 10 and nothing changes behaviour.
> 
> Changing the parallel port type in my BIOS from Normal to EPP to ECP to 
> ECP+EPP, no change.
> 
> Behaviour was also the same with the drive's original firmware (which I 
> can sort of guarentee was the one it originally came with) and its 
> current most recent 1.7e firmware.
> 
> I even tested a prehistoric 2.2.6 kernel where things were/are the same 
> again.
> 
> As said, interface works with a different (CD-ROM) drive and drive works 
> fine as plain IDE. I haven't been able to test if it works correctly 
> under DOS or Windows with its own drivers as I don't have the drivers 
> and can't find them online. If anyone has DOS or Windows EP-2000 
> drivers; a pointer would be mightely appreciated.
> 
> Anyone any idea what this could be? Can patch/debug...
> 

I don't know of anyone who is likely to investigate this, sorry.  All I
can suggest is that you file it at bugzilla.kernel.org and be very
patient :(
