Return-Path: <linux-kernel-owner+w=401wt.eu-S1751382AbXCDQZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbXCDQZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXCDQZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:25:12 -0500
Received: from web52514.mail.yahoo.com ([206.190.48.197]:45177 "HELO
	web52514.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751382AbXCDQZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:25:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Oj5VU6XPeS7c8KFk5lILJ0Yvqzogn+cAHK+EcRIztyCBwDcYk0OaHV0wUv1BerRDuMPchhF3Bc/8lYaumX+nkZ3fWOFcC7a5toJEhGs4vEPT3V7Hpv/hVXD568v4FJncn7Z6AF12M6CqesnqjUjt8Ro0ioknuya3HEF6wGje8BY=;
X-YMail-OSG: zvT5p0sVM1nCgyESGa28ZSUiPc6pzoWPpiD0p.2wPuboJ2Klf3MkI_b_KGW4sDDoZg1dwLumg7Fb9X.0WSVqpaWXk9RCMfQA_Pyn2PZKfCjnGr1BijQyhpQkTmTFHxIARw_TtgHPt7Ozn3A-
Date: Sun, 4 Mar 2007 08:25:09 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Raid 10 Problems?
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <742277.25048.qm@web52514.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Running into a problem and not sure what I'm doing
wrong. Created a software raid 10 array. Everything
seems to be normal except that if you take the array
down and run e2fsck on it there are always errors,
mostly all little stuff and it recovers without losing
any data.

I'm running the latest OpenVZ kernel 2.6.18. I'm not
sure if this is a factor or not as the problem occurs
without starting any VEs.

The problem will happen most all the time. I can
format the partition, put the data on it then shut it
down and run 2efsck and there will be some errors to
fix.

In the past after running for weeks the raid array
will unexpectedly go inti read only mode due to the
errors. After running e2fsck it will run normal again.

I've never used raid 10 before (stripes on top of 2
mirrors) so I don't have anything to compare this
with. I'm just wondering if I'm doing something wrong.
I am using ACL and dir_index attributes.

If I run e2fsck twice in a row it comes up with no
errors he second time. However if I mount the /dev/md2
device and then immediately umount it and run e2fsck
again I get some errors. Here's a run I did just
mounting and unmounting immediately.

e2fsck 1.39 (29-May-2006)
Pass 1: Checking inodes, blocks, and sizes
Inode 17172774, i_blocks is 8304, should be 19272.
Fix? yes

Inode 37126149, i_blocks is 872, should be 2192. Fix?
yes

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences: +(39500534--39501904)
+(74267806--74267970)
Fix? yes

Free blocks count wrong for group #1205 (1371,
counted=0).
Fix? yes

Free blocks count wrong for group #2266 (17206,
counted=17041).
Fix? yes

Free blocks count wrong (218321825,
counted=218320289).
Fix? yes


/vz: ***** FILE SYSTEM WAS MODIFIED *****

125791 inodes used (0.11%)
451 non-contiguous inodes (0.4%)
# of inodes with ind/dind/tind blocks: 7086/648/0
15831007 blocks used (6.76%)
0 bad blocks
3 large files

107783 regular files
11529 directories
1584 character device files
10 block device files
3 fifos
1 link
4872 symbolic links (4864 fast symbolic links)
1 socket
--------
125783 files


 
____________________________________________________________________________________
Get your own web address.  
Have a HUGE year through Yahoo! Small Business.
http://smallbusiness.yahoo.com/domains/?p=BESTDEAL
