Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbYDCNyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbYDCNyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYDCNyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:54:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38645 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbYDCNyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:54:00 -0400
Subject: Re: xfs_io "BUG: lock held when returning to user space!" on
	suspend
From: Peter Zijlstra <peterz@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080402215720.GI103491721@sgi.com>
References: <47F3D76E.1070400@goop.org> <20080402215720.GI103491721@sgi.com>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 15:53:14 +0200
Message-Id: <1207230794.8514.825.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-03 at 07:57 +1000, David Chinner wrote:
> On Wed, Apr 02, 2008 at 11:58:54AM -0700, Jeremy Fitzhardinge wrote:
> > I'm getting this:
> > 
> > ================================================
> > [ BUG: lock held when returning to user space! ]
> > ------------------------------------------------
> > xfs_io/18796 is leaving the kernel with locks still held!
> > 1 lock held by xfs_io/18796:
> > #0:  (&type->s_umount_key#19){----}, at: [<c048c9ac>] get_super+0x42/0x87
> > 
> > when I suspend, possibly during an xfs-freeze.  There don't seem to be any 
> > ill-effects.
> 
> Yup, both the sb->s_umount and bdev->bd_mount_sem seaphores are held
> across freeze_bdev()/thaw_bdev(), and they are issued via separate
> ioctls generally from separate processes. Not great design, but not
> a bug....

Actually... we do consider that bugs.



