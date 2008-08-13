Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbYHMG4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbYHMG4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 02:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYHMGz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 02:55:56 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:50621 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752461AbYHMGzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 02:55:55 -0400
Message-ID: <48A28559.1040904@linux.vnet.ibm.com>
Date: Wed, 13 Aug 2008 12:25:21 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080724)
MIME-Version: 1.0
To: linux-ext4@vger.kernel.org
CC: kernel list <linux-kernel@vger.kernel.org>,
       aneesh.kumar@linux.vnet.ibm.com
Subject: [BUG] 2.6.27-rc1 - ext4 e2fsck false prompting for fixing i_size
 of Inode 
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While running e2fsck over the partition which was ext4 mounted,
the e2fsck suggest fixing the Inode with the same i_size value
as the existing one.

The partition is of size 135GB, I created 13 files each of 10GB
using  dd if=/dev/zero of=<filename> bs=1024 count=10485760 and
filesystem check on the partition prompts for following fixing

/usr/local/e2fsprogs/sbin/e2fsck -fnv /dev/sdb5
e2fsck 1.41.0 (10-Jul-2008)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 524289, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 655361, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 1835009, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 2490369, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 2621441, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 3801089, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 4587521, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 4587522, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 4587523, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 4587524, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 4587525, i_size is 10737418240, should be 10737418240.  Fix? no
Inode 4587526, i_size is 10737418240, should be 10737418240.  Fix? no

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

/dev/sdb5: ********** WARNING: Filesystem still has errors **********


      24 inodes used (0.00%)
       1 non-contiguous inode (4.2%)
         # of inodes with ind/dind/tind blocks: 13/13/13
34689232 blocks used (96.80%)
       0 bad blocks
      14 large files

      13 regular files
       2 directories
       0 character device files
       0 block device files
       0 fifos
       0 links
       0 symbolic links (0 fast symbolic links)
       0 sockets
--------
      15 files

# /usr/local/e2fsprogs/sbin/e2fsck -V
e2fsck 1.41.0 (10-Jul-2008)
        Using EXT2FS Library version 1.41.0, 10-Jul-2008

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
