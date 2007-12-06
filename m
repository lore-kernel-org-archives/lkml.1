Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbXLFMFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbXLFMFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbXLFMFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:05:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255AbXLFMF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:05:29 -0500
Date: Thu, 6 Dec 2007 04:04:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: 2.6.24-rc4-mm1
Message-Id: <20071206040420.6c89c675.akpm@linux-foundation.org>
In-Reply-To: <3941.1196941764@turing-police.cc.vt.edu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<3941.1196941764@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Dec 2007 06:49:24 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 04 Dec 2007 21:17:01 PST, Andrew Morton said:
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/
> 
> Something in here broke LVM support - an initrd that has worked fine for
> quite some time suddenly couldn't mount /dev/VolGroup00/root so we get the
> infamous "Kernel panic - not syncing: Attempted to kill init!" when we
> fall off the end of the initrd and haven't pivoted to the real disk.
> 
> It finds the disk OK:
> 
> [   81.202310] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> [   81.214466] sd 0:0:0:0: [sda] Write Protect is off
> [   81.226467] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   81.238436] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   81.250780]  sda: sda1 sda2
> [   75.396119] sd 0:0:0:0: [sda] Attached SCSI disk
> 
> but then the lvm command says it can't find the volume group VolGroup00 (which
> is actually sda2 - sda1 is a small /boot partition, rest of disk is LVM).
> 
> A quick look at the rc4-mm1 announcement doesn't have any obviously tempting
> patch names to start at, so it looks like it's time to play mm-bisect.  It may
> take me a day or two, as I have some time management issues this week...
> 

OK, thanks.

First step would be to eliminate rewrite-rd.patch: maybe the ramdisk driver
in which that initrd resides is bust.

After that, agk-dm-dm-*.patch are of course the ones to look at.

Please keep dm-devel@redhat.com cc'ed.
