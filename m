Return-Path: <linux-kernel-owner+w=401wt.eu-S2992431AbXCWO40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992431AbXCWO40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992434AbXCWO40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:56:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45956 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992431AbXCWO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:56:25 -0400
Date: Fri, 23 Mar 2007 14:56:22 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
Message-ID: <20070323145622.GC4095@ftp.linux.org.uk>
References: <4603DE86.1090009@slax.org> <20070323151956.1ac6a47b.dada1@cosmosbay.com> <20070323143605.GA4095@ftp.linux.org.uk> <20070323154809.238d8fe2.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323154809.238d8fe2.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 03:48:09PM +0100, Eric Dumazet wrote:
> On Fri, 23 Mar 2007 14:36:05 +0000
> Al Viro <viro@ftp.linux.org.uk> wrote:
> 
> > On Fri, Mar 23, 2007 at 03:19:56PM +0100, Eric Dumazet wrote:
> > > I cooked the following patch (untested), feel free to test it.
> > 
> > Please, get the cleanup into saner shape.  This is too ugly.
> 
> out_mem:
>         while (nba--)
>                 blk_cleanup_queue(loop_dev[nba]->lo_queue);
>         while (nbl--) {
>                 put_disk(loop_dev[nbl]->lo_disk);
>                 kfree(loop_dev[nbl]);
>         }
>         if (loop_dev_vmalloced)
>                 vfree(loop_dev);
>         else
>                 kfree(loop_dev);
>         unregister_blkdev(LOOP_MAJOR, "loop");
> 
> 
> What is ugly in this code ?

Your counters.  Two loops instead of one (no reason to allocate queues in
a a separate loop).  vmalloc conditional on kmalloc failure.
