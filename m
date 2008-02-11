Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYBKHfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYBKHfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 02:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYBKHfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 02:35:00 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44380 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYBKHe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 02:34:59 -0500
Subject: Re: [RFC PATCH] vfs: optimization to /proc/<pid>/mountinfo patch
From: Ram Pai <linuxram@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk,
       a.p.zijlstra@chello.nl
In-Reply-To: <20080204012849.08c593e1.akpm@linux-foundation.org>
References: <E1JJqxt-0004r2-Vf@pomaz-ex.szeredi.hu>
	 <20080130160839.828c4363.akpm@linux-foundation.org>
	 <E1JKVY6-0001wd-BE@pomaz-ex.szeredi.hu>
	 <1201805123.10358.23.camel@ram.us.ibm.com>
	 <1202116505.3949.91.camel@ram.us.ibm.com>
	 <20080204012849.08c593e1.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 10 Feb 2008 23:36:31 -0800
Message-Id: <1202715391.1942.9.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-04 at 01:28 -0800, Andrew Morton wrote:
> On Mon, 04 Feb 2008 01:15:05 -0800 Ram Pai <linuxram@us.ibm.com> wrote:
> 
> > 1) reports deleted inode in dentry_path() consistent with that in __d_path()
> > 2) modified __d_path() to use prepend(), reducing the size of __d_path()
> > 3) moved all the functionality that reports mount information in /proc under
> > 	CONFIG_PROC_FS.
> > 
> > Could not verify if the code would work with CONFIG_PROC_FS=n, since it was
> > impossible to disable CONFIG_PROC_FS. Looking for ideas on how to disable
> > CONFIG_PROC_FS.

this worked. thanks. There was one place in ipv4 that failed compilation
with proc_fs disabled. Fixed that. Otherwise everything compiled
cleanly.

> 
> Do `make menuconfig', then hit '/' and search for "proc_fs".
> 
> It'll tell you that you need to set EMBEDDED=y to disable procfs.
> 
> >  fs/dcache.c              |   59 +++++++++++++++++++----------------------------
> >  fs/namespace.c           |    2 +
> >  fs/seq_file.c            |    2 +
> >  include/linux/dcache.h   |    3 ++
> >  include/linux/seq_file.h |    3 ++
> 
> Please resend after testing that, thanks.

with procfs disabled, the boot fails, since nash(fedora's startup
script) which links with libc.so library has dependencies on /proc. Nash
segfaults and so does init.  looking for ideas.

without passing this hurdle, its hard to test the patch :(
RP

