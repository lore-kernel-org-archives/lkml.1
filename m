Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbZEFSYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbZEFSYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbZEFSYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:24:10 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:16086 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbZEFSYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:24:09 -0400
From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>,
       "Recalde, Luis F" <luis.f.recalde@intel.com>,
       "Nelson, Doug" <doug.nelson@intel.com>,
       "Cheng, Wu-sun" <wu-sun.cheng@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       "Shunmuganathan, Rajalakshmi" <rajalakshmi.shunmuganathan@intel.com>,
       "Garg, Anil K" <anil.k.garg@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>
Date: Wed, 6 May 2009 11:24:08 -0700
Subject: Re: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: AcnM0E+Nwe+14GGkR56q7IVjkGSrWwBQ8EPlABOLQUAABHgAsAAASljgAACkS34=
Message-ID: <C62723D8.F39F%anirban.chakraborty@qlogic.com>
In-Reply-To: <CAC4B8726E86A142B27A9E9A2F2F1247AB7A82C5@rrsmsx505.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 06 May 2009 18:23:41.0581 (UTC) FILETIME=[C86D5BD0:01C9CE77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On 5/6/09 11:12 AM, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com> wrote:

> That's a more accurate simulation of our workload, but Anirban's setup doesn't
> have nearly as many spindles as ours, so he won't do as many IOPS and may not
> see the problem.
> 
I was getting an IOPS in the order of 46000, which was not too far from what
Doug was getting. Orion settings indeed have a cache cold setting
(specifying cache size as 0). The IO was done as 1k block size in sequential
mode to the raw devices.
I can have that many luns but the issue is that Orion does not support that
may devices and I do not have the source code for it.
Let me see if I can find some other tool.

-Anirban

> All I'm trying to do is get something that will show the problem on his setup,
> and I think sequential IO is going to be the right answer here.  I could
> easily be wrong.
> 
> Neither FIO nor dd is going to have the cache behaviour of the database (maybe
> Orion does?)  As far as I can tell, we come to the kernel cache-cold for every
> IO simply because the database uses as many cache entries as it can.  We could
> write a little program to just thrash through cachelines, or just run gcc at
> the same time as this -- apparently gcc will happily chew through all the
> cache it can too.
> 
>> -----Original Message-----
>> From: Styner, Douglas W
>> Sent: Wednesday, May 06, 2009 11:05 AM
>> To: Wilcox, Matthew R; Anirban Chakraborty; linux-kernel@vger.kernel.org
>> Cc: Tripathi, Sharad C; arjan@linux.intel.com; Kleen, Andi; Siddha, Suresh
>> B; Ma, Chinang; Wang, Peter Xihong; Nueckel, Hubert; Recalde, Luis F;
>> Nelson, Doug; Cheng, Wu-sun; Prickett, Terry O; Shunmuganathan,
>> Rajalakshmi; Garg, Anil K; Chilukuri, Harita; chris.mason@oracle.com
>> Subject: RE: Mainline kernel OLTP performance update
>> 
>> Wilcox, Matthew R writes:
>>> I'm not sure that Orion is going to give useful results in your hardware
>>> setup.  I suspect you don't have enough spindles to get the IO rates that
>>> are required to see the problem.  How about doing lots of contiguous I/O
>>> instead?  Something as simple as:
>>> 
>>> for i in sda sdb sdc (repeat ad nauseam); do \
>>>     dd if=/dev/$i of=/dev/null bs=4k iflag=direct & \
>>> done
>>> 
>> 
>> A better workload emulator would be to use FIO to generate ~60%/40%
>> reads/writes with ~90-95% random i/o using 2k blksize.  There is some
>> sequential writing in our workload but only to a log file and there is not
>> much activity there.

