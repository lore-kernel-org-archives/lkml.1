Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbXF3Jds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbXF3Jds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXF3Jdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:33:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbXF3Jdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:33:40 -0400
From: Neil Brown <neilb@suse.de>
To: Turbo Fredriksson <turbo@bayour.com>
Date: Sat, 30 Jun 2007 19:33:27 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18054.9063.45466.586046@notabene.brown>
Cc: Alasdair G Kergon <agk@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Moving MD/LVM from PPC to x86
In-Reply-To: message from Turbo Fredriksson on Saturday June 30
References: <87wsxneqs0.fsf@pumba.bayour.com>
	<20070629215416.GA12786@agk.fab.redhat.com>
	<876455erlw.fsf@pumba.bayour.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday June 30, turbo@bayour.com wrote:
> Quoting Alasdair G Kergon <agk@redhat.com>:
> 
> > On Thu, Jun 28, 2007 at 11:02:39PM +0200, Turbo Fredriksson wrote:
> >>   2. How do I move a VG/PV/LV from PPC to x86?
> >
> > The on-disk LVM2 metadata should be accessible from both
> > architectures.
> 
> Well, when I move the disks, the intel machine say that one of
> the disks don't have a partition table and that the other don't
> have any MD superblock...

Version 0.90 MD superblocks (still the default) uses host-endian
values so you cannot move between architectures directly.  However
isn't too hard to make it work. 
Firstly, use
   mdadm --examine --metadata=0.swap /dev/DEVICE

to check that you have the right devices.
Then

  mdadm --assemble /dev/md0 --update=byteorder /dev/DEV0 /dev/DEV1  ....

That should assemble the array and update the superblocks so that they
are in the right byteorder and will assemble easily in future.

NeilBrown
