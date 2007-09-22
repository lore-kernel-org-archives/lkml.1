Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbXIVU5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbXIVU5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 16:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXIVU5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 16:57:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbXIVU5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 16:57:22 -0400
Message-ID: <46F5816B.3070908@zytor.com>
Date: Sat, 22 Sep 2007 13:56:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       rajesh.shah@intel.com, jbarnes@virtuousgeek.org, greg@kroah.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/50] i386: validate against ACPI motherboard resources
References: <200709221231.836138000@suse.de>	 <20070921223207.7BBE71479D@wotan.suse.de>	 <86802c440709212349l3d968d1bgdc89e7c7415b54da@mail.gmail.com>	 <46F542A4.9080207@shaw.ca> <1190484117.4035.71.camel@chaos>	 <46F56208.90208@shaw.ca> <86802c440709221340h2cbbf423y239f399ab5da815d@mail.gmail.com>
In-Reply-To: <86802c440709221340h2cbbf423y239f399ab5da815d@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>> We all know how correct ACPI tables are. Specifications are nice,
>>> reality tells a different story.
>> MMCONFIG can't be used without ACPI in any case unless we know where the
>>   table is using chipset-specific knowledge (i.e. reading the registers
>> directly). Doing that without being told that this area is really
>> intended to be used, via the ACPI table, is dangerous, i.e. we don't
>> necessarily know if the MMCONFIG is broken on the platform in some way
>> we can't detect.
> 
> the BIOS get these info from the chipset too.
> for AMD Fam 10h opteron, we can read that MSR for MMCONFIG base.

I think he's saying we don't know a safe place to park the MMCONFIG area
if we don't have this information.  However, this applies to *any*
allocation of address space, which we do all the time, so although a
valid argument this has been decided already many times over.

	-hpa
