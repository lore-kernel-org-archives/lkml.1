Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbYHFU6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbYHFU6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbYHFU5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:57:33 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:49349 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315AbYHFU5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:57:31 -0400
Message-ID: <489A1032.9030708@keyaccess.nl>
Date: Wed, 06 Aug 2008 22:57:22 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Dave Airlie <airlied@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, dri-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
References: <48972EA8.8040001@keyaccess.nl> <20080806135114.GB6713@alberich.amd.com>
In-Reply-To: <20080806135114.GB6713@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06-08-08 15:51, Andreas Herrmann wrote:

> On Mon, Aug 04, 2008 at 06:30:32PM +0200, Rene Herman wrote:
>> What _does_ solve this though is booting with the "nopat" command line 
>> parameter. I'm on 2.6.26.1 and have enabled PAT for my AMD Duron myself. 
>> With "nopat", there's no problem to be seen anymore -- exiting X 
>> specifically is instantaneous.
>>
>> With or without PAT, my /proc/mtrr is always:
>>
>> reg00: base=0x00000000 (   0MB), size= 512MB: write-back, count=1
>> reg01: base=0x20000000 ( 512MB), size= 256MB: write-back, count=1
>> reg02: base=0xe8000000 (3712MB), size=  64MB: write-combining, count=1
>>
>> under X joined by:
>>
>> reg03: base=0xe4000000 (3648MB), size=  32MB: write-combining, count=2
> 
> To get some more debug data, can you please retest with latest kernel
> (2.6.27-rc2)

Problem present on vanilla -rc2.

> using "debugpat" kernel option and provide dmesg output

No... my kernel message buffer isn't large enough for that :-(

Right, I guess I now know where the delay is coming from. I suppose this 
is not expected. dmesg as captured after starting X and without 
"debugpat" at:

http://members.home.nl/rene.herman/pat/dmesg.x

Truncated dmesg with "debugpat":

http://members.home.nl/rene.herman/pat/dmesg.x.debugpat

> plus contents of <debugfs>/x86/pat_memtype_list?

Before starting X (1K):

http://members.home.nl/rene.herman/pat/pat_memtype_list.console.debugpat

After starting X (625K):

http://members.home.nl/rene.herman/pat/pat_memtype_list.x.debugpat

(This is with 64MB AGP memory)

More data:

http://members.home.nl/rene.herman/pat/config-2.6.27-rc2-current
http://members.home.nl/rene.herman/pat/xorg.conf
http://members.home.nl/rene.herman/pat/Xorg.0.log

Thanks,
Rene
