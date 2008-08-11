Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbYHKJqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbYHKJqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 05:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYHKJqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 05:46:30 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:45546 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYHKJq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 05:46:29 -0400
Message-ID: <48A00A82.6040501@keyaccess.nl>
Date: Mon, 11 Aug 2008 11:46:42 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Dave Airlie <airlied@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, dri-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
References: <48972EA8.8040001@keyaccess.nl> <20080806135114.GB6713@alberich.amd.com> <489A1032.9030708@keyaccess.nl>
In-Reply-To: <489A1032.9030708@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<ping>

Please note this a 2.6.27 problem (given that PAT isn't enabled by 
default, not a _pure_ regression I guess, but still).

I also still don't know if you (Andreas), Dave or Yinghai should be the 
To: on this but given that you've been the only one to react at all...

On 06-08-08 22:57, Rene Herman wrote:

> On 06-08-08 15:51, Andreas Herrmann wrote:
> 
>> On Mon, Aug 04, 2008 at 06:30:32PM +0200, Rene Herman wrote:
>>> What _does_ solve this though is booting with the "nopat" command 
>>> line parameter. I'm on 2.6.26.1 and have enabled PAT for my AMD Duron 
>>> myself. With "nopat", there's no problem to be seen anymore -- 
>>> exiting X specifically is instantaneous.
>>>
>>> With or without PAT, my /proc/mtrr is always:
>>>
>>> reg00: base=0x00000000 (   0MB), size= 512MB: write-back, count=1
>>> reg01: base=0x20000000 ( 512MB), size= 256MB: write-back, count=1
>>> reg02: base=0xe8000000 (3712MB), size=  64MB: write-combining, count=1
>>>
>>> under X joined by:
>>>
>>> reg03: base=0xe4000000 (3648MB), size=  32MB: write-combining, count=2
>>
>> To get some more debug data, can you please retest with latest kernel
>> (2.6.27-rc2)
> 
> Problem present on vanilla -rc2.
> 
>> using "debugpat" kernel option and provide dmesg output
> 
> No... my kernel message buffer isn't large enough for that :-(
> 
> Right, I guess I now know where the delay is coming from. I suppose this 
> is not expected. dmesg as captured after starting X and without 
> "debugpat" at:
> 
> http://members.home.nl/rene.herman/pat/dmesg.x
> 
> Truncated dmesg with "debugpat":
> 
> http://members.home.nl/rene.herman/pat/dmesg.x.debugpat
> 
>> plus contents of <debugfs>/x86/pat_memtype_list?
> 
> Before starting X (1K):
> 
> http://members.home.nl/rene.herman/pat/pat_memtype_list.console.debugpat
> 
> After starting X (625K):
> 
> http://members.home.nl/rene.herman/pat/pat_memtype_list.x.debugpat
> 
> (This is with 64MB AGP memory)
> 
> More data:
> 
> http://members.home.nl/rene.herman/pat/config-2.6.27-rc2-current
> http://members.home.nl/rene.herman/pat/xorg.conf
> http://members.home.nl/rene.herman/pat/Xorg.0.log
