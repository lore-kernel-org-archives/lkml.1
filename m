Return-Path: <linux-kernel-owner+w=401wt.eu-S933401AbXF2OLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbXF2OLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 10:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765765AbXF2OLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 10:11:42 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:51277 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1765749AbXF2OLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 10:11:41 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2007 10:11:41 EDT
Date: Fri, 29 Jun 2007 16:04:59 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: linux-kernel@vger.kernel.org
Subject: RAID performance is not too well.... 
Message-ID: <20070629140458.GA32107@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I have an application that creates some 228 thousand files,
spread over about 4000 directories. Total is not more than 
1.3Gb.  (I'm not sure, and I don't care if it's 10% or 90% of
that number)

Anyway, I've loaded all of the 1.3Gb into the cache (the machine
has 8Gb of RAM), so that only writes need to take place. 

After a while the machine goes into a routine of writing
about 500 to 1000kbytes per second. 

Sync seems to take a long time: 

zebigbos:/recover7/bd4256_jense/tree> time sync 
0.004u 0.136s 5:44.66 0.0%      0+0k 0+0io 0pf+0w
zebigbos:/recover7/bd4256_jense/tree> 

The machine normally reads up to about 150 Mbytes per second without
trouble. 

I'm suspecting that the writes to the inodes and files all end
up "fragmented" such that reads to complete the RAID stripes 
need to be performed: 

Iostat shows: 

Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda              75.25       277.23       126.73        280        128
sdb              91.09       400.00       134.65        404        136
sdc              71.29       253.47        95.05        256         96
sdd             100.99       221.78       304.95        224        308

However, I would say that all those new files should be "clustered" 
such that the chances of writing a full stripe becomes reasonable. 
Moreover, clustering should, even with reading other parts of the
stripe result in a performance on the order of 10 to 50 times better. 

Raid block (stripe) size  is 64k.  (Next time I format a partition, 
I will chose 512k, causing the readperformance to increasae from 150Mb
per second to about 200Mb per second). 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
