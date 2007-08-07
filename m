Return-Path: <linux-kernel-owner+w=401wt.eu-S1761300AbXHGKcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbXHGKcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 06:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbXHGKca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 06:32:30 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:43989 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670AbXHGKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 06:32:29 -0400
To: trond.myklebust@fys.uio.no
CC: miklos@szeredi.hu, jlayton@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mikulas@artax.karlin.mff.cuni.cz,
       zippel@linux-m68k.org, joel.becker@oracle.com, wli@holomorphy.com,
       dhowells@redhat.com, bfennema@falcon.csc.calpoly.edu
In-reply-to: <E1IILwa-0007Eq-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Tue, 07 Aug 2007 12:05:40 +0200)
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
	notify_change into helper function
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	 <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
	 <20070806141333.0f54ab17.jlayton@redhat.com>
	 <E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
	 <1186427063.6616.59.camel@localhost>
	 <E1II8Nw-0005XH-00@dorka.pomaz.szeredi.hu> <1186435419.6616.136.camel@localhost> <E1III7U-0006ju-00@dorka.pomaz.szeredi.hu> <E1IILwa-0007Eq-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1IIMBc-0007Gp-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 07 Aug 2007 12:21:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There's another way to deal with this in NFS and fuse, without having
> to change the API:
> 
>  - remove suid/sgid bits from i_mode, when refreshing the inode attributes
>  - store the removed bits (or the original mode)  in the fs' inode strucure
>  - in ->getattr() restore the original mode into the returned stat
> 
> This way the VFS believes, that the inode does not in fact have the
> suid/sgid bits and so won't call ->setattr() unnecessarily.

Of course this would break exec().  Oh, well.

Miklos
