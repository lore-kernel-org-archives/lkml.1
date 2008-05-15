Return-Path: <linux-kernel-owner+w=401wt.eu-S1759243AbYEOAGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbYEOAGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 20:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYEOAGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 20:06:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbYEOAGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 20:06:05 -0400
Date: Wed, 14 May 2008 17:05:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net
Subject: Re: 2.6.26-rc2-mm1 (p9 build error when 9P_FS=n)
Message-Id: <20080514170543.a0130556.akpm@linux-foundation.org>
In-Reply-To: <a4e6962a0805141700x3565e40fieda66f8a5a0a4d7a@mail.gmail.com>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	<20080514141630.bcf8d0cd.randy.dunlap@oracle.com>
	<a4e6962a0805141700x3565e40fieda66f8a5a0a4d7a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 19:00:12 -0500
"Eric Van Hensbergen" <ericvh@gmail.com> wrote:
> On Wed, May 14, 2008 at 4:16 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Wed, 14 May 2008 01:01:29 -0700 Andrew Morton wrote:
> >
> >>
> >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/
> >
> > net/built-in.o: In function `init_p9':
> > mod.c:(.init.text+0x4b0d): undefined reference to `p9_trans_fd_init'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> >
> >
> > CONFIG_NET_9P=y
> > CONFIG_NET_9P_FD=m
> > CONFIG_NET_9P_VIRTIO=m
> > CONFIG_NET_9P_DEBUG=y
> >
> > # CONFIG_9P_FS is not set
> >
>

(top-posting repaired)

> This is probably a side effect of the merge issue v9fs-devel and -mm
> had last week.  It should no longer be possible with the code that's
> been in my v9fs-devel tree on kernel.org for the past 5 days
> (CONFIG_NET_9P_FD no longer exists).

But I'm still reverting the v9fs tree due to

git-v9fs is causing i386 allmodconfig failures:

net/9p/trans_fd.o: In function `init_module':
trans_fd.c:(.init.text+0x0): multiple definition of `init_module'
net/9p/mod.o:mod.c:(.init.text+0x0): first defined here
/opt/crosstool/gcc-4.1.0-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-unknown-linux-gnu-ld: Warning: size of symbol `init_module' changed from 27 in net/9p/mod.o to 128 in net/9p/trans_fd.o


