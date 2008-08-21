Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbYHUWQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbYHUWQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 18:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757894AbYHUWQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 18:16:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:2988 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757624AbYHUWQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 18:16:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,247,1217833200"; 
   d="scan'208";a="431220548"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       "Li, Shaohua" <shaohua.li@intel.com>
CC: Dave Airlie <airlied@gmail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Date: Thu, 21 Aug 2008 15:16:11 -0700
Subject: RE: [PATCH] x86: {reverve,free}_memtype() take a physical address
Thread-Topic: [PATCH] x86: {reverve,free}_memtype() take a physical address
Thread-Index: AckD2o1mQngVdZZbRpKUYKyW6kiThAAAOT9A
Message-ID: <7E82351C108FA840AB1866AC776AEC460B4B033E@orsmsx505.amr.corp.intel.com>
References: <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl>
 <20080819190757.GA17470@linux-os.sc.intel.com>
 <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl>
 <48AC29CA.1060203@keyaccess.nl>
 <20080820194127.GA10887@linux-os.sc.intel.com>
 <48AC8F69.4050201@keyaccess.nl>
 <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com>
 <20080820221630.GA3598@linux-os.sc.intel.com>
 <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl>
 <48ADE7C5.9030802@keyaccess.nl>
In-Reply-To: <48ADE7C5.9030802@keyaccess.nl>
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


>-----Original Message-----
>From: Rene Herman [mailto:rene.herman@keyaccess.nl]
>Sent: Thursday, August 21, 2008 3:10 PM
>To: Ingo Molnar; Li, Shaohua
>Cc: Pallipadi, Venkatesh; Dave Airlie; Yinghai Lu; Andreas
>Herrmann; Arjan van de Ven; Linux Kernel; Siddha, Suresh B;
>Thomas Gleixner; H. Peter Anvin; Dave Jones
>Subject: [PATCH] x86: {reverve,free}_memtype() take a physical address
>
>On 21-08-08 19:15, Rene Herman wrote:
>
>> On 21-08-08 14:06, Ingo Molnar wrote:
>
>>> Would be nice to test tip/master - it has both that patch
>included and
>>> the latest pageattr-array API (with enablement in AGP drivers)
>>> patchset, done by Shaohua Li, based on Dave's original patch.
>>
>> That patch by itself doesn't help any -- the new
>set_memory_array_uc()
>> still calls reserve_memtype() for each single page in the array.
>
>Worse yet, it appears to be broken. {reserve,free}_memtype()
>expect phys
>addresses but it's being passed virtual ones...
>
>Rene.
>

Yes. Noticed that too and sent a patch here for x86/tip.

http://www.ussg.iu.edu/hypermail/linux/kernel/0808.2/2270.html

It is not very critical as it sounds as only set_memory_uc sets PAT
bits for RAM pages. Most other users (devmem mmap, ioramep, pci)
set PAT bits on the reserved memory. And there will not be conflicts
across RAM and reserveed regions. Regardless, this was a stupid
bug that we had missed earlier.

Thanks,
Venki
