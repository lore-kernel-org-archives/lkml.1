Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZH3OZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZH3OZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 10:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZH3OZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 10:25:06 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:63659 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZH3OZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 10:25:05 -0400
To: Ed Tomlinson <edt@aei.ca>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       nicholas.dokos@hp.com
From: Nick Dokos <nicholas.dokos@hp.com>
Reply-to: nicholas.dokos@hp.com
Subject: Re: Ext4 corruption that will not go away
In-reply-to: Message from Ed Tomlinson <edt@aei.ca> of
 "Sun, 30 Aug 2009 00:25:47 EDT." <200908300025.48034.edt@aei.ca>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
 <20090119113300.GC9482@skywalker>  <200908300025.48034.edt@aei.ca>
X-Mailer: MH-E 8.2; nmh 1.2; GNU Emacs 23.1.50
Date: Sun, 30 Aug 2009 10:24:56 -0400
Message-id: <28421.1251642296@gamaville.dokosmarshall.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> I am running 2.6.31-rc8+ and have ext4 corruption that will not go away.
> 
> My root fs is ext4 on sdb3.  I have moved the directory with corruption into lost+found and booted to a rescuse
> system (arch linux) and run fsck.ext4 on the filesystem, which then reports its clean...  Booting back into my
> gentoo system and attempting to remove the xx directory from lost+found gives:
> 
> [  172.408799] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)                                                                                                
> [  172.429410] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)                                                                                                
> [  172.449920] EXT4-fs error (device sdb3): ext4_ext_check_inode: bad header/extent in inode #706801: invalid magic - magic 0, entries 0, max 0(0), depth 0(0)
> 
> The above is repeatable.
> 
> How can I _really_ clean this fs?  What info is needed to help the process?
> 

The first two pieces of information needed would be the version of e2fsprogs
that you are running (e2fsck -V) and the stat of inode 706801:

  debugfs -R 'stat <706801>' /dev/sdb3

Thanks,
Nick
