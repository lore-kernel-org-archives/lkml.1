Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbZBRJhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbZBRJhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZBRJh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:37:26 -0500
Received: from welcomes-you.com ([85.214.50.128]:36760 "EHLO
	smtp.welcomes-you.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZBRJhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:37:25 -0500
Message-ID: <499BD6BB.2000406@aei.mpg.de>
Date: Wed, 18 Feb 2009 10:36:59 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: david@fromorbit.com
CC: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: xfs problems (possibly after upgrading from linux kernel	2.6.27.10
 to .14)
References: <499ACE6C.4060304@aei.mpg.de> <20090218091935.GD8830@disturbed>
In-Reply-To: <20090218091935.GD8830@disturbed>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Dave Chinner schrieb:
> On Tue, Feb 17, 2009 at 03:49:16PM +0100, Carsten Aulbert wrote:
>> Hi all,
>>
>> within the past few days we hit many XFS internal errors like these. Are these
>> errors known (and possibly already fixed)? I checked the commits till 
>> 2.6.27.17 and there does not seem anything related to this.
> 
> .....
> 
>> Feb 16 20:34:49 n0035 kernel: [275873.335916] Filesystem "sda6": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_
> 
> A transaction shutdown on create. That implies some kind of ENOSPC
> issue.
> 
>> Do you need more information or can I send these nodes into a re-install?
> 
> More information. Can you get a machine into a state where you can
> trigger this condition reproducably by doing:
> 
> 	mount filesystem
> 	touch /mnt/filesystem/some_new_file
> 
> If you can get it to that state, and you can provide an xfs_metadump
> image of the filesystem when in that state, I can track down the
> problem and fix it.

I can try doing that on a few machines, would a metadump help on a
machine where this corruption occurred some time ago and is still in
this state?

> 
>> Feb 16 22:01:28 n0260 kernel: [1129250.851451] Filesystem "sda6": xfs_iflush: Bad inode 1176564060 magic number 0x36b5, ptr 0xffff8801a7c06c00
> 
> However, this implies some kind of memory corruption is occurring.
> That is reading the inode out of the buffer before flushing the
> in-memory state to disk. This implies someone has scribbled over
> page cache pages.
> 
> 
>> Feb 17 05:57:44 n0463 kernel: [1156816.912129] Filesystem "sda6": XFS internal error xfs_btree_check_sblock at line 307 of file fs/xfs/xfs_btree.c.  Caller 0xffffffff802dd15b
> 
> And that is another buffer that has been scribbled over.
> Something is corrupting the page cache, I think. Whether the
> original shutdown is caused by the some corruption, i don't
> know.
> 

At least on two nodes  we ran memtest86+ overnight and so far no error.

>> plus a few more nodes showing the same characteristics 
> 
> Hmmmm. Did this show up in 2.6.27.10? Or did it start occurring only
> after you upgraded from .10 to .14?

As far as I can see this only happened after the upgrade about 14 days
ago. What strikes me odd is that we only had this occurring massively on
Monday and Tuesday this week.

I don't know if a certain access pattern could trigger this somehow.

Cheers

Carsten
