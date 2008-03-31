Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYCaQ5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYCaQ5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYCaQ47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:56:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46274 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYCaQ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:56:58 -0400
Date: Mon, 31 Mar 2008 09:50:27 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Lonnie Iverson <ldiverson@novell.com>
Subject: Re: [BUILD_FAILURE] linux-next: Tree for March 31 build fails on
	fs/novfs sys_flistxattr()
Message-ID: <20080331165027.GA8073@kroah.com>
References: <20080331181118.7964d4a9.sfr@canb.auug.org.au> <47F0C8B6.7020808@linux.vnet.ibm.com> <20080331224125.cc030176.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331224125.cc030176.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 10:41:25PM +1100, Stephen Rothwell wrote:
> On Mon, 31 Mar 2008 16:49:18 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> >
> > Hi Stephen,
> > 
> > The next-20080331 allyesconfig, build fails on x86_64 machine
> > 
> > fs/novfs/built-in.o: In function `sys_flistxattr':
> > /root/kernels/linux-2.6.25-rc7/fs/novfs/inode.c:4658: multiple definition of `sys_flistxattr'
> > fs/xattr.o:/root/kernels/linux-2.6.25-rc7/fs/xattr.c:457: first defined here
> > ld: Warning: size of symbol `sys_flistxattr' changed from 112 in fs/xattr.o to 75 in fs/novfs/built-in.o
> > fs/novfs/built-in.o: In function `sys_fsetxattr':
> > /root/kernels/linux-2.6.25-rc7/fs/novfs/inode.c:4672: multiple definition of `sys_fsetxattr'
> > fs/xattr.o:/root/kernels/linux-2.6.25-rc7/fs/xattr.c:295: first defined here
> > ld: Warning: size of symbol `sys_fsetxattr' changed from 164 in fs/xattr.o to 97 in fs/novfs/built-in.o
> > fs/novfs/built-in.o: In function `sys_fgetxattr':
> > /root/kernels/linux-2.6.25-rc7/fs/novfs/inode.c:4645: multiple definition of `sys_fgetxattr'
> > fs/xattr.o:/root/kernels/linux-2.6.25-rc7/fs/xattr.c:384: first defined here
> > ld: Warning: size of symbol `sys_fgetxattr' changed from 128 in fs/xattr.o to 91 in fs/novfs/built-in.o
> > make[1]: *** [fs/built-in.o] Error 1
> > make: *** [fs] Error 2
> 
> Yes, well this from fs/novfs/inode.c was asking for it really :-)
> 
> asmlinkage ssize_t sys_flistxattr(int fd, char __user * list, size_t size)
> {
> .

Now fixed up, sorry for the noise.  Why it was ever declaring it's own
system calls for extended attributes, I'll never know...

thanks,

greg k-h
