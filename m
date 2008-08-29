Return-Path: <linux-kernel-owner+w=401wt.eu-S1758970AbYH2TQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970AbYH2TQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 15:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYH2TQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 15:16:36 -0400
Received: from lazybastard.de ([212.112.238.170]:57316 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbYH2TQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 15:16:35 -0400
Date: Fri, 29 Aug 2008 21:16:22 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
Message-ID: <20080829191621.GD27647@logfs.org>
References: <20080827181904.GD1371@logfs.org> <200808290629.AA00218@capsicum.lab.ntt.co.jp> <20080829104459.GB27647@logfs.org> <20080830.013729.49169215.ryusuke@osrg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080830.013729.49169215.ryusuke@osrg.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 August 2008 01:37:29 +0900, Ryusuke Konishi wrote:
> 
> As the side remark, the GC of nilfs runs in the background, not
> started after it runs out of free space.  Basically the intended
> meaning of -ENOSPC is same; it does not mean the GC is ongoing, but
> means the deletion is required.  Of course this depends on the
> condition that the GC has been working with enough speed, so the
> meaning is not assured strictly.  But, at least I won't return -ENOSPC
> so easily, and will deal it more politely if needed.
> 
> On the other hand, there are some differences in premise because nilfs
> is aiming at racking up past user data and makes it a top priority to
> keep data which is overwritten by recent updates.  If users want to
> preserve much data in nilfs, it will increase the chance of disk fulls
> than regular file systems.

Hm, good point.  With continuous snapshots the rules of the game change
considerably.  So maybe it is ok to depend on the userspace daemon here,
because the space is unreclaimable anyway.

What is the policy on deleting continuous snapshots?  Or can it even be
configured by the administrator (which would be cool)?

Jörn

-- 
The cheapest, fastest and most reliable components of a computer
system are those that aren't there.
-- Gordon Bell, DEC labratories
