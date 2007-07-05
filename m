Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbXGILTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbXGILTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbXGILSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:18:53 -0400
Received: from mail.tmr.com ([64.65.253.246]:34742 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbXGILSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:18:49 -0400
Message-ID: <468D4808.3080702@tmr.com>
Date: Thu, 05 Jul 2007 15:35:36 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: RAID performance is not too well....
References: <20070629140458.GA32107@bitwizard.nl>
In-Reply-To: <20070629140458.GA32107@bitwizard.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rogier Wolff wrote:
> Hi,
> 
> I have an application that creates some 228 thousand files,
> spread over about 4000 directories. Total is not more than 
> 1.3Gb.  (I'm not sure, and I don't care if it's 10% or 90% of
> that number)
> 
> Anyway, I've loaded all of the 1.3Gb into the cache (the machine
> has 8Gb of RAM), so that only writes need to take place. 
> 
> After a while the machine goes into a routine of writing
> about 500 to 1000kbytes per second. 
> 
> Sync seems to take a long time: 
> 
> zebigbos:/recover7/bd4256_jense/tree> time sync 
> 0.004u 0.136s 5:44.66 0.0%      0+0k 0+0io 0pf+0w
> zebigbos:/recover7/bd4256_jense/tree> 
> 
> The machine normally reads up to about 150 Mbytes per second without
> trouble. 
> 
> I'm suspecting that the writes to the inodes and files all end
> up "fragmented" such that reads to complete the RAID stripes 
> need to be performed: 
> 
> Iostat shows: 
> 
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> sda              75.25       277.23       126.73        280        128
> sdb              91.09       400.00       134.65        404        136
> sdc              71.29       253.47        95.05        256         96
> sdd             100.99       221.78       304.95        224        308
> 
> However, I would say that all those new files should be "clustered" 
> such that the chances of writing a full stripe becomes reasonable. 
> Moreover, clustering should, even with reading other parts of the
> stripe result in a performance on the order of 10 to 50 times better. 
> 
> Raid block (stripe) size  is 64k.  (Next time I format a partition, 
> I will chose 512k, causing the readperformance to increasae from 150Mb
> per second to about 200Mb per second). 
> 
I'm not sure what you mean by "Raid block," and a stripe size on 64k is 
improbably low. That sounds like a chunk size using common nomenclature. 
You don't say what RAID level you are using, nor what filesystem type, 
so it's really hard to give you any useful help, other than "send more 
information, use standard terms, send to the linux-raid list, not kernel."

By "format a partition" do you mean "create an array?" Or ???

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
