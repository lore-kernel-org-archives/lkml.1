Return-Path: <linux-kernel-owner+w=401wt.eu-S933971AbYAaRne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933971AbYAaRne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760038AbYAaRnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:43:24 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55772 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758522AbYAaRnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:43:23 -0500
To: kzak@redhat.com
CC: miklos@szeredi.hu, zippel@linux-m68k.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfrench@us.ibm.com, lachlan@sgi.com, jsipek@cs.sunysb.edu,
       rmk@arm.linux.org.uk, dhowells@redhat.com, raven@themaw.net,
       rathamahata@php4.ru, kkeil@suse.de, hpa@zytor.com, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, jdike@addtoit.com,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com,
       shaggy@austin.ibm.com, vandrove@vc.cvut.cz, Trond.Myklebust@netapp.com,
       jeffm@suse.com, paulus@samba.org, hugh@veritas.com, gorcunov@gmail.com,
       gregkh@suse.de
In-reply-to: <20080130144204.GZ6922@petra.dvoda.cz> (message from Karel Zak on
	Wed, 30 Jan 2008 15:42:04 +0100)
Subject: Re: [patch 01/26] mount options: add documentation
References: <20080124193341.166753833@szeredi.hu> <20080124193416.379218079@szeredi.hu> <200801300254.06363.zippel@linux-m68k.org> <E1JK8wJ-0007aA-Tt@pomaz-ex.szeredi.hu> <20080130144204.GZ6922@petra.dvoda.cz>
Message-Id: <E1JKdR1-00030N-3x@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 31 Jan 2008 18:42:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > - loop: how is the connection between file and loop device maintained?
> > 
> > We also discussed this with Karel, maybe it didn't make it onto lkml.
> > 
> > The proposed solution was to store the "loop" flag separately in a
> > file under /var.  It could just be an empty file for each such loop
> > device:
> > 
> >   /var/lib/mount/loops/loop0
> > 
> > This file is created by mount(8) if the '-oloop' option is given.  And
> > umount(8) automatically tears down the loop device if it finds this
> > file.
> 
>  It seems we needn't this solution. There is loop auto-destruction
>  patch in -mm.
> 
>  Kernel part:
>     http://marc.info/?l=linux-kernel&m=119361296818388&w=2
> 
>  mount(8) part:
>     http://marc.info/?l=util-linux-ng&m=119362955431694&w=2
> 
>  So, with this patch mount(8) needn't to maintain info about loops and
>  umount(8) doesn't need to call LOOP_CLR_FD ioctl, because umount(2)
>  is enough.

Excellent!  This is a very good example how moving a functionality
into the kernel can greatly simplify it.

Thanks,
Miklos
