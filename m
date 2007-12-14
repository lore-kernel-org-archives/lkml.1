Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbXLNTBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbXLNTBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 14:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbXLNTBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 14:01:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45141 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbXLNTBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 14:01:15 -0500
Message-ID: <4762D2CC.1030109@zytor.com>
Date: Fri, 14 Dec 2007 11:00:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm -v3] x86 boot : export boot_params via sysfs
References: <1197620206.12999.12.camel@caritas-dev.intel.com> <20071214155228.GA13342@kroah.com> <4762C78D.9080107@zytor.com>
In-Reply-To: <4762C78D.9080107@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Greg KH wrote:
>>
>> But it ignored the fact that I said I didn't want this binary file in
>> sysfs :)
>>
>> Please take Eric's suggestion and split it up into the different pieces.
>> Some of the fields can be binary files, as they come directly from the
>> firmware, but the others should be text.
>>
> 
> But PLEASE include the full structure as a ready-to-eat object.  PLEASE.
> 

I should clarify this.

By all means go ahead and provide broken-out fields where it makes 
sense.  However:

- this *IS* a structure defined by protocol, and which, for all users 
except the 16-bit entry, comes from outside the kernel (bootloader or 
firmware.)

- a newer kernel version can add fields to this structure, but can never 
remove them.  This would cause a potential information loss if the 
current kernel doesn't have all fields available.

- the binary structure is the format that the majority of users will need.

This is directly analogous to how we treat identity information in IDE, 
or PCI configuration space -- some fields are pre-digested, but the 
entire raw information is also available.

	-hpa
