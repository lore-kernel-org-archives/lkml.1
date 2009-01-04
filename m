Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZADHrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZADHrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 02:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbZADHrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 02:47:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbZADHrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 02:47:02 -0500
Date: Sun, 4 Jan 2009 02:46:59 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 2015 of file
	fs/xfs/xfs_da_btree.c
Message-ID: <20090104074659.GA16775@infradead.org>
References: <49600DE6.2080108@shikadi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49600DE6.2080108@shikadi.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 11:16:22AM +1000, Adam Nielsen wrote:
> Hi all,
>
> I'm having a recurring problem with XFS which started about a day ago.  
> All of a sudden when reading a certain part of the disk (not sure where, 
> but my nightly backups trigger it) I get an infinite loop of these 
> messages appearing in my logs:
>
> xfs_da_do_buf: bno 8388608
> dir: inode 3087268096
> Filesystem "md0": XFS internal error xfs_da_do_buf(1) at line 2015 of 
> file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff802eba63
> Pid: 4445, comm: metalog Tainted: P           2.6.28-rc2 #3

This is a typical result of a power loss scenario with write caches
enabled and without barriers.  Given that md can't pass through barriers
did you disable the write caches on your disk?

> Does anyone know what this error means?  Do I need to reformat the filesystem?

Run xfs_repair over it to fix up the directory, and make sure to
configure your disks properly so that it doesn't happen again..

