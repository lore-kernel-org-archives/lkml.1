Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbYHUXFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbYHUXFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757817AbYHUXFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:05:30 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:45362 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbYHUXF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:05:29 -0400
Message-ID: <48ADF4FF.3000008@keyaccess.nl>
Date: Fri, 22 Aug 2008 01:06:39 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "Li, Shaohua" <shaohua.li@intel.com>,
       Dave Airlie <airlied@gmail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] x86: {reverve,free}_memtype() take a physical address
References: <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com> <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl> <48ADE7C5.9030802@keyaccess.nl> <7E82351C108FA840AB1866AC776AEC460B4B033E@orsmsx505.amr.corp.intel.com> <48ADEBB1.1070203@keyaccess.nl> <7E82351C108FA840AB1866AC776AEC460B4B047D@orsmsx505.amr.corp.intel.com>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC460B4B047D@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-08-08 00:57, Pallipadi, Venkatesh wrote:
> 
>> -----Original Message-----
>> From: Rene Herman [mailto:rene.herman@keyaccess.nl]
>> Sent: Thursday, August 21, 2008 3:27 PM
>> To: Pallipadi, Venkatesh
>> Cc: Ingo Molnar; Li, Shaohua; Dave Airlie; Yinghai Lu; Andreas
>> Herrmann; Arjan van de Ven; Linux Kernel; Siddha, Suresh B;
>> Thomas Gleixner; H. Peter Anvin; Dave Jones
>> Subject: Re: [PATCH] x86: {reverve,free}_memtype() take a
>> physical address
>>
>> On 22-08-08 00:16, Pallipadi, Venkatesh wrote:
>>
>>> Yes. Noticed that too and sent a patch here for x86/tip.
>>>
>>> http://www.ussg.iu.edu/hypermail/linux/kernel/0808.2/2270.html
>>>
>>> It is not very critical as it sounds as only set_memory_uc sets PAT
>>> bits for RAM pages. Most other users (devmem mmap, ioramep, pci)
>>> set PAT bits on the reserved memory. And there will not be conflicts
>>> across RAM and reserveed regions. Regardless, this was a stupid
>>> bug that we had missed earlier.
>> And unfortunately I don't think the above fully fixes it for
>> AGP. __pa()
>> gets the real physical address and the memtypes should be on the GART
>> remapped physical addresses it seems.
>>
> 
> Page being marked here as uncached is the page got from alloc_page().
> We are not really marking GART physical address as uncacheable. And
> that page returned from alloc_page is what we are tracking with
> reserve and free.
> IOW, the tracking is only to keep CPU accesses consistent across
> different va->pa and va across different CPUs and has nothing to do
> with GART physical address here.

Okay, if you say so... it _used_ to be before this array change to AGP 
that the GART addresses were in the memtype list, but I'll take your 
word for that being okay.

Rene
