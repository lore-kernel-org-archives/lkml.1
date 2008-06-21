Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbYFUHVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbYFUHVZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 03:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYFUHVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 03:21:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36000 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYFUHVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 03:21:14 -0400
Date: Sat, 21 Jun 2008 00:10:23 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-staging/linux-next merge/build errors
Message-ID: <20080621071023.GA2765@kroah.com>
References: <20080621124017.ec3b0a51.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080621124017.ec3b0a51.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 21, 2008 at 12:40:17PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today I have done a test merge of linux-staging into linux-next.  I got
> merge conflicts in drivers/char/agp/via-agp.c and drivers/misc/Makefile -
> neither of which is really surprising and both tivial to fix up.
> 
> I then did an x86 allmodconfig build with these errors:
> 
> In file included from /home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_drm.c:32:
> /home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_3d_reg.h: In function ‘IS_AGPHEADER_INV’:
> /home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_3d_reg.h:230: error: ‘TRUE’ undeclared (first use in this function)
> /home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_3d_reg.h:230: error: (Each undeclared identifier is reported only once
> /home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_3d_reg.h:230: error: for each function it appears in.)
> /home/sfr/kernels/next/src/drivers/char/drm/via_chrome9_3d_reg.h:232: error: ‘FALSE’ undeclared (first use in this function)

Wierd, this passes allmodconfig on i386, something else must be
declaring TRUE and FALSE :)

I'll just go remove them entirely.

> And several new warnings (these may not be all):
> 
> /home/sfr/kernels/next/src/fs/novfs/inode.c:265: warning: initialization from incompatible pointer type
> /home/sfr/kernels/next/src/fs/novfs/inode.c:267: warning: initialization from incompatible pointer type
> /home/sfr/kernels/next/src/fs/novfs/inode.c:273: warning: initialization from incompatible pointer type
> /home/sfr/kernels/next/src/fs/novfs/inode.c:275: warning: initialization from incompatible pointer type
> In file included from /home/sfr/kernels/next/src/fs/novfs/daemon.c:24:
> include2/asm/semaphore.h:1:2: warning: #warning Use linux/semaphore.h, not asm/semaphore.h
> In file included from /home/sfr/kernels/next/src/fs/novfs/scope.c:26:
> include2/asm/semaphore.h:1:2: warning: #warning Use linux/semaphore.h, not asm/semaphore.h
> In file included from /home/sfr/kernels/next/src/fs/novfs/nwcapi.c:22:
> include2/asm/semaphore.h:1:2: warning: #warning Use linux/semaphore.h, not asm/semaphore.h

Yeah, we took a major update of novfs and some of my previous fixes like
this got lost.

I'll go resolve them now.

thanks,

greg k-h
