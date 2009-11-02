Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZKBNak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZKBNak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 08:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbZKBNaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 08:30:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232AbZKBNaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 08:30:39 -0500
Date: Mon, 2 Nov 2009 14:30:42 +0100
From: Jan Blunck <jblunck@suse.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/27] Push down BKL to the filesystems (v2)
Message-ID: <20091102133042.GE21750@bolzano.suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <200911021229.02332.borntraeger@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911021229.02332.borntraeger@de.ibm.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, Christian Borntraeger wrote:

> Am Montag 02 November 2009 11:04:40 schrieb Jan Blunck:
> > During the realtime preemption mini-summit we discussed the entire removal
> >  of the big kernel lock. I've started working on this for some filesystems.
> >  My plan is to push the BKL down to the implementations first and remove it
> >  from there later.
> > 
> > This series is pushing the BKL from do_new_mount() down to the filesystems
> >  and removes it from ext series of filesystems and one other trivial use:
> >  if the BKL is only used in get_sb/fill_super due to the push-down, we just
> >  need to make sure that parallel calls to get_sb/fill_super would race
> >  against each other.
> 
> seems that patch 1 (the pushdown) did not yet made it to the list.

Seems that the CC list was too long because I used get_maintainer.pl together
with git-send-email on this patch ...

> Looking at 
> you diffstat it seems that you only touched fs/*
> 
> There are filesystems in other places, e.g.
> drivers/isdn/capi/capifs.c,
> arch/powerpc/platforms/cell/spufs/inode.c
> or
> arch/s390/hypfs/inode.c
> 
> I am really not an expert in filesystems, so my comment might be bogus: My 
> expection was, that a simple pushdown should also affect these filesystems, 
> especially if the filesystems dont use simple_fill_super, no?

D'Oh! You are totally correct. Seems that nothing important outside of fs/
actually requires the BKL since my box is still wor
