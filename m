Return-Path: <linux-kernel-owner+w=401wt.eu-S1763495AbXHaBZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763495AbXHaBZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 21:25:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbXHaBZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 21:25:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44139 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750903AbXHaBZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 21:25:27 -0400
Date: Thu, 30 Aug 2007 18:24:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>
Subject: Re: recent nfs change causes autofs regression
Message-Id: <20070830182435.e921ea44.akpm@linux-foundation.org>
In-Reply-To: <1188513433.6626.24.camel@heimdal.trondhjem.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>
	<1188513433.6626.24.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 18:37:13 -0400 Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Thu, 2007-08-30 at 14:07 -0700, Hua Zhong wrote:
> > I am re-sending this after help from Ian and git-bisect. To me it's a
> > show-stopper: I cannot find an acceptable workaround that I can implement.
> > 
> > The problem: upgrading to 2.6.23-rc4 from 2.6.22 causes several autofs
> > mounts to fail silently - they just not appear when they should.
> > 
> > I believe it's caused by the NFS change that forces multiple mounts from
> > different directories under the same server side filesystem to have the same
> > mount options by default, otherwise it returns EBUSY.
> > 
> > For example, if server has a filesystem /a, and it exports /a/x and /a/y
> > (maybe with rw or ro), and a client must mount /a/x and /a/y with the same
> > mount options now.
> 
> Which is better than having it fail silently, or giving you a mount with
> the wrong mount options.
> 
> If you need to mount the same filesystem with incompatible mount options
> on the same client, then there is a new mount option "nosharecache",
> which enables it.
> The new option is there in order to make it damned clear to sysadmins
> that this is a dangerous thing to do: mounts which don't share the same
> superblock also don't share the same data and attribute caches. Any file
> or directory which appears in both mounts had better only be used by one
> application at a time or be using an appropriate locking scheme.
> 

If we're going to send a message to sysadmins, we shouldn't force them to go
through a git bisection search and a lkml discussion to receive it!

Is there at least some way in which the kernel can detect this situation
and emit a friendly printk which guides people to a friendly document?
