Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbZJNMpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbZJNMpB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 08:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZJNMpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 08:45:00 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46504 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860AbZJNMpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 08:45:00 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=9_WeqHRTxoWf3U7J4foA:9
 a=fM1cnLxrdrSghlUY40tKnxrDyScA:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: XFS cpu use and slowness
Date: Wed, 14 Oct 2009 06:44:22 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-git2; KDE/4.3.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200910140644.22910.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've recently had a couple issues with XFS.

First off I've noticed a few times that XFS becomes VERY slow when its near 
full (a few GB free), even when it's not fragmented. Reads slow down to 
something on the order of 1MB/s, when at full speed I can generally pull 
200MB/s off the raid5 array (its been a long time since I've seen speed 
anywhere near that off of the file system).

And second, I see one or more of the xfsdatad threads using up a significant 
amount of CPU time (30%+) when running a test like: `iozone -s 8G -A` on my 
new 5 disk md raid0 array. Its pretty fast however (570MBs write, 380MB/s 
read). That said, flush-9:0 and kswapd0* also like to use up a lot of cpu at 
the same time (10-30% cpu each)

So it seems xfs is fast when its a fresh file system, but degrades over time 
(I have xfs_fsr set to run automatically every day on my existing xfs fs, I 
can't see it being very fragmented).

* I have no idea why kswapd0 would be using that much cpu, system has 4G ram, 
and most of it is file/disk cache. Doing the tests however seems to push more 
and more into swap. Started out as 0M, during the first test it moved up to 
1MB, and now during a second test its up to 14MB. Not a lot, but more than I 
expected.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
