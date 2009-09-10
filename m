Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbZIJXI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbZIJXI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbZIJXIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:08:25 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45216 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZIJXIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:08:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Fri, 11 Sep 2009 01:07:55 +0200
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 18/16] implement posix O_SYNC and O_DSYNC semantics
In-reply-to: <20090910202521.GA20261@lst.de>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       drepper@redhat.com, viro@zeniv.linux.org.uk, kyle@mcmartin.ca
Message-id: <20090910230755.GQ9372@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1251899966-7316-1-git-send-email-jack@suse.cz>
 <20090910202521.GA20261@lst.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 10, 2009  22:25 +0200, Christoph Hellwig wrote:
> +/*
> + * Before Linux 2.6.32 only O_DSYNC semantics were implemented, but using
> + * the O_SYNC flag.  We continue to use the existing numerical value
> + * for O_DSYNC semantics now, but using the correct symbolic name for it.
> + * This new value is used to request true Posix O_SYNC semantics.  It is
> + * defined in this strange way to make sure applications compiled against
> + * new headers get at least O_DSYNC semantics on older kernels.
> + *
> + * This has the nice side-effect that we can simply test for O_DSYNC
> + * wherever we do not care if O_DSYNC or O_SYNC is used.
> +
> + * Note: __O_SYNC must never be used directly.

Doesn't it make sense that applications that actually know what they are
doing may want to start using __O_SYNC directly at some point in the
future?  It makes sense to code the kernel to handle both of these flags
appropriately (i.e. if __O_SYNC is set, but O_DSYNC is not then treat
this as the proper "O_SYNC").

> Index: linux-2.6/arch/alpha/include/asm/fcntl.h
> ===================================================================
> --- linux-2.6.orig/arch/alpha/include/asm/fcntl.h	2009-09-10 16:31:47.720004025 -0300
> +++ linux-2.6/arch/alpha/include/asm/fcntl.h	2009-09-10 16:33:55.087294444 -0300
>  #define O_CLOEXEC	010000000 /* set close_on_exec */
> +#define __O_SYNC	010000000

These two flags have the same value...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

