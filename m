Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbXEaIUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbXEaIUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 04:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbXEaIUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 04:20:06 -0400
Received: from mailhost.nmt.edu ([129.138.4.52]:49546 "EHLO mailhost.nmt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbXEaIUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 04:20:03 -0400
Date: Thu, 31 May 2007 02:19:57 -0600
From: Valerie Henson <val@nmt.edu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Karuna sagar K <karunasagark@gmail.com>, Amit Gud <gud@cis.ksu.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Cross-chunk reference checking time estimates
Message-ID: <20070531081955.GC31627@rainbow>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey all,

I altered Karuna's cref tool to print the number of seconds it would
take to check the cross-references for a chunk.  The results look good
for chunkfs: on my laptop /home file system and a 1 GB chunk size, the
per-chunk cross-reference check time would be an average of 5 seconds
and a max of 160 seconds in 2013.  This is calculated assuming average
seek time and rotational latency delay for every cross-reference
checked; some simple batching of I/Os could significantly improve
that.

The tool is a little dodgy on error handling and other edge cases ATM,
but for now, here's the results and the code (attached):

val@nifty:~/chunkfs/cref_new$ sudo ./cref.sh /dev/hda3 dump /home 1024
Total size = 19535040 KB
Total data stored = 13998240 KB
Number of files = 445406
Number of directories = 31836
Number of special files = 12156
Size of block groups = 1048576 KB
Inodes per block group = 130304
Intra-file cross references = 63167
Directory-subdirectory references = 429
Directory-file references = 2381
Total directory cross references = 2810
Total cross references = 65977
Total cross references = 65977
Average cross references per group = 439
Maximum cross references in a group = 13997
Max group is 4 (0:3, 1:46, 2:282, 3:4996, 5:8445, 6:2, 7:1, 8:27, 9:1, 10:2, 12:1, 13:51, 14:32, 15:99, 16:2, 17:5, 18:2, )
Average additional time to check cross references = 6.77 s
Max additional time to check cross references = 215.55 s
2013 average additional time to check cross references = 4.93 s
2013 max additional time to check cross references = 156.77 s

Questions?  Come talk on #linuxfs at irc.oftc.net.

-VAL

--2fHTh5uZTiUOsy+g
Content-Type: application/x-gzip
Content-Disposition: attachment; filename="cref_new.tar.gz"
Content-Transfer-Encoding: base64

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
7zX+B2hFXYoAUAAA

--2fHTh5uZTiUOsy+g--
