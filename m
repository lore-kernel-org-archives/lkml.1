Return-Path: <linux-kernel-owner+w=401wt.eu-S1763443AbZCQMyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763443AbZCQMyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 08:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZCQMyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 08:54:08 -0400
Received: from crux.i-cable.com ([203.83.115.104]:32837 "HELO crux.i-cable.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753527AbZCQMyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 08:54:05 -0400
Date: Tue, 17 Mar 2009 20:53:47 +0800
From: Zhang Le <r0bertz@gentoo.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, alan@redhat.com
Subject: Re: [PATCH] filp->f_pos not correctly updated in proc_task_readdir
Message-ID: <20090317125346.GA22268@adriano.hkcable.com.hk>
References: <1237185871-3343-1-git-send-email-r0bertz@gentoo.org> <20090316083457.GV28946@ZenIV.linux.org.uk> <20090317103744.GA2399@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317103744.GA2399@x200.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:37 Tue 17 Mar     , Alexey Dobriyan wrote:
> On Mon, Mar 16, 2009 at 08:34:57AM +0000, Al Viro wrote:
> > On Mon, Mar 16, 2009 at 02:44:31PM +0800, Zhang Le wrote:
> > > filp->f_pos only get updated at the end of the function. Thus d_off of those
> > > dirents who are in the middle will be 0, and this will cause a problem in
> > > glibc's readdir implementation, specifically endless loop. Because when overflow
> > > occurs, f_pos will be set to next dirent to read, however it will be 0, unless
> > > the next one is the last one. So it will start over again and again.
> > 
> > Eh...  Here's what's really going on:
> > 
> > proc_..._fill_cache() API is rather kludgy and far too convoluted.  In
> > particular, it calls filldir() and passes file->f_pos to it, expecting
> > the caller to update file->f_pos between the calls.  proc_task_readdir()
> > uses that sucker, but doesn't update ->f_pos until the very end.  As
> > the result, d_off of direntries produced by it gets screwed.
> > Broken-by: commit 61a28784028e6d55755e4d0f39bee8d9bf2ee8d9
> > Author: Eric W. Biederman <ebiederm@xmission.com>
> > Date:   Mon Oct 2 02:18:49 2006 -0700
> > 
> >     [PATCH] proc: Remove the hard coded inode numbers
> > 
> > Patch is fine, but I'd rather rip the layers of ..._fill_cache() abstractions
> > out and see what falls out.  Anyway, for -rc your variant is definitely the
> > way to go.
> 
> Except this bit:
> 
> fs/built-in.o: In function `proc_task_readdir':
> compr_zlib.c:(.text+0x434b8): undefined reference to `__cmpdi2'
> compr_zlib.c:(.text+0x434d4): undefined reference to `__cmpdi2'

Hi, I am sorry but I can't reproduce this.
Are you sure this only happens after applying my patch?
Would you please provide your fs/jffs2/compr_zlib.o and fs/proc/base.o?
And what is your gcc version? I am using gcc 4.4 snapshot rev. 144705
Thanks!

Zhang, Le
http://zhangle.is-a-geek.org
