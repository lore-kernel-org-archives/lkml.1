Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbYEODFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbYEODFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYEODE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:04:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753714AbYEODE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:04:57 -0400
Date: Wed, 14 May 2008 20:04:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric Van Hensbergen" <ericvh@gmail.com>
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net
Subject: Re: 2.6.26-rc2-mm1 (p9 build error when 9P_FS=n)
Message-Id: <20080514200435.66f30c72.akpm@linux-foundation.org>
In-Reply-To: <a4e6962a0805141929q14b1bec6r4c152625b20eb6a@mail.gmail.com>
References: <20080514010129.4f672378.akpm@linux-foundation.org>
	<20080514141630.bcf8d0cd.randy.dunlap@oracle.com>
	<a4e6962a0805141700x3565e40fieda66f8a5a0a4d7a@mail.gmail.com>
	<20080514170543.a0130556.akpm@linux-foundation.org>
	<a4e6962a0805141929q14b1bec6r4c152625b20eb6a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 21:29:08 -0500 "Eric Van Hensbergen" <ericvh@gmail.com> wrote:

> On Wed, May 14, 2008 at 7:05 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 14 May 2008 19:00:12 -0500
> > "Eric Van Hensbergen" <ericvh@gmail.com> wrote:
> >
> > But I'm still reverting the v9fs tree due to
> >
> > git-v9fs is causing i386 allmodconfig failures:
> >
> > net/9p/trans_fd.o: In function `init_module':
> > trans_fd.c:(.init.text+0x0): multiple definition of `init_module'
> > net/9p/mod.o:mod.c:(.init.text+0x0): first defined here
> > /opt/crosstool/gcc-4.1.0-glibc-2.3.6/i686-unknown-linux-gnu/bin/i686-unknown-linux-gnu-ld: Warning: size of symbol `init_module' changed from 27 in net/9p/mod.o to 128 in net/9p/trans_fd.o
> >
> 
> Okay, clearly I'm doing something wrong.  I've tried the allmodconfig
> on my local sandbox and its fine.  When I look to see if there is
> still a module_init in net/9p/trans_fd on kernel.org via gitweb, I
> can't find it. (http://git.kernel.org/?p=linux/kernel/git/ericvh/v9fs.git;a=blob;f=net/9p/trans_fd.c;h=4507f744f44e527cc140b6b5601e556c10bfd361;hb=v9fs-devel)

It has mysteriously gone away.  Perhaps it was triggered by some other
tree which was later fixed.

> Are you pulling from my v9fs-devel tree or is --mm switched over to
> pull from linux-next or something?

The algorithm to determine this is to look at the first line of -mm's
git-v9fs.patch:

ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.26-rc2/2.6.26-rc2-mm1/broken-out/git-v9fs.patch
has:

GIT 38bfbd9f766f0b33de6bc16fd9ad1018b8fd3fe2 git+ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git#v9fs-devel

Yes, -mm uses both linux-next and git-v9fs (aka #v9fs-devel)

linux-next uses #for-next and afacit that was empty as of a few hours
ago.  Nothing for 2.6.27?
