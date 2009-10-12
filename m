Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZJLTCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZJLTCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756934AbZJLTCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:02:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:46367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457AbZJLTCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:02:07 -0400
Message-ID: <4AD37CA4.90601@kernel.org>
Date: Mon, 12 Oct 2009 11:59:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Ricardo Jorge da Fonseca Marques Ferreira 
	<storm@sys49152.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Yannick Roehlly <yannick.roehlly@free.fr>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, x86@kernel.org
Subject: Re: [PATCH] pci: increase alignment to make more space for hidden
 code
References: <200908072333.24631.storm@sys49152.net> <4ACAC8F1.1050706@kernel.org> <4AD24B5C.4050905@kernel.org> <200910121059.10366.bjorn.helgaas@hp.com>
In-Reply-To: <200910121059.10366.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Sunday 11 October 2009 03:17:16 pm Yinghai Lu wrote:
>> for
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=13940
>>
>> some system when acpi are enabled, acpi clears some BAR for some devices without
>> reason, and kernel will need to allocate devices for them.
> 
> "ACPI clears some BARs"?  I'm dubious.  The handoff state is the same
> whether we boot with "acpi=off" or not, so the BIOS can't be clearing
> them.  I really don't think the ACPI code in Linux clears BARs.  The
> Linux PCI code might be clearing BARs, but it sure would be nice to
> know exactly why.  Did you ever figure that out?

please check the mail is reponsed to Ingo.

> 
>> try to increase alignment to get more safe range for unassigned devices.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/kernel/e820.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/e820.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/e820.c
>> +++ linux-2.6/arch/x86/kernel/e820.c
>> @@ -1378,8 +1378,8 @@ static unsigned long ram_alignment(resou
>>  	if (mb < 16)
>>  		return 1024*1024;
>>  
>> -	/* To 32MB for anything above that */
>> -	return 32*1024*1024;
>> +	/* To 64MB for anything above that */
>> +	return 64*1024*1024;
> 
> How do we know 64MB is the correct alignment?
> 
> This feels like a hack that accidentally covers up the problem.  I
> don't think we understand what's happening well enough.

yes, we need to figure out why when acpi=on, those BAR are cleared, before pci code try to scan and read BAR.
(node early pic print out untouched, but after APCI subsystem is enabled, those BAR got clearred)

YH
