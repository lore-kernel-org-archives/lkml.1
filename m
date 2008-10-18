Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYJRI6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYJRI6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 04:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYJRI6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 04:58:16 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3287 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYJRI6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 04:58:15 -0400
Date: Sat, 18 Oct 2008 10:57:56 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Tobias Frost <tobi@coldtobi.de>, linux-kernel@vger.kernel.org,
       debian-arm@lists.debian.org, xfs@oss.sgi.com
Subject: Re: XFS filesystem corruption on the arm(el) architecture
Message-ID: <20081018085752.GS25834@deprecation.cyrius.com>
References: <1222893502.5020.40.camel@moria> <20081002004556.GB30001@disturbed> <48E4213E.9090508@sandeen.net> <20081016212500.GA27228@deprecation.cyrius.com> <48F7BC9F.4080909@sandeen.net> <20081017070109.GA30726@deprecation.cyrius.com> <48F89E0F.6030307@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F89E0F.6030307@sandeen.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Sandeen <sandeen@sandeen.net> [2008-10-17 09:15]:
> If you unmount & remount, does the ls work then?

I cannot even mount it:

debian:~# mkfs.xfs -f /dev/sda5
meta-data=/dev/sda5              isize=256    agcount=4, agsize=94380 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=377519, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
debian:~# mount /dev/sda5 /mnt
[42949596.920000] XFS mounting filesystem sda5
debian:~# cp /usr/bin/* /mnt/
debian:~# umount /mnt
debian:~# mount -t xfs /dev/sda5 /mnt
[42949612.290000] XFS mounting filesystem sda5
[42949612.460000] Starting XFS recovery on filesystem: sda5 (logdev: internal)
[42949612.480000] XFS: xlog_recover_process_data: bad flag
[42949612.500000] XFS: log mount/recovery failed: error 5
[42949612.500000] XFS: log mount failed
mount: /dev/sda5: can't read superblock
debian:~#

> Do you know what cachepolicy you're booted with?  If it's writeallocate,
> you might try cachepolicy=writeback, otherwise try cachepolicy=uncached
> (which will be horribly slow) and see if the problem goes away or not;
> it'd be a clue.

I just tried with cachepolicy=writeback and cachepolicy=uncached but I
get the same problem.
-- 
Martin Michlmayr
http://www.cyrius.com/
