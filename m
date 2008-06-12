Return-Path: <linux-kernel-owner+w=401wt.eu-S1759756AbYFLKmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbYFLKmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYFLKmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:42:36 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:50082 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752757AbYFLKmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:42:35 -0400
X-Greylist: delayed 722 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2008 06:42:35 EDT
Message-ID: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de>
Date: Thu, 12 Jun 2008 12:30:31 +0200
From: lists@ku-gbr.de
To: linux-kernel@vger.kernel.org
Subject: XFS internal error xfs_trans_cancel at line 1163 of file
	fs/xfs/xfs_trans.c
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.2-RC1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Today morning my server at home bailed out two times (reboot between):

Jun 12 07:23:40 zappa Filesystem "sda7": XFS internal error  
xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller  
0xffffffff802fa8f5
Jun 12 07:23:40 zappa Pid: 2379, comm: procmail Not tainted  
2.6.25-gentoo-r4 #3
Jun 12 07:23:40 zappa
Jun 12 07:23:40 zappa Call Trace:
Jun 12 07:23:40 zappa [<ffffffff802fa8f5>]
Jun 12 07:23:40 zappa [<ffffffff802f4d71>]
Jun 12 07:23:40 zappa [<ffffffff802fa8f5>]
Jun 12 07:23:40 zappa [<ffffffff803038bb>]
Jun 12 07:23:40 zappa [<ffffffff8025f1e1>]
Jun 12 07:23:40 zappa [<ffffffff80261899>]
Jun 12 07:23:40 zappa [<ffffffff8025ae00>]
Jun 12 07:23:40 zappa [<ffffffff80257010>]
Jun 12 07:23:40 zappa [<ffffffff80256d92>]
Jun 12 07:23:40 zappa [<ffffffff80257077>]
Jun 12 07:23:40 zappa [<ffffffff8020ad3b>]
Jun 12 07:23:40 zappa
Jun 12 07:23:40 zappa xfs_force_shutdown(sda7,0x8) called from line  
1164 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff802f4d8a
Jun 12 07:23:40 zappa Filesystem "sda7": Corruption of in-memory data  
detected.  Shutting down filesystem: sda7
Jun 12 07:23:40 zappa Please umount the filesystem, and rectify the problem(s)

Jun 12 08:15:58 zappa Filesystem "sda7": XFS internal error  
xfs_trans_cancel at line 1163 of file fs/xfs/xfs_trans.c.  Caller  
0xffffffff802fa8f5
Jun 12 08:15:58 zappa Pid: 2161, comm: procmail Not tainted  
2.6.25-gentoo-r4 #3
Jun 12 08:15:58 zappa
Jun 12 08:15:58 zappa Call Trace:
Jun 12 08:15:58 zappa [<ffffffff802fa8f5>]
Jun 12 08:15:58 zappa [<ffffffff802f4d71>]
Jun 12 08:15:58 zappa [<ffffffff802fa8f5>]
Jun 12 08:15:58 zappa [<ffffffff803038bb>]
Jun 12 08:15:58 zappa [<ffffffff8025f1e1>]
Jun 12 08:15:58 zappa [<ffffffff80261899>]
Jun 12 08:15:58 zappa [<ffffffff8025ae00>]
Jun 12 08:15:58 zappa [<ffffffff80257010>]
Jun 12 08:15:58 zappa [<ffffffff80256d92>]
Jun 12 08:15:58 zappa [<ffffffff80257077>]
Jun 12 08:15:58 zappa [<ffffffff8020ad3b>]
Jun 12 08:15:58 zappa
Jun 12 08:15:58 zappa xfs_force_shutdown(sda7,0x8) called from line  
1164 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff802f4d8a
Jun 12 08:15:58 zappa Filesystem "sda7": Corruption of in-memory data  
detected.  Shutting down filesystem: sda7
Jun 12 08:15:58 zappa Please umount the filesystem, and rectify the problem(s)


The partitition sda7 is my /home directory located on a SATA 750GB  
Harddisk, kernel is vanilla 2.6.25. The fs is 100GB sized and 12%  
filled with several small files (imap mailspool).

I investigated the system and while anything else behaves normal, I  
found no error in syslog or with smartctl regarding a possible sector  
reaad/write error or anything else.
Sadly I lost my ssh connection now until this evening, but xfs_check  
put out a line like "xxx-count is 1 but counted 0 in ag17" after I was  
instructed to remount the system once to replay the log (which  
worked). Backups are finished, I wanted to run xfs_repair now...

Is this something I should worry about or the xfs Folks?

Kind Regards, Konsti


----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
