Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbXD0P3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbXD0P3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbXD0P3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:29:49 -0400
Received: from sandeen.net ([209.173.210.139]:25558 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756002AbXD0P3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:29:48 -0400
Message-ID: <463216EA.20203@sandeen.net>
Date: Fri, 27 Apr 2007 10:29:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] sysfs: fix i_ino handling in sysfs
References: <11760923274128-git-send-email-htejun@gmail.com>
In-Reply-To: <11760923274128-git-send-email-htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Inode number handling was incorrect in two ways.
> 
> 1. sysfs uses the inode number allocated by new_inode() and never
>    hashes it.  When reporting the inode number, it uses iunique() if
>    inode is inaccessible.  This is incorrect because iunique() assumes
>    the inodes are hashed.  This can cause duplicate inode numbers and
>    the condition is likely to happen because new_inode() and iunique()
>    use separate increasing static counters to scan for empty slot.
> 
> 2. sysfs_dirent->s_dentry can go away anytime and can't be referenced
>    unless the caller knows the dentry is not and not going to be
>    deleted.
> 
> This patch makes sysfs report the pointer to sysfs_dirent as ino.
> ino_t is always as big as or larger than unsigned long && sysfs_dirent
> hierarchy is the internal representation of the sysfs tree, so it
> makes sense and simple to implement.

what about 32-bit stats from 32-bit apps on 64-bit systems?  This will 
make 64-bit inode numbers commonplace in sysfs; will this cause 
problems?  it seems that if they get truncated to 32 bits the 
possibility of duplicate inode nrs will come back...

-Eric
