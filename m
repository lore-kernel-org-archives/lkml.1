Return-Path: <linux-kernel-owner+w=401wt.eu-S1758507AbYH2Qig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507AbYH2Qig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbYH2QiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:38:24 -0400
Received: from sh.osrg.net ([192.16.179.4]:52972 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573AbYH2QiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:38:23 -0400
Date: Sat, 30 Aug 2008 01:37:29 +0900 (JST)
Message-Id: <20080830.013729.49169215.ryusuke@osrg.net>
To: joern@logfs.org
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20080829104459.GB27647@logfs.org>
References: <20080827181904.GD1371@logfs.org>
	<200808290629.AA00218@capsicum.lab.ntt.co.jp>
	<20080829104459.GB27647@logfs.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 12:45:00 +0200, Jörn Engel wrote:
> > The GC of NILFS depends on the userspace daemon to make policy decisions.
> > NILFS cannot reclaim disk space on its own though it can work 
> > (i.e. read, write, or do other operations) without the daemon.
> > After it runs out of free space, disk full errors will be returned
> > until GC makes new space.
> 
> This looks problematic.  In logfs I was very careful to define a
> "filesystem full" condition that is independent of GC.  So with a single
> writer, -ENOSPC always means the filesystem is full and the only way to
> gain some free space is by deleting data again.
> ...
> > But, usually the GC will make enough disk space in the background
> > before that occurs.
> 
> Usually, yes.  You just have to make sure that in the unusual cases the
> filesystem continues to behave correctly. ;)

As the side remark, the GC of nilfs runs in the background, not
started after it runs out of free space.  Basically the intended
meaning of -ENOSPC is same; it does not mean the GC is ongoing, but
means the deletion is required.  Of course this depends on the
condition that the GC has been working with enough speed, so the
meaning is not assured strictly.  But, at least I won't return -ENOSPC
so easily, and will deal it more politely if needed.

On the other hand, there are some differences in premise because nilfs
is aiming at racking up past user data and makes it a top priority to
keep data which is overwritten by recent updates.  If users want to
preserve much data in nilfs, it will increase the chance of disk fulls
than regular file systems.

Cheers,
Ryusuke
