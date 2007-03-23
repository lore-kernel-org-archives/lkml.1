Return-Path: <linux-kernel-owner+w=401wt.eu-S1945895AbXCWOsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945895AbXCWOsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945896AbXCWOsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:48:08 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:36074 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945895AbXCWOsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:48:07 -0400
Date: Fri, 23 Mar 2007 15:48:09 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Tomas M <tomas@slax.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] [bugfix] loop.c
Message-Id: <20070323154809.238d8fe2.dada1@cosmosbay.com>
In-Reply-To: <20070323143605.GA4095@ftp.linux.org.uk>
References: <4603DE86.1090009@slax.org>
	<20070323151956.1ac6a47b.dada1@cosmosbay.com>
	<20070323143605.GA4095@ftp.linux.org.uk>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 14:36:05 +0000
Al Viro <viro@ftp.linux.org.uk> wrote:

> On Fri, Mar 23, 2007 at 03:19:56PM +0100, Eric Dumazet wrote:
> > I cooked the following patch (untested), feel free to test it.
> 
> Please, get the cleanup into saner shape.  This is too ugly.

out_mem:
        while (nba--)
                blk_cleanup_queue(loop_dev[nba]->lo_queue);
        while (nbl--) {
                put_disk(loop_dev[nbl]->lo_disk);
                kfree(loop_dev[nbl]);
        }
        if (loop_dev_vmalloced)
                vfree(loop_dev);
        else
                kfree(loop_dev);
        unregister_blkdev(LOOP_MAJOR, "loop");


What is ugly in this code ?
