Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbXFUExU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbXFUExU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXFUExM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:53:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23871 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXFUExL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:53:11 -0400
Message-ID: <467A0474.809@oracle.com>
Date: Wed, 20 Jun 2007 21:54:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Bob Picco <bob.picco@hp.com>
CC: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: mm snapshot broken-out-2007-06-20-10-12.tar.gz uploaded
References: <200706201714.l5KHEYh6010297@imap1.linux-foundation.org> <20070621005122.GD10927@localhost> <20070620180711.1d4d6b6e.randy.dunlap@oracle.com> <20070621011422.GF10927@localhost>
In-Reply-To: <20070621011422.GF10927@localhost>
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Picco wrote:
> Randy Dunlap wrote:	[Wed Jun 20 2007, 09:07:11PM EDT]
>> On Wed, 20 Jun 2007 20:51:22 -0400 Bob Picco wrote:
>>
>>> akpm@linux-foundation.org wrote:	[Wed Jun 20 2007, 01:14:34PM EDT]
>>> [snip]
>>>
>>> Build breakage. pci_mmcfg_late_init is for i386.
>> then you want CONFIG_X86_32 instead of CONFIG_X86.
>> CONFIG_X86 is set/true for both X86_32 and X86_64.
> Then what I stated within the patch description is incorrect. pci.h which is the
> required include for the declaration is conditionally for CONFIG_X86. So it is
> both I guess?

Yes.

> bob
>>
>>> Signed-off-by: Bob Picco <bob.picco@hp.com>
>>>
>>>  drivers/acpi/bus.c |    2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> Index: linux-2.6.22-rc5-mm1/drivers/acpi/bus.c
>>> ===================================================================
>>> --- linux-2.6.22-rc5-mm1.orig/drivers/acpi/bus.c	2007-06-20 14:09:07.000000000 -0400
>>> +++ linux-2.6.22-rc5-mm1/drivers/acpi/bus.c	2007-06-20 20:32:00.000000000 -0400
>>> @@ -757,7 +757,9 @@ static int __init acpi_init(void)
>>>  	result = acpi_bus_init();
>>>  
>>>  	if (!result) {
>>> +#ifdef CONFIG_X86
>>>  		pci_mmcfg_late_init();
>>> +#endif
>>>  #ifdef CONFIG_PM_LEGACY
>>>  		if (!PM_IS_ACTIVE())
>>>  			pm_active = 1;

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
