Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbYAQUnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbYAQUnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYAQUni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:43:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38622 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbYAQUnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:43:37 -0500
Message-ID: <478FBBA9.4070300@zytor.com>
Date: Thu, 17 Jan 2008 15:33:45 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andreas Herrmann3 <andreas.herrmann3@amd.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug	fixes
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu>
In-Reply-To: <20080117203600.GB27778@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andreas Herrmann3 <andreas.herrmann3@amd.com> wrote:
> 
>> For the failed devices I get:
>>
>>   sata_sil 0000:00:12.0: version 2.3
>>   ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
>>   ioremap_nocache: addr c0403000, size 200
>>   swapper:1 conflicting cache attribute c0403000-c0404000 uncached<->default
>>   ACPI: PCI interrupt for device 0000:00:12.0 disabled
> 
> hm, is the problem that the two devices share the same physical page, 
> and thus get an overlapping area?
> 
> as an intermediate fix, how about following the attribute of the already 
> existing mapping, instead of rejecting the ioremap due to the conflict? 
> I.e. something like below?

The correct behaviour probably would be to go with the most restrictive 
caching behaviour, i.e. uncached in this case.

	-hpa
