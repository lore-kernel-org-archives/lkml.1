Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbYIAM0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbYIAM0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 08:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbYIAM0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 08:26:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:42030 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbYIAM03 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 08:26:29 -0400
Date: Mon, 01 Sep 2008 21:25:40 +0900 (JST)
Message-Id: <20080901.212540.68831117.ryusuke@osrg.net>
To: joern@logfs.org
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20080829191621.GD27647@logfs.org>
References: <20080829104459.GB27647@logfs.org>
	<20080830.013729.49169215.ryusuke@osrg.net>
	<20080829191621.GD27647@logfs.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 21:16:22 +0200, Jörn Engel wrote:
> On Sat, 30 August 2008 01:37:29 +0900, Ryusuke Konishi wrote:
> > On the other hand, there are some differences in premise because nilfs
> > is aiming at racking up past user data and makes it a top priority to
> > keep data which is overwritten by recent updates.  If users want to
> > preserve much data in nilfs, it will increase the chance of disk fulls
> > than regular file systems.
> 
> Hm, good point.  With continuous snapshots the rules of the game change
> considerably.  So maybe it is ok to depend on the userspace daemon here,
> because the space is unreclaimable anyway.
> 
> What is the policy on deleting continuous snapshots?  Or can it even be
> configured by the administrator (which would be cool)?

First, nilfs never deletes the checkpoints marked as snapshot nor the
recent checkpoints whose elapsed time from its creation is smaller than
``protection period''.  These are ground rules.

Based on the rules, the userland GC daemon can delete arbitrary
checkpoints among removable checkpoints.  But the current GC just
deletes the removable checkpoints in chronological order.  More
sophisticated policies, for example, the one detects landmark
checkpoints and tries to keep them (a known policy in versioning
filesystems), may be conceivable.

But I feel the current policy is simple and satisfactory, so I'd like
to leave others to someone who wants to implement them (e.g. one of my
colleagues).

Regards,
Ryusuke Konishi
