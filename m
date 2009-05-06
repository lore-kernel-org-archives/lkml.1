Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZEFSMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZEFSMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZEFSMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:12:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:43945 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbZEFSME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:12:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,303,1239001200"; 
   d="scan'208";a="410060150"
From: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>
To: "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Anirban Chakraborty <anirban.chakraborty@qlogic.com>,
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
Date: Wed, 6 May 2009 12:12:02 -0600
Subject: RE: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: AcnM0E+Nwe+14GGkR56q7IVjkGSrWwBQ8EPlABOLQUAABHgAsAAASljg
Message-ID: <CAC4B8726E86A142B27A9E9A2F2F1247AB7A82C5@rrsmsx505.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345BCC195@azsmsx501.amr.corp.intel.com>
 <C6267C73.F240%anirban.chakraborty@qlogic.com>
 <CAC4B8726E86A142B27A9E9A2F2F1247AB7A80EC@rrsmsx505.amr.corp.intel.com>
 <D7C42C27E6CB1E4D8CBDF2F81EA92A260345D49022@azsmsx501.amr.corp.intel.com>
In-Reply-To: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345D49022@azsmsx501.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n46ICOqu019463

That's a more accurate simulation of our workload, but Anirban's setup doesn't have nearly as many spindles as ours, so he won't do as many IOPS and may not see the problem.

All I'm trying to do is get something that will show the problem on his setup, and I think sequential IO is going to be the right answer here.  I could easily be wrong.

Neither FIO nor dd is going to have the cache behaviour of the database (maybe Orion does?)  As far as I can tell, we come to the kernel cache-cold for every IO simply because the database uses as many cache entries as it can.  We could write a little program to just thrash through cachelines, or just run gcc at the same time as this -- apparently gcc will happily chew through all the cache it can too.

> -----Original Message-----
> From: Styner, Douglas W
> Sent: Wednesday, May 06, 2009 11:05 AM
> To: Wilcox, Matthew R; Anirban Chakraborty; linux-kernel@vger.kernel.org
> Cc: Tripathi, Sharad C; arjan@linux.intel.com; Kleen, Andi; Siddha, Suresh
> B; Ma, Chinang; Wang, Peter Xihong; Nueckel, Hubert; Recalde, Luis F;
> Nelson, Doug; Cheng, Wu-sun; Prickett, Terry O; Shunmuganathan,
> Rajalakshmi; Garg, Anil K; Chilukuri, Harita; chris.mason@oracle.com
> Subject: RE: Mainline kernel OLTP performance update
> 
> Wilcox, Matthew R writes:
> >I'm not sure that Orion is going to give useful results in your hardware
> >setup.  I suspect you don't have enough spindles to get the IO rates that
> >are required to see the problem.  How about doing lots of contiguous I/O
> >instead?  Something as simple as:
> >
> >for i in sda sdb sdc (repeat ad nauseam); do \
> >	dd if=/dev/$i of=/dev/null bs=4k iflag=direct & \
> >done
> >
> 
> A better workload emulator would be to use FIO to generate ~60%/40%
> reads/writes with ~90-95% random i/o using 2k blksize.  There is some
> sequential writing in our workload but only to a log file and there is not
> much activity there.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
