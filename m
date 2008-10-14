Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbYJNHRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbYJNHRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYJNHRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:17:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:39235 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYJNHRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:17:19 -0400
Message-ID: <48F44706.7060701@kernel.org>
Date: Tue, 14 Oct 2008 16:15:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Peter Alfredsen <loki_val@gentoo.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SATA Burner Pioneer DVR-216-DBK won't burn
References: <200810052005.04920.loki_val@gentoo.org>
In-Reply-To: <200810052005.04920.loki_val@gentoo.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Oct 2008 07:17:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Peter Alfredsen wrote:
> [please CC me on replies]
> Linux loki 2.6.27-rc8 #5 SMP PREEMPT Sun Oct 5 17:56:00 CEST 2008 x86_64 
> Intel(R) Core(TM)2 Quad CPU Q9550 @ 2.83GHz GenuineIntel GNU/Linux
> 
> I recently acquired a DVR-216-DBK Pioneer SATA burner. With my old 
> burner, a DVR-110D,  I am able to burn a DVD. With the DVR-216DBK, I'm 
> not, it stops always at 98%, no matter which speed I burn at.

Can you please attach kernel boot log?  And does the kernel whine
about anything after the failure?

> My motherboard is a ASUS P5Q-EM, I have 8GB of ram and am running Gentoo 
> Linux. I've tried both cdrkit and cdrtools.
> DVR-216-DBK Fails, connected to ICH10R AHCI SATA controller
> DVR-110D Succeeds, connected to Marvell 6101 PATA_MARVELL controller

What if you swap the two?  Or is one SATA and the other PATA?  In that
case, can you get a chip sil3152 controller (probably ~10USD) and see
whether it works any better?

> I've located other people who seem to be experiencing the same thing:
> 
> http://bugs.kde.org/show_bug.cgi?id=169294

This one isn't really related.

> http://ubuntuforums.org/showthread.php?t=543483

This one might or might not.

> This seems to me to point to a problem with the AHCI driver's 
> interaction with the drive.
> 
> Attached is lspci -k and debug output from K3B:
> 
> 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA 
> AHCI Controller
>         Kernel driver in use: ahci

I suppose the drive is hanging off this one, right?

>  3942252544/4008087552 (98.4%) @16.8x, remaining 0:03 RBU 100.0% UBU 
> 100.0%
> :-[ WRITE@LBA=1ddcd0h failed with SK=5h/ASC=A8h/ACQ=04h]: Input/output 
> error
> :-( write failed: Input/output error
> /dev/sr0: flushing cache

k3b doesn't really show which command failed.  I suppose it's
WRITE(10).  The failure code is ILLEGAL REQUEST and the ASC/ASCQ are
vendor specific and don't really tell us much detail about the
failure.  :-(

Can you please try wodim with "-pad -v -V" options?  It will generate
a lot of output.  You'll probably want to redirect the output to a
file and watch it using tail or less.

Thanks.

-- 
tejun
