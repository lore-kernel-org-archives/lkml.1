Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZHQMkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZHQMkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZHQMkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:40:16 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37148 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZHQMkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:40:15 -0400
Subject: Re: [patch] fs: Make unload_nls() NULL pointer safe
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@us.ibm.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Roman Zippel <zippel@linux-m68k.org>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       Anton Altaparmakov <aia21@cantab.net>
In-Reply-To: <20090816210335.309469111@linutronix.de>
References: <20090816210335.309469111@linutronix.de>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 07:40:06 -0500
Message-Id: <1250512806.24927.8.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-16 at 21:05 +0000, Thomas Gleixner wrote:
> plain text document attachment (unload_nls.patch)
> Most call sites of unload_nls() do:
> 	if (nls)
> 		unload_nls(nls);
> 
> Check the pointer inside unload_nls() like we do in kfree() and
> simplify the call sites.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Steve French <sfrench@us.ibm.com>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> Cc: Roman Zippel <zippel@linux-m68k.org>

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
> Cc: Anton Altaparmakov <aia21@cantab.net>
> 
> ---
>  fs/befs/linuxvfs.c |    7 +------
>  fs/cifs/cifsfs.c   |    3 +--
>  fs/fat/inode.c     |   16 ++++------------
>  fs/hfs/mdb.c       |    6 ++----
>  fs/hfsplus/super.c |    6 ++----
>  fs/isofs/inode.c   |    8 ++------
>  fs/jfs/super.c     |    9 +++------
>  fs/ncpfs/inode.c   |   12 ++----------
>  fs/ncpfs/ioctl.c   |    6 ++----
>  fs/nls/nls_base.c  |    3 ++-
>  fs/ntfs/super.c    |   10 ++++------
>  fs/smbfs/inode.c   |   10 ++--------
>  12 files changed, 27 insertions(+), 69 deletions(-)
-- 
David Kleikamp
IBM Linux Technology Center

