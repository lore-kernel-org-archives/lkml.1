Return-Path: <linux-kernel-owner+w=401wt.eu-S1763108AbYDBV6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763108AbYDBV6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759594AbYDBV5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:57:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:53210 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759114AbYDBV5b (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:57:31 -0400
Date: Thu, 3 Apr 2008 07:57:20 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: xfs_io "BUG: lock held when returning to user space!" on suspend
Message-ID: <20080402215720.GI103491721@sgi.com>
References: <47F3D76E.1070400@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47F3D76E.1070400@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 11:58:54AM -0700, Jeremy Fitzhardinge wrote:
> I'm getting this:
> 
> ================================================
> [ BUG: lock held when returning to user space! ]
> ------------------------------------------------
> xfs_io/18796 is leaving the kernel with locks still held!
> 1 lock held by xfs_io/18796:
> #0:  (&type->s_umount_key#19){----}, at: [<c048c9ac>] get_super+0x42/0x87
> 
> when I suspend, possibly during an xfs-freeze.  There don't seem to be any 
> ill-effects.

Yup, both the sb->s_umount and bdev->bd_mount_sem seaphores are held
across freeze_bdev()/thaw_bdev(), and they are issued via separate
ioctls generally from separate processes. Not great design, but not
a bug....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
