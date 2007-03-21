Return-Path: <linux-kernel-owner+w=401wt.eu-S933741AbXCUTNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933741AbXCUTNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933763AbXCUTNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:13:49 -0400
Received: from tag.witbe.net ([81.88.96.48]:38776 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933741AbXCUTNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:13:48 -0400
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Why is /dev on a different filesystem ? [Kernel 2.6.20.3]
Date: Wed, 21 Mar 2007 20:13:50 +0100
Organization: AS2917.net
Message-ID: <04ea01c76bed$11b0d050$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: Acdr7QzT9Ayu9il8QM+n3PvJmknhZg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was trying to backup a machine using tar and the --one-file-system option
and I was getting an archive without /dev, but tar was spitting :
/dev: file is on a different filesystem; not dumped

So, I had a look at the code in tar, and the comparison is done on the
stat.st_dev field... 
I then wrote a simple program to stat("/", ...) and stat("/dev", ...),
and got :

For / :
st_dev   : 769
st_ino   : 2
st_mode  : 16877
st_nlink : 23
st_uid   : 0
st_gid   : 0
st_rdev  : 0
st_size  : 4096

For /dev :
st_dev   : 15
st_ino   : 1117
st_mode  : 16877
st_nlink : 23
st_uid   : 0
st_gid   : 0
st_rdev  : 0
st_size  : 165580

So, obviously, tar is right...
man 2 stat says :
       The st_dev field describes the device on which this file resides.

and df -a reports :
[root@host-181 src]# df -a
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/hda1              7936256   3105556   4421048  42% /
proc                         0         0         0   -  /proc
sysfs                        0         0         0   -  /sys
devpts                       0         0         0   -  /dev/pts
tmpfs                   517632         0    517632   0% /dev/shm
/dev/hda5             61787140    237360  58360480   1% /usr/local/witbe
/dev/hda2              4956316    142292   4558192   4% /var/log
none                         0         0         0   -
/proc/sys/fs/binfmt_misc

So, obviously, /dev is on /, but the stat(2) says no.
Who is right, and where is the bug ?

Kernel 2.4 had it right : /dev was on /, no doubt.

Regards,
Paul

