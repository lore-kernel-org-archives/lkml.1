Return-Path: <linux-kernel-owner+w=401wt.eu-S935530AbXHNUPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935530AbXHNUPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbXHNUP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:15:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755488AbXHNUP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:15:27 -0400
Date: Tue, 14 Aug 2007 21:12:20 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Diego Woitasen <diego@woitasen.com.ar>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove unneded lock_kernel in drivers/md/dm.c and use unlocked_ioctl.
Message-ID: <20070814201220.GA30122@agk.fab.redhat.com>
Mail-Followup-To: Diego Woitasen <diego@woitasen.com.ar>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
References: <11858486294133-git-send-email-diego@woitasen.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11858486294133-git-send-email-diego@woitasen.com.ar>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 11:23:49PM -0300, Diego Woitasen wrote:
> -static int dm_blk_ioctl(struct inode *inode, struct file *file,
> -			unsigned int cmd, unsigned long arg)
> +static long dm_blk_ioctl(struct file *file, unsigned int cmd, unsigned long arg)

> -	/* We don't really need this lock, but we do need 'inode'. */
> -	unlock_kernel();
> +	inode = file->f_path.dentry->d_inode;

Have the call paths that pass a NULL 'file' parameter down all been
changed?  If not, perhaps pass the 'inode' parameter into
unlocked_ioctl(), as happens with ioctl(), to get rid of the lock.

Alasdair
-- 
agk@redhat.com
