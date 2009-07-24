Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZGXVfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZGXVfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZGXVfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:35:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434AbZGXVfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:35:37 -0400
Date: Fri, 24 Jul 2009 14:34:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, esandeen@redhat.com, eteo@redhat.com,
       eparis@redhat.com, amwang@redhat.com, stable@kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [RESEND Patch v2] allow file truncations when both suid and
 write permissions set
Message-Id: <20090724143419.c479ab00.akpm@linux-foundation.org>
In-Reply-To: <20090722091920.6642.43943.sendpatchset@localhost.localdomain>
References: <20090722091920.6642.43943.sendpatchset@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 05:17:02 -0400
Amerigo Wang <amwang@redhat.com> wrote:

> 
> V1 -> V2:
> Introduce dentry_remove_suid(), and use it in do_truncate().
> Thanks to Eric Paris.
> 
> 
> When suid is set and the non-owner user has write permission,
> any writing into this file should be allowed and suid should be
> removed after that.
> 
> However, current kernel only allows writing without truncations,
> when we do truncations on that file, we get EPERM. This is a bug.
> 
> Steps to reproduce this bug:
> 
> % ls -l rootdir/file1
> -rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
> % echo h > rootdir/file1
> zsh: operation not permitted: rootdir/file1
> % ls -l rootdir/file1
> -rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
> % echo h >> rootdir/file1
> % ls -l rootdir/file1
> -rwxrwxrwx 1 root root 5 Jun 25 16:34 rootdir/file1
> 
> This patch fixes it.

Thanks, I queued this up for Al's consideration.

> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: stable@kernel.org
> Cc: Eric Sandeen <esandeen@redhat.com>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Eugene Teo <eteo@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>

I removed the Cc:stable.  I'm not really sure whether we want to
backport this.

In fact I'm not really sure that we want to merge it at all.  It
introduces the risk that people will develope, test and ship
applications which malfunction when run on older kernels.

otoh we already have the risk that people's applications will run OK on
other OS's and will malfunction on Linux, and the patch fixes this.


