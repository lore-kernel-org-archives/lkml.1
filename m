Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbYDDBua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbYDDBua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbYDDBuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:50:20 -0400
Received: from relay2.sgi.com ([192.48.171.30]:48152 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750928AbYDDBuT (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:50:19 -0400
Date: Fri, 4 Apr 2008 11:50:06 +1000
From: David Chinner <dgc@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: xfs_io "BUG: lock held when returning to user space!" on suspend
Message-ID: <20080404015006.GC103491721@sgi.com>
References: <47F3D76E.1070400@goop.org> <20080402215720.GI103491721@sgi.com> <1207230794.8514.825.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207230794.8514.825.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 03:53:14PM +0200, Peter Zijlstra wrote:
> On Thu, 2008-04-03 at 07:57 +1000, David Chinner wrote:
> > On Wed, Apr 02, 2008 at 11:58:54AM -0700, Jeremy Fitzhardinge wrote:
> > > I'm getting this:
> > > 
> > > ================================================
> > > [ BUG: lock held when returning to user space! ]
> > > ------------------------------------------------
> > > xfs_io/18796 is leaving the kernel with locks still held!
> > > 1 lock held by xfs_io/18796:
> > > #0:  (&type->s_umount_key#19){----}, at: [<c048c9ac>] get_super+0x42/0x87
> > > 
> > > when I suspend, possibly during an xfs-freeze.  There don't seem to be any 
> > > ill-effects.
> > 
> > Yup, both the sb->s_umount and bdev->bd_mount_sem seaphores are held
> > across freeze_bdev()/thaw_bdev(), and they are issued via separate
> > ioctls generally from separate processes. Not great design, but not
> > a bug....
> 
> Actually... we do consider that bugs.

Ok, you're welcome to fix it then. It's way below my care factor
right now....

FWIW, I did suggest that this needed fixing before FIFREEZE/FITHAW
are introduced, but that hasn't happened yet.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
