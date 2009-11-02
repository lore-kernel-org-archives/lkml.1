Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZKBP3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZKBP3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbZKBP3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:29:05 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:56420 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbZKBP3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:29:03 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 00/27] Push down BKL to the filesystems (v2)
Date: Mon, 2 Nov 2009 16:29:06 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc5-self-00402-gb6727b1; KDE/4.3.2; i686; ; )
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <200911021229.02332.borntraeger@de.ibm.com> <20091102133042.GE21750@bolzano.suse.de>
In-Reply-To: <20091102133042.GE21750@bolzano.suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911021629.06520.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 02 November 2009 14:30:42 schrieb Jan Blunck:
> On Mon, Nov 02, Christian Borntraeger wrote:
> > Am Montag 02 November 2009 11:04:40 schrieb Jan Blunck:
> > > During the realtime preemption mini-summit we discussed the entire
> > > removal of the big kernel lock. I've started working on this for some
> > > filesystems. My plan is to push the BKL down to the implementations
> > > first and remove it from there later.
> > >
> > > This series is pushing the BKL from do_new_mount() down to the
> > > filesystems and removes it from ext series of filesystems and one other
> > > trivial use: if the BKL is only used in get_sb/fill_super due to the
> > > push-down, we just need to make sure that parallel calls to
> > > get_sb/fill_super would race against each other.
> >
> > seems that patch 1 (the pushdown) did not yet made it to the list.
> 
> Seems that the CC list was too long because I used get_maintainer.pl
>  together with git-send-email on this patch ...
> 
> > Looking at
> > you diffstat it seems that you only touched fs/*
> >
> > There are filesystems in other places, e.g.
> > drivers/isdn/capi/capifs.c,
> > arch/powerpc/platforms/cell/spufs/inode.c
> > or
> > arch/s390/hypfs/inode.c
> >
> > I am really not an expert in filesystems, so my comment might be bogus:
> > My expection was, that a simple pushdown should also affect these
> > filesystems, especially if the filesystems dont use simple_fill_super,
> > no?
> 
> D'Oh! You are totally correct. Seems that nothing important outside of fs/
> actually requires the BKL since my box is still wor
> 














