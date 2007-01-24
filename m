Return-Path: <linux-kernel-owner+w=401wt.eu-S933153AbXAXALd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbXAXALd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbXAXALd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:11:33 -0500
Received: from colo.lackof.org ([198.49.126.79]:41445 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbXAXALc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:11:32 -0500
Date: Tue, 23 Jan 2007 17:11:24 -0700
From: dann frazier <dannf@dannf.org>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Santiago Garcia Mantinan <manty@debian.org>,
       linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: problems with latest smbfs changes on 2.4.34 and security backports
Message-ID: <20070124001123.GG26310@colo>
References: <20070117215519.GX24090@1wt.eu> <20070119010040.GR16053@colo> <20070120010544.GY26210@colo> <t1r7r2thimh3gpuhtfc9l3aehjdd6dqkp8@4ax.com> <20070121230321.GC2480@1wt.eu> <lpu7r2lbtpm5cui8v1qpuj2fb5k3vs6f4n@4ax.com> <20070122181942.GJ28073@colo> <20070123054258.GA10301@1wt.eu> <20070123211256.GB26310@colo> <nt6dr29m1lalc3dersj4sf22od2l638fvq@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nt6dr29m1lalc3dersj4sf22od2l638fvq@4ax.com>
User-Agent: mutt-ng/devel-r782 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 10:46:24AM +1100, Grant Coady wrote:
> On Tue, 23 Jan 2007 14:12:57 -0700, dann frazier <dannf@dannf.org> wrote:
> 
> >Users have reported a symlink issue with my recent smbfs backport.
> >Turns out my backport overlooked a second 2.6 patch w/ the fix:
> > http://linux.bkbits.net:8080/linux-2.6/?PAGE=cset&REV=419e7b76CdrmRG_NZ8LKj9DUUBGu1w
> >
> >This is a backport of Haroldo Gamal's 2.6 patch that fixes the symlink
> >issue, and also cleans up an unnecessary double assignment. As his
> >commit message notes, you will need the userspace patches from Samba
> >Bug #999 in order to use the permission/ownership assigned by the
> >server.
> 
> Server-side:
> grant@deltree:/home/other$ uname -r
> 2.6.19.2a
> grant@deltree:/home/other$ ls -l
> total 8
> drwxr-xr-x 2 root  root  96 2007-01-21 11:44 dir/
> lrwxrwxrwx 1 root  root   3 2007-01-21 11:43 dirlink -> dir/
> -rw-r--r-- 1 root  root  15 2007-01-21 11:43 file
> lrwxrwxrwx 1 root  root   4 2007-01-21 11:44 filelink -> file
> -rw-r--r-- 1 grant wheel 20 2007-01-24 10:24 test
> lrwxrwxrwx 1 grant wheel  4 2007-01-24 10:23 testlink -> test
> 
> Client-side, 2.4.34c is with this new patch, 2.4.33.3 and 2.6.19.2 
> for comparison:
> 
> grant@sempro:/home/other$ uname -r
> 2.4.33.3
> grant@sempro:/home/other$ ls -l
> total 4096
> drwxr-xr-x 1 root  root   0 2007-01-21 11:44 dir/
> lrwxrwxrwx 1 root  root   3 2007-01-21 11:43 dirlink -> dir/
> -rw-r--r-- 1 root  root  15 2007-01-21 11:43 file
> lrwxrwxrwx 1 root  root   4 2007-01-21 11:44 filelink -> file
> -rw-r--r-- 1 grant wheel 20 2007-01-24 10:24 test
> lrwxrwxrwx 1 grant wheel  4 2007-01-24 10:23 testlink -> test
> 
> grant@sempro:~$ uname -r
> 2.6.19.2a
> grant@sempro:~$ ls -l /home/other/
> total 10
> drwxr-xr-x 1 grant wheel  0 2007-01-21 11:44 dir/
> lrwxr-xr-x 1 grant wheel  3 2007-01-21 11:43 dirlink -> dir/
> -rwxr-xr-x 1 grant wheel 15 2007-01-21 11:43 file*
> lrwxr-xr-x 1 grant wheel  4 2007-01-21 11:44 filelink -> file*
> -rwxr-xr-x 1 grant wheel 20 2007-01-24 10:24 test*
> lrwxr-xr-x 1 grant wheel  4 2007-01-24 10:23 testlink -> test*
> 
> grant@sempro:~$ uname -r
> 2.4.34c
> grant@sempro:~$ ls -l /home/other/
> total 4096
> drwxr-xr-x 1 grant wheel  0 2007-01-21 11:44 dir/
> lrwxr-xr-x 1 grant wheel  3 2007-01-21 11:43 dirlink -> dir/
> -rwxr-xr-x 1 grant wheel 15 2007-01-21 11:43 file*
> lrwxr-xr-x 1 grant wheel  4 2007-01-21 11:44 filelink -> file*
> -rwxr-xr-x 1 grant wheel 20 2007-01-24 10:24 test*
> lrwxr-xr-x 1 grant wheel  4 2007-01-24 10:23 testlink -> test*

Great, that's what I'd expect. If you patch your userspace, you can
avoid the executable bits.


-- 
dann frazier

