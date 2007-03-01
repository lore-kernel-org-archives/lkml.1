Return-Path: <linux-kernel-owner+w=401wt.eu-S1161103AbXCAWxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161103AbXCAWxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 17:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161107AbXCAWxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 17:53:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52654 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161103AbXCAWxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 17:53:51 -0500
Date: Thu, 1 Mar 2007 14:52:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: nscott@aconex.com
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-Id: <20070301145256.3e999932.akpm@linux-foundation.org>
In-Reply-To: <1172788855.26078.294.camel@edge>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070301142537.b5950cd7.akpm@linux-foundation.org>
	<1172788855.26078.294.camel@edge>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007 09:40:54 +1100
Nathan Scott <nscott@aconex.com> wrote:

> On Thu, 2007-03-01 at 14:25 -0800, Andrew Morton wrote:
> > On Fri, 2 Mar 2007 00:04:45 +0530
> > "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> > 
> > > This is to give a heads up on few patches that we will be soon coming up
> > > with. These patches implement a new system call sys_fallocate() and a
> > > new inode operation "fallocate", for persistent preallocation. The new
> > > system call, as Andrew suggested, will look like:
> > > 
> > >   asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
> > ...
> > 
> > I'd agree with Eric on the "command" flag extension.
> 
> Seems like a separate syscall would be better, "command" sounds
> a bit ioctl like, especially if that command is passed into the
> filesystems..
> 

madvise, fadvise, lseek, etc seem to work OK.

I get repeatedly traumatised by patch rejects whenever a new syscall gets
added, so I'm biased.

The advantage of a command flag is that we can add new modes in the future
without causing lots of churn, waiting for arch maintainers to catch up,
potentially adding new compat code, etc.

Rename it to "mode"? ;)

I'm inclined to merge this patch nice and early, so the syscall number is
stabilised.  Otherwise the people who are working on out-of-tree code (ie:
ext4) will have to keep playing catchup.

