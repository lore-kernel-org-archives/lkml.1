Return-Path: <linux-kernel-owner+w=401wt.eu-S1763288AbYA3Ooh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763288AbYA3Ooh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762731AbYA3OoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:44:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762548AbYA3OoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:44:20 -0500
Date: Wed, 30 Jan 2008 15:42:04 +0100
From: Karel Zak <kzak@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zippel@linux-m68k.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfrench@us.ibm.com, lachlan@sgi.com, jsipek@cs.sunysb.edu,
       rmk@arm.linux.org.uk, dhowells@redhat.com, raven@themaw.net,
       rathamahata@php4.ru, kkeil@suse.de, hpa@zytor.com, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, jdike@addtoit.com,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com,
       shaggy@austin.ibm.com, vandrove@vc.cvut.cz, Trond.Myklebust@netapp.com,
       jeffm@suse.com, paulus@samba.org, hugh@veritas.com, gorcunov@gmail.com,
       gregkh@suse.de
Subject: Re: [patch 01/26] mount options: add documentation
Message-ID: <20080130144204.GZ6922@petra.dvoda.cz>
References: <20080124193341.166753833@szeredi.hu> <20080124193416.379218079@szeredi.hu> <200801300254.06363.zippel@linux-m68k.org> <E1JK8wJ-0007aA-Tt@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JK8wJ-0007aA-Tt@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 10:09:03AM +0100, Miklos Szeredi wrote:
> > - loop: how is the connection between file and loop device maintained?
> 
> We also discussed this with Karel, maybe it didn't make it onto lkml.
> 
> The proposed solution was to store the "loop" flag separately in a
> file under /var.  It could just be an empty file for each such loop
> device:
> 
>   /var/lib/mount/loops/loop0
> 
> This file is created by mount(8) if the '-oloop' option is given.  And
> umount(8) automatically tears down the loop device if it finds this
> file.

 It seems we needn't this solution. There is loop auto-destruction
 patch in -mm.

 Kernel part:
    http://marc.info/?l=linux-kernel&m=119361296818388&w=2

 mount(8) part:
    http://marc.info/?l=util-linux-ng&m=119362955431694&w=2

 So, with this patch mount(8) needn't to maintain info about loops and
 umount(8) doesn't need to call LOOP_CLR_FD ioctl, because umount(2)
 is enough.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
