Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYHZKQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYHZKQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 06:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYHZKQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 06:16:40 -0400
Received: from lazybastard.de ([212.112.238.170]:52775 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbYHZKQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 06:16:39 -0400
Date: Tue, 26 Aug 2008 12:16:19 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
Message-ID: <20080826101618.GA17261@logfs.org>
References: <20080820004326.519405a2.akpm@linux-foundation.org> <200808201613.AA00212@capsicum.lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808201613.AA00212@capsicum.lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 August 2008 01:13:45 +0900, Ryusuke Konishi wrote:
> >On Wed, 20 Aug 2008 11:45:05 +0900 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:
> 
> 4. To make disk blocks relocatable, NILFS2 maintains a table file (called DAT)
>    which maps virtual disk blocks addresses to usual block addresses.
>    The lifetime information is recorded in the DAT per virtual block address.

Interesting approach.  Does that mean that every block lookup involves
two disk accesses, one for the DAT and one for the actual block?

> The current NILFS2 GC simply reclaims from the oldest segment, so the disk
> partition acts like a ring buffer. (this behaviour can be changed by 
> replacing userland daemon).

Is this userland daemon really necessary?  I do all that stuff in
kernelspace and the amount of code I have is likely less than would be
necessary for the userspace interface alone.  Apart from creating a
plethora of research papers, I never saw much use for pluggable
cleaners.

Did you encounter any nasty deadlocks and how did you solve them?
Finding deadlocks in the vfs-interaction became a hobby of mine when
testing logfs and at least one other lfs seems to have had similar
problems - they exported the inode_lock in their patch. ;)

Jörn

-- 
Consensus is no proof!
-- John Naisbitt
