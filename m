Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYA0GGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYA0GGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756672AbYA0GFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:05:03 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758200AbYA0GE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:04:58 -0500
Date: Sat, 26 Jan 2008 22:03:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, viro@ftp.linux.org.uk,
       dhowells@redhat.com, wtaber@us.ibm.com, owilliam@br.ibm.com,
       rkissel@us.ibm.com, hch@lst.de
Subject: Re: [PATCH] Fix procfs task exe symlink
Message-Id: <20080126220336.a2a3caf7.akpm@linux-foundation.org>
In-Reply-To: <1201112977.5443.29.camel@localhost.localdomain>
References: <1201112977.5443.29.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 23 Jan 2008 10:29:37 -0800 Matt Helsley <matthltc@us.ibm.com> wrote:
> 
> Andrew, please consider this patch for inclusion in -mm.
> 
> ...
>

Can't say that we're particularly exercised about mvfs's problems, but the
current way of doing /proc/pid/exe is indeed a nasty hack.

> 
>  fs/binfmt_flat.c          |    3 +
>  fs/exec.c                 |    2 +
>  fs/proc/base.c            |   77 ++++++++++++++++++++++++++++++++++++++++++++++
>  fs/proc/internal.h        |    1 
>  fs/proc/task_mmu.c        |   34 --------------------
>  fs/proc/task_nommu.c      |   34 --------------------
>  include/linux/init_task.h |    8 ++++
>  include/linux/mm.h        |   22 +++++++++++++
>  include/linux/mm_types.h  |    7 ++++
>  include/linux/proc_fs.h   |   14 +++++++-
>  kernel/fork.c             |    3 +
>  mm/mmap.c                 |   22 ++++++++++---
>  mm/nommu.c                |   15 +++++++-
>  13 files changed, 164 insertions(+), 78 deletions(-)

It's a fairly expensive fix though.  Can't we just do a strcpy() somewhere
at exec time?


