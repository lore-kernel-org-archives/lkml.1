Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbXLLSJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbXLLSJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXLLSJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:09:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbXLLSJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:09:42 -0500
Message-ID: <47602044.9010104@zytor.com>
Date: Wed, 12 Dec 2007 09:54:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v2] x86 boot : export boot_params via sysfs
References: <1197449991.14443.88.camel@caritas-dev.intel.com> <20071212174613.GC16049@kroah.com>
In-Reply-To: <20071212174613.GC16049@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Dec 12, 2007 at 04:59:51PM +0800, Huang, Ying wrote:
>> This patch export the boot parameters via sysfs. This can be used for
>> debugging and kexec.
>>
>> The files added are as follow:
>>
>> /sys/kernel/boot_params/data	: binary file for struct boot_params
>> /sys/kernel/boot_params/version	: boot protocol version
>>
>> This patch is based on 2.6.24-rc4-mm1 and has been tested on i386 and
>> x86_64 platoform.
>>
>> This patch is based on the Peter Anvin's proposal.
> 
> As outlined in a previous email, I object to the whole structure being
> exported to userspace as a binary blob.  Please change that.
> 

I would prefer to have the binary blob available; exported fields is 
possible too, of course.

This is a binary structure defined by protocol; in that way it's not 
significantly different from something passed from the firmware (in 
fact, it might very well *be* passed from the firmware.)  We have in the 
past found platform bugs by looking at the contents of the whole 
structure, e.g. to find that part of it has been inappropriately clobbered.

It is also in the form needed by e.g. kexec to operate.

	-hpa
