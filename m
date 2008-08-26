Return-Path: <linux-kernel-owner+w=401wt.eu-S1758590AbYHZQtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590AbYHZQtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 12:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbYHZQs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 12:48:58 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:45762 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbYHZQs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 12:48:57 -0400
Message-Id: <200808261654.AA00216@capsicum.lab.ntt.co.jp>
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Date: Wed, 27 Aug 2008 01:54:30 +0900
To: Jorn Engel <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] nilfs2: continuous snapshotting file system
In-Reply-To: <20080826101618.GA17261@logfs.org>
References: <20080826101618.GA17261@logfs.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008 12:16:19 +0200, Jorn Engel wrote:
>On Thu, 21 August 2008 01:13:45 +0900, Ryusuke Konishi wrote:
>> 
>> 4. To make disk blocks relocatable, NILFS2 maintains a table file (called DAT)
>>    which maps virtual disk blocks addresses to usual block addresses.
>>    The lifetime information is recorded in the DAT per virtual block address.
>
>Interesting approach.  Does that mean that every block lookup involves
>two disk accesses, one for the DAT and one for the actual block?

Simply stated, it's Yes.

But the actual number of disk accesses will become fewer because the DAT is 
cached like regular files and read-ahead is also applied.
The cache for the DAT works well enough.

>> The current NILFS2 GC simply reclaims from the oldest segment, so the disk
>> partition acts like a ring buffer. (this behaviour can be changed by 
>> replacing userland daemon).
>
>Is this userland daemon really necessary?  I do all that stuff in
>kernelspace and the amount of code I have is likely less than would be
>necessary for the userspace interface alone.  Apart from creating a
>plethora of research papers, I never saw much use for pluggable
>cleaners.

Well, that sounds reasonable.
Still I cannot say which is better for now.
My colleague has intention to develop other type of cleaners, and another
colleague experimentally made a cleaner with GUI.
In addition, there are possibilities to integrate attractive features
like defragmentation, background data verification, or remote backups.

>Did you encounter any nasty deadlocks and how did you solve them?
>Finding deadlocks in the vfs-interaction became a hobby of mine when
>testing logfs and at least one other lfs seems to have had similar
>problems - they exported the inode_lock in their patch. ;)
>
>Jorn

Yeah, it was very tough battle :)
Read is OK.  But write was hard.  I looked at the vfs code over again and
again.
We've implemented NILFS without bringing specific changes into vfs.
However, if we can find common basis for LFSes, I'm grad to cooperate 
with you.
Though I don't know whether exporting inode_lock is the case or not ;)

Regards,
Ryusuke Konishi
