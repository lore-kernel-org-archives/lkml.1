Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbXKVSUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbXKVSUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 13:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXKVSU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 13:20:27 -0500
Received: from cfif3.ist.utl.pt ([193.136.161.44]:32933 "EHLO cfif3.ist.utl.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXKVSU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 13:20:26 -0500
From: paulo@cfif3.ist.utl.pt
Message-Id: <200711221820.lAMIKFkQ005124@cfif3.ist.utl.pt>
Subject: Re: kernel BUG at fs/inode.c
To: jack@suse.cz
Date: Thu, 22 Nov 2007 18:20:15 +0000 (WET)
Cc: linux-kernel@vger.kernel.org
Reply-to: paulo.nogueira@ist.utl.pt
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



  Hi,

>  Thanks for report. It looks like a problem in UDF. Actually I think
> I've already seen a similar report. Are there any IO errors in the logs
> or anything else suspitious?


 At the risk of reporting further bugs :-) here it goes:

=======================================================================

 1)

 Something I've recently reported to the e-mail address listed
 on the mkudffs manpage:

 ...a small problem with mkudffs, as obtained from
 udftools-1.0.0b3-7.fc6.

 The problem is as follows: if I take a new DVD-RAM, create (say)
 an ext3 filesystem, and some time later I run mkudffs over it,
 then when I try to mount it the disk still seems to remember
 about having had a previous filesystem.
 What I mean is that mount may succeed if one specifies the newer
 filesystem, at least if no files have been copied yet, and also
 succeed with the older filesystem.

 Here is an example, for the same disk(!) without any formatting
 nor copying in between (note also the dates)

# mount /dev/scd0 /mnt/dvd -t udf
# ll /mnt/dvd/
total 4
drwxr-xr-x  3 root root   92 2007-11-21 18:34 ./
drwxr-xr-x 13 root root 4096 2007-09-03 17:27 ../
drwxr-xr-x  2 root root   40 2007-11-21 18:34 lost+found/

# umount /mnt/dvd
# mount /dev/scd0 /mnt/dvd -t ext3
# ll /mnt/dvd/
total 24
drwxr-xr-x  3 root root  4096 2007-11-21 19:29 ./
drwxr-xr-x 13 root root  4096 2007-09-03 17:27 ../
drwx------  2 root root 16384 2007-11-21 19:29 lost+found/


 Eventually I found that I could erase the (or at least part of the)
 information that remained from ext3 by using fdisk to set a filesystem
 of type "0" ("empty") and then running mkudffs over.

 That is not very practical of course, and I am also not completely
 sure that no other outdated info remains on the disk.

=======================================================================

 2)

 With 2.6.24-rc1-git10 (did not see it with other kernels yet)

 # find /proc -name cdrom
 /proc/sys/dev/cdrom
 find: WARNING: Hard link count is wrong for /proc/net: this may be
 a bug in your filesystem driver.  Automatically turning on find's
 -noleaf option.  Earlier results may have failed to include
 directories that should have been searched.

=======================================================================

 3)

 While I am at it, here's a suggestion. One of my DVD-RAM disks
 had apparently some (likely minor) problems, because I've just
 found the following notice in /var/log/messages :

 ... kernel: EXT3-fs warning: mounting fs with errors, running
 e2fsck is recommended

 This message appears 11 times in that file. I've never seen it
 displayed on an xterm, although I always mount the disks "by hand",
 on the command line!

 The request/suggestion is (obviously) please send that message to
 syserror too!!


=======================================================================


 Which other logs should I look at?

  Best regards
   Paulo


