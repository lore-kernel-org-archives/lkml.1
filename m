Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZKBPbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZKBPbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438AbZKBPbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:31:18 -0500
Received: from mtagate3.de.ibm.com ([195.212.17.163]:48067 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278AbZKBPbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:31:17 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 00/27] Push down BKL to the filesystems (v2)
Date: Mon, 2 Nov 2009 16:31:21 +0100
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
Message-Id: <200911021631.21266.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 02 November 2009 14:30:42 schrieb Jan Blunck:
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

Can you change your series to do the full pushdown anyway? grep for 
register_filesystem find several places that probably dont get much testing and 
if something goes wrong a full pushdown + blk removal would allow to find the 
problem with bisect later on.
