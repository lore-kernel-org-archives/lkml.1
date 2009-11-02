Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZKBL3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZKBL3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 06:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbZKBL3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 06:29:00 -0500
Received: from mtagate6.de.ibm.com ([195.212.17.166]:49155 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbZKBL27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 06:28:59 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 00/27] Push down BKL to the filesystems (v2)
Date: Mon, 2 Nov 2009 12:29:02 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc5-self-00402-gb6727b1; KDE/4.3.2; i686; ; )
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911021229.02332.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 02 November 2009 11:04:40 schrieb Jan Blunck:
> During the realtime preemption mini-summit we discussed the entire removal
>  of the big kernel lock. I've started working on this for some filesystems.
>  My plan is to push the BKL down to the implementations first and remove it
>  from there later.
> 
> This series is pushing the BKL from do_new_mount() down to the filesystems
>  and removes it from ext series of filesystems and one other trivial use:
>  if the BKL is only used in get_sb/fill_super due to the push-down, we just
>  need to make sure that parallel calls to get_sb/fill_super would race
>  against each other.

seems that patch 1 (the pushdown) did not yet made it to the list. Looking at 
you diffstat it seems that you only touched fs/*

There are filesystems in other places, e.g.
drivers/isdn/capi/capifs.c,
arch/powerpc/platforms/cell/spufs/inode.c
or
arch/s390/hypfs/inode.c

I am really not an expert in filesystems, so my comment might be bogus: My 
expection was, that a simple pushdown should also affect these filesystems, 
especially if the filesystems dont use simple_fill_super, no?
