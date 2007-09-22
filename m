Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbXIVSmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbXIVSmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 14:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXIVSmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 14:42:31 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:14146 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbXIVSma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 14:42:30 -0400
Date: Sat, 22 Sep 2007 12:42:16 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] [9/50] i386: validate against ACPI motherboard	resources
In-reply-to: <1190484117.4035.71.camel@chaos>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <ak@suse.de>,
       rajesh.shah@intel.com, jbarnes@virtuousgeek.org, greg@kroah.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Message-id: <46F56208.90208@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <200709221231.836138000@suse.de>
 <20070921223207.7BBE71479D@wotan.suse.de>
 <86802c440709212349l3d968d1bgdc89e7c7415b54da@mail.gmail.com>
 <46F542A4.9080207@shaw.ca> <1190484117.4035.71.camel@chaos>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Sat, 2007-09-22 at 10:28 -0600, Robert Hancock wrote:
>> Yinghai Lu wrote:
>>> No!
>>>
>>> MMCONFIG will not work with acpi=off any more.
>> I don't think this is unreasonable. The ACPI MCFG table is how we are 
>> supposed to learn about the area in the first place. If we can't get the 
>> table location via an approved mechanism, and can't validate it doesn't 
>> overlap with another memory reservation or something, I really don't 
>> think we should be using it.
> 
> We all know how correct ACPI tables are. Specifications are nice,
> reality tells a different story.

MMCONFIG can't be used without ACPI in any case unless we know where the 
  table is using chipset-specific knowledge (i.e. reading the registers 
directly). Doing that without being told that this area is really 
intended to be used, via the ACPI table, is dangerous, i.e. we don't 
necessarily know if the MMCONFIG is broken on the platform in some way 
we can't detect.

> 
>> I don't think it's much of an issue anyway - the chances that somebody 
>> will want to run without ACPI on a system with MCFG are pretty low given 
>> that you'll end up losing a bunch of functionality (not least of which 
>> is multi-cores).
> 
> acpi=off is an often used debug switch and it _is_ quite useful. Taking
> away debug functionality is not a good idea.

If someone has to turn ACPI off, disabling MMCONFIG is probably the 
least of their worries..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


