Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbYAINEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbYAINEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 08:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYAINEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 08:04:34 -0500
Received: from rosi.naasa.net ([212.8.0.13]:40093 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbYAINEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 08:04:33 -0500
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Wed, 9 Jan 2008 14:04:29 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <200801091322.35133.lists@naasa.net> <399883439.31205@ustc.edu.cn>
In-Reply-To: <399883439.31205@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801091404.30330.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 9. Januar 2008 schrieb Fengguang Wu:
> On Wed, Jan 09, 2008 at 01:22:33PM +0100, Joerg Platte wrote:
> > Am Mittwoch, 9. Januar 2008 schrieb Fengguang Wu:
> >
> > Thank your for the hint with the filesystems!
> >
> > > Thank you for the clue. However I cannot reproduce the bug on
> > > ext2/2.6.24-rc7. Can you provide more details? Thank you.
> >
> > I attached some more information. I'm using the ata_piix driver for my
> > PATA disk and cdrom drive and booted with hpet=force. Kernel 2.6.23.X has
> > been
>
>                                                           ~~~~~~~~
> 							  not 2.6.24-rc7?
>
No, 2.6.23.X was the last working kernel without this problem, the bug shows 
up with 2.6.24-rcX. I just wanted to emphasis, that I don't think that it has 
something to do with the hpet stuff. Kernel 2.6.24-rcX is unpatched, because 
the hrt stuff has been merged.

> > patched with the -hrt patches to enable the hidden hpet time on the
> > ICH4-M chipset. I just rebooted the notebook and mounted /tmp again as
> > ext2 and now the iowait problem is back. Seems to be reproducible on my
> > computer. What additional information do you need?
>
> I mounted an ext2 as tmp and find no problem. My config options are:
>
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT2_FS_XIP is not set
>
> Fengguang

CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y

Here it is modular and I enabled CONFIG_EXT2_FS_XIP, but the same is enabled 
on 2.6.23.X. Maybe it is related to libata? I additionally discovered, that 
the problem disappears for a few seconds when I press the eject button for 
the ultra bay of my thinkpad. Pressing the button unregisters the cdrom drive 
to be able to replace it with a hard drive or a battery. Maybe this bug is 
thinkpad relared?

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605

