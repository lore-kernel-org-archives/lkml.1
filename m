Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXDQLsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXDQLsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 07:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXDQLsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 07:48:14 -0400
Received: from wasp.net.au ([203.190.192.17]:34733 "EHLO wasp.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbXDQLsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 07:48:14 -0400
Message-ID: <4624B3F6.4040009@wasp.net.au>
Date: Tue, 17 Apr 2007 15:48:06 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Chuck Ebbert <cebbert@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [OOPS] 2.6.21-rc6-git5 in cfq_dispatch_insert
References: <4621FAF0.7000705@wasp.net.au>	<46220339.9080205@wasp.net.au>	<4623FB29.1000603@redhat.com> <17956.22235.574867.179016@notabene.brown>
In-Reply-To: <17956.22235.574867.179016@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Monday April 16, cebbert@redhat.com wrote:
>> cfq_dispatch_insert() was called with rq == 0. This one is getting really
>> annoying... and md is involved again (RAID0 this time.)
> 
> Yeah... weird.
> RAID0 is so light-weight and so different from RAID1 or RAID5 that I
> feel fairly safe concluding that the problem isn't in or near md.

Just a quick thought. Could this issue in any way cause silent data corruption on write to the md?

I've been chasing a bug for months now on this box which resulted in a small bit of seemingly random 
corruption in large copies to /dev/md0. Problem is, I changed the PSU in the box (which appeared to 
help a little) but then about the same time I discovered the oops was in cfq so changed the 
scheduler also. I've not been able to oops or reproduce the data corruption since.

I've now got to go back to cfq and see if I can get it to panic reproducibly again, but I'm 
wondering now if there may have been another issue there.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
