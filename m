Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbXLLTHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbXLLTHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759167AbXLLTHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:07:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50768 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124AbXLLTHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:07:17 -0500
Message-ID: <47603109.6080909@zytor.com>
Date: Wed, 12 Dec 2007 11:05:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v2] x86 boot : export boot_params via sysfs
References: <1197449991.14443.88.camel@caritas-dev.intel.com> <20071212174613.GC16049@kroah.com> <47602044.9010104@zytor.com> <20071212185935.GA5941@kroah.com>
In-Reply-To: <20071212185935.GA5941@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> This is a binary structure defined by protocol;
> 
> What protocol?  Is this a "standard" documented somewhere?

Yes, see Documentation/i386/* (although some of it is documented by 
reference to include/asm-x86/boot_params.h).

>> in that way it's not significantly different from something passed
>> from the firmware (in fact, it might very well *be* passed from the
>> firmware.)  We have in the past found platform bugs by looking at the
>> contents of the whole structure, e.g.  to find that part of it has
>> been inappropriately clobbered.
> 
> For debugging things, then just export it through debugfs.

Fair enough, however...

>> It is also in the form needed by e.g. kexec to operate.
> 
> Does kexec need this today to work properly?  Or is this something new?

I believe kexec currently tries to reconstitute it from what data is 
available to it.  This is incomplete, though, and has been flagged as a 
problem for kexec.

> What userspace program is going to know the exact data format of this
> blob, and where is it going to know that format from?  The kernel header
> files in sanitized form?  Or something else?

It can pick it up from <asm/boot_params.h> (which is now 
userspace-safe); or it can decode it itself.  Programs like kexec can 
pass through most of the data without examining it, this is the main 
reason for having it as a blob.

	-hpa
