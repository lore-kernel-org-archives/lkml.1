Return-Path: <linux-kernel-owner+w=401wt.eu-S966058AbXDBWvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966058AbXDBWvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966061AbXDBWvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:51:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41127 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966044AbXDBWuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:50:08 -0400
Date: Tue, 3 Apr 2007 00:50:06 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reiserfs-dev@namesys.com, Oliver Pinter <oliver.pntr@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.21-rc5 possible regression: KDE processes die silently (was: 2.6.21-rc3-mm2: KDE processes die while system is idle)
Message-ID: <20070402225006.GI14134@stusta.de>
References: <4601B3D0.3060600@imap.cc> <460FCDE2.1080503@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <460FCDE2.1080503@imap.cc>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2007 at 05:21:06PM +0200, Tilman Schmidt wrote:
> I'm sorry to say this has now happened with kernel 2.6.21-rc5, too.
> I started a kernel compilation in the evening and came back in the
> morning to find all KDE decorations gone. All processes normally
> running for a KDE session and labelled "[kinit]" in ps were gone
> but everything else was running fine, and the system was still
> usable via ssh. /var/log/kdm.log and /var/log/Xorg.0.log contained
> nothing remotely suspicious. /var/log/messages had two lines I
> never saw before:
> 
> Mar 31 02:27:36 gx110 kernel: [153577.891443] ReiserFS: hda3: warning: vs-8115: get_num_ver: not directory or indirect item
> Mar 31 02:27:36 gx110 kernel: [153577.891559] ReiserFS: hda3: warning: vs-8115: get_num_ver: not directory or indirect item

Reiserfs people Cc'ed for this.

> But those didn't appear on previous occurrences of the "dying KDE"
> problem so I guess they are not related.
> 
> This is SUSE LINUX 10.0 (i586) running on a Dell OptiPlex GX110
> (Intel P3, 933 MHz, i810 chipset, 512 MB RAM, 60 GB ATA disk)
> % uname -a
> Linux gx110 2.6.21-rc5-noinitrd #1 PREEMPT Sat Mar 31 02:15:19 CEST 2007 i686 i686 i386 GNU/Linux
> % cat /proc/cmdline
> root=/dev/hda3 selinux=0 x11i=vesa video=intelfb:mode=1280x1024-32@70 nmi_watchdog=2 lapic 5
> Kernel configuration mostly-modular, based on standard SuSE kernel's
> /proc/config.gz, just compiling into the kernel everything I need to
> boot without an initrd and omitting some parts I'm not interested in.
> (.config attached.) What else might be relevant?
> 
> Again, this is a Heisenbug, ie. it's not reproducible and invariably
> happens when I'm away from the machine. (Probably Murphy at work.)
> It's pretty rare: I have seen it four times on 2.6.21-rc3-mm2 and
> once on 2.6.21-rc5, on a machine which spends about equal amounts
> of time running the latest stable, rc, and mm kernels. OTOH, so far
> it hasn't ever happened with any 2.6.20 or earlier kernel. Nor have
> I seen it with 2.6.21-rc[1-4] or 2.6.21-rc4-mm* - but for the -rc4
> and -rc4-mm releases that's not conclusive as those have only been
> running for a very short time.

We also have another report of crashes under KDE:

Subject    : crashes in KDE
References : http://bugzilla.kernel.org/show_bug.cgi?id=8157
Submitter  : Oliver Pinter <oliver.pntr@gmail.com>
Status     : unknown

We also have one bug kwin ran into that got fixed after -rc5:

Subject    : kwin dies silently
References : http://lkml.org/lkml/2007/2/28/112
Submitter  : Sid Boyce <g3vbv@blueyonder.co.uk>
             Boris Mogwitz <boris@macbeth.rhoen.de>
             Michael Wu <aluminum.tape@gmail.com>
Caused-By  : Eric W. Biederman <ebiederm@xmission.com>
             commit 0475ac0845f9295bc5f69af45f58dff2c104c8d1
Fixed-By   : Eric W. Biederman <ebiederm@xmission.com>
Commit     : 14e9d5730adfca26452b3a2838a80af6950556f5
Status     : fixed in -rc6

These might or might not be related issues.

> HTH
> T.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

