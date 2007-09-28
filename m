Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbXI1W3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbXI1W3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 18:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXI1W3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 18:29:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55541 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXI1W3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 18:29:00 -0400
Message-ID: <46FD8003.7090902@zytor.com>
Date: Fri, 28 Sep 2007 15:28:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v3 1/2] i386/x86_64 boot: setup data
References: <1190192306.12429.76.camel@caritas-dev.intel.com>	 <46F14896.8080603@zytor.com> <1190873200.21818.292.camel@caritas-dev.intel.com>
In-Reply-To: <1190873200.21818.292.camel@caritas-dev.intel.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> Hi, Peter,
> 
> On Wed, 2007-09-19 at 09:04 -0700, H. Peter Anvin wrote:
>> Huang, Ying wrote:
>>> Known Issues:
>>>
>>> 1. Where is safe to place the linked list of setup_data?
>>> Because the length of the linked list of setup_data is variable, it
>>> can not be copied into BSS segment of kernel as that of "zero
>>> page". We must find a safe place for it, where it will not be
>>> overwritten by kernel during booting up. The i386 kernel will
>>> overwrite some pages after _end. The x86_64 kernel will overwrite some
>>> pages from 0x1000 on.
>>>
>> The latter is definitely not safe, since the space below 640K is the
>> documented place to put the command line (and presumably where the
>> bootloader would put other auxilliary chunks.)
>>
>> I'll try to do a full review of this later today.  Haven't had time yet
>> to look at this anything than but piecemeal.
> 
> Do you think this patch and the 32-bit boot protocol patch are ready to
> merge for -mm? If not, I can revise them.
> 

Sorry, haven't had a chance to look at it in proper detail yet, mostly
due to debugging, but one thing I'd like to see is both the boot_params
structure as well as all the chained information pointers exported into
sysfs.  The experience with the x86 setup code has shown that it would
help immensely with debugging, not to mention being available to tools
like kexec.

	-hpa
