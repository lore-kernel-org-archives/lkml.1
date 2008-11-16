Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYKPGyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYKPGyD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 01:54:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYKPGxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 01:53:53 -0500
Received: from 5-25-251-64.serverpronto.com ([64.251.25.5]:1416 "EHLO
	mail.kaylix.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751169AbYKPGxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 01:53:52 -0500
Message-ID: <61190.71.201.40.108.1226818429.squirrel@www.kaylix.net>
Date: Sun, 16 Nov 2008 00:53:49 -0600 (CST)
Subject: Calculate logical RAID-6 position from physical position
From: "Wesley Leggette" <wleggette@kaylix.net>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have had a three-disk failure on a RAID 6 array. On the third disk, I
can mostly recover it with dd_rescue, from which I know exactly which
blocks were affected. From this, how can I calculate the logical positions
that will be affected when I reassemble the RAID?

This is 2.6.26-bpo.1-686-bigmem (Debian 2.6.26-4~bpo40+1)

I'm looking for a general formula, but my specific scenario is:

/dev/md0:
       Version : 01.00.03
 Creation Time : Sun Sep 30 09:14:07 2007
    Raid Level : raid6
    Array Size : 6349009472 (6054.89 GiB 6501.39 GB)
   Device Size : 976770688 (465.76 GiB 500.11 GB)
  Raid Devices : 15
 Total Devices : 13
Preferred Minor : 0
   Persistence : Superblock is persistent

   Update Time : Sat Nov 15 02:32:54 2008
         State : clean, degraded
Active Devices : 13
Working Devices : 13
Failed Devices : 0
 Spare Devices : 0

    Chunk Size : 64K

          Name : 'fargo':0
          UUID : 64107957:2bad471d:603d9582:796e97f5
        Events : 3279764

   Number   Major   Minor   RaidDevice State
      0       8      128        0      active sync   /dev/sdi
      1       8      240        1      active sync   /dev/sdp
      2       8       80        2      active sync   /dev/sdf
      3       8      160        3      active sync   /dev/sdk
      4       0        0        4      removed
      5       8      176        5      active sync   /dev/sdl
     15       8      224        6      active sync   /dev/sdo
      7       8       96        7      active sync   /dev/sdg
      8       8       64        8      active sync   /dev/sde
      9       8      192        9      active sync   /dev/sdm
     18       8       48       10      active sync   /dev/sdd
     16       8       32       11      active sync   /dev/sdc
     12       0        0       12      removed
     13       8      112       13      active sync   /dev/sdh
     17       8      208       14      active sync   /dev/sdn


After some time, position 17 (/dev/sdn) was the disk that failed. The
failure is 152 blocks from  5741236.0k to  5741311.5k. This is what I want
to map to the logical layout.


Wesley Leggette
