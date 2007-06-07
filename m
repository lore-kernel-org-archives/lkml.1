Return-Path: <linux-kernel-owner+w=401wt.eu-S936542AbXFGDpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936542AbXFGDpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 23:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754825AbXFGDpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 23:45:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbXFGDpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 23:45:06 -0400
Date: Wed, 6 Jun 2007 20:44:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Albert Cahalan" <acahalan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ebiederm@xmission.com,
       pbadari@us.ibm.com, torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
Message-Id: <20070606204432.b670a7b1.akpm@linux-foundation.org>
In-Reply-To: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 23:27:01 -0400 "Albert Cahalan" <acahalan@gmail.com> wrote:

> Eric W. Biederman writes:
> > Badari Pulavarty <pbadari@us.ibm.com> writes:
> 
> >> Your recent cleanup to shm code, namely
> >>
> >> [PATCH] shm: make sysv ipc shared memory use stacked files
> >>
> >> took away one of the debugging feature for shm segments.
> >> Originally, shmid were forced to be the inode numbers and
> >> they show up in /proc/pid/maps for the process which mapped
> >> this shared memory segments (vma listing). That way, its easy
> >> to find out who all mapped this shared memory segment. Your
> >> patchset, took away the inode# setting. So, we can't easily
> >> match the shmem segments to /proc/pid/maps easily. (It was
> >> really useful in tracking down a customer problem recently).
> >> Is this done deliberately ? Anything wrong in setting this back ?
> >
> > Theoretically it makes the stacked file concept more brittle,
> > because it means the lower layers can't care about their inode
> > number.
> >
> > We do need something to tie these things together.
> >
> > So I suspect what makes most sense is to simply rename the
> > dentry SYSVID<segmentid>
> 
> Please stop breaking things in /proc. The pmap command relys
> on the old behavior.

What effect did this change have upon the pmap command?  Details, please.

> It's time to revert.

Probably true, but we'd need to understand what the impact was.
