Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbYAHBEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbYAHBEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 20:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYAHBE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 20:04:27 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:2553 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbYAHBE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 20:04:26 -0500
Date: Mon, 07 Jan 2008 19:03:46 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: MCFG ACPI patch in git-x86 causes boot regression
In-reply-to: <20080108010110.GB16156@one.firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, akpm@osdl.org, rajesh.shah@intel.com,
       greg@kroah.com
Message-id: <4782CBF2.6030208@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <20080107224757.GA2336@basil.nowhere.org>
 <200801071452.15045.jbarnes@virtuousgeek.org> <4782B66E.8050400@shaw.ca>
 <20080108010110.GB16156@one.firstfloor.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Mon, Jan 07, 2008 at 05:31:58PM -0600, Robert Hancock wrote:
>> Jesse Barnes wrote:
> 
> Hmm -- I didn't see Jesse's mail? 
> 
>> I believe that such a change is in Greg KH's tree. So -mm (with both 
>> trees) would probably work.
> 
> Yes 2.6.24-rc6-mm1 works, but plain git-x86 does not:
> 
> PCI: MCFG configuration 0: base 4026531840 segment 0 buses 0 - 127
> PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
> PCI: Using MMCONFIG at f0000000 - f7ffffff

At least, I thought it was in Greg's tree, not sure now.. This is the 
patch in -mm:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/broken-out/pci-disable-decoding-during-sizing-of-bars.patch

Without this change a bunch of machines fail to boot even without the 
MCFG change (since their MCFG was E820 reserved and so the old 
validation check passed).
