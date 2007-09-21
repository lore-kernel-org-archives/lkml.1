Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbXIUOky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbXIUOky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbXIUOkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:40:47 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:44760 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbXIUOkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:40:47 -0400
From: Vitaliy Gusev <vgusev@openvz.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Problem: LTP linkat01 test fails on nfs directory (NFS v3)
Date: Fri, 21 Sep 2007 18:39:35 +0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
References: <46F1541B.2040800@sw.ru> <200709211313.01040.vgusev@sw.ru> <1190378227.6680.10.camel@heimdal.trondhjem.org>
In-Reply-To: <1190378227.6680.10.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709211839.35883.vgusev@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On the Friday 21 September 2007 16:37 Trond Myklebust, wrote:
> On Fri, 2007-09-21 at 13:13 +0400, Vitaliy Gusev wrote:
> > Hello.
> >
> > Tested kernels: 2.6.18, 2.6.22, 2.6.23-rc2
> >
> > Steps to reproduce: Suppose that we have mounted some directory from nfs
> > v3 server with default options. Also we  have the two directories in this
> > mountpoint and each directory has hard linked file. Try to open those
> > files and write to one and read from another. Data will not be equal.
> > (Testcase: attached hardlink_test.c)
>
> Please retry after re-exporting the filesystem using the highly
> recommended "no_subtree_check" option. The default subtree_check option
> is broken: it changes the filehandle of the file upon a cross-directory
> rename() of that file.

Ok, problem goes out. Default option depends on nfs-utils release.

> >
> > Please explain why nfs_find_actor() function compares file handles?
>
> 'cos this is the only way to know that two files are the same. fileid is
> not always supported by servers: it is an optional NFSv4 attribute, and

>From RFC3010 ( NFSv4 ) section 2.4.1 :
   "For example, if paths /a/b/c and /a/d/c refer to the same file, the       
server SHOULD return the same filehandle for both path names traversals".

For NFSv4  problem should not be shown.

> on NFSv3, most non-posix filesystems will fake it using something like
> iunique().
>
> Comparing filehandles allows you to be certain that two files are the
> same if the filehandles are equal. If they are not equal, then that does
> not guarantee that the files are different, but then how else are you
> going to determine it?
>

-- 
Thanks,
Vitaliy Gusev

