Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYHBCFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYHBCFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYHBCFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:05:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbYHBCFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:05:36 -0400
Message-ID: <4893C066.60401@zytor.com>
Date: Fri, 01 Aug 2008 19:03:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>	 <m1iqukwjjg.fsf@frodo.ebiederm.org>	 <86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>	 <m1wsj0nyx6.fsf@frodo.ebiederm.org>	 <86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>	 <m163qkjirc.fsf@frodo.ebiederm.org> <86802c440808011901w2aa40b25u45f5686b262cc2aa@mail.gmail.com>
In-Reply-To: <86802c440808011901w2aa40b25u45f5686b262cc2aa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>> cpu is going to check that vectors in addition to vectors in IDT?
>> No. The destination cpu and destination vector number are encoded in
>> the MSI message.  Each MSI-X source ``vector'' has a different MSI message.
>>
>> So on my wish list is to stably encode the MSI interurrpt numbers.  And
>> using a sparse irq address space I can.  As it only takes 28 bits to hold
>> the complete bus + device + function + msi source [ 0-4095 ]
> 
> how about ioapic interrupt numbers...? they should stay with same
> numbering with gsi?
> 
> and how about pci segments : that will need another 4 bits for AMD
> systems..aka 16 segments..
> 
> you will run out of 32bits...
> 

I also see little value in stably encoding IRQ numbers using 
geographical identifiers.  It seems that the only case where you care 
that an interrupt number is stable is when it is *not* tied to a 
geographically addressed entity, so why does it matter?

	-hpa
