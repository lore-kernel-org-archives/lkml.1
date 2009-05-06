Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbZEFSFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbZEFSFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZEFSFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:05:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:63041 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZEFSFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:05:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,303,1239001200"; 
   d="scan'208";a="139897202"
From: "Styner, Douglas W" <douglas.w.styner@intel.com>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
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
Date: Wed, 6 May 2009 11:05:04 -0700
Subject: RE: Mainline kernel OLTP performance update
Thread-Topic: Mainline kernel OLTP performance update
Thread-Index: AcnM0E+Nwe+14GGkR56q7IVjkGSrWwBQ8EPlABOLQUAABHgAsA==
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345D49022@azsmsx501.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345BCC195@azsmsx501.amr.corp.intel.com>
 <C6267C73.F240%anirban.chakraborty@qlogic.com>
 <CAC4B8726E86A142B27A9E9A2F2F1247AB7A80EC@rrsmsx505.amr.corp.intel.com>
In-Reply-To: <CAC4B8726E86A142B27A9E9A2F2F1247AB7A80EC@rrsmsx505.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wilcox, Matthew R writes:
>I'm not sure that Orion is going to give useful results in your hardware
>setup.  I suspect you don't have enough spindles to get the IO rates that
>are required to see the problem.  How about doing lots of contiguous I/O
>instead?  Something as simple as:
>
>for i in sda sdb sdc (repeat ad nauseam); do \
>	dd if=/dev/$i of=/dev/null bs=4k iflag=direct & \
>done
>

A better workload emulator would be to use FIO to generate ~60%/40% reads/writes with ~90-95% random i/o using 2k blksize.  There is some sequential writing in our workload but only to a log file and there is not much activity there.
