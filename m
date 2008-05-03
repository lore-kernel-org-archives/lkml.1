Return-Path: <linux-kernel-owner+w=401wt.eu-S965253AbYECAbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965253AbYECAbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 20:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759052AbYECAa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 20:30:59 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:5143 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936771AbYECAa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 20:30:56 -0400
Message-ID: <481BB23F.1050206@ct.jp.nec.com>
Date: Fri, 02 May 2008 17:30:55 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: x86 git acpi issue?
References: <481BAC6F.5090509@ct.jp.nec.com> <481BACEC.8080902@zytor.com>
In-Reply-To: <481BACEC.8080902@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hiroshi Shimamoto wrote:
>> Hi,
>>
>> commit: afcab879e4044f952b7a031d5fd504e0feb7df41
>> visws: build fix
>>
>> breaks something around acpi on 32bit.
>> In my test box scsi driver complains and the kernel doesn't boot.
>>
>> I'm not sure, but when moving the acpi.o before legacy.o, it works.
>> --- a/arch/x86/pci/Makefile_32
>> +++ b/arch/x86/pci/Makefile_32
>> @@ -6,11 +6,11 @@ obj-$(CONFIG_PCI_DIRECT)	+= direct.o
>>  obj-$(CONFIG_PCI_OLPC)		+= olpc.o
>>  
>>  pci-y				:= fixup.o
>> +pci-$(CONFIG_ACPI)		+= acpi.o
>>  pci-y				+= legacy.o irq.o
>>  
>>  pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
>>  pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
>> -pci-$(CONFIG_ACPI)		+= acpi.o
>>  pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
>>  
>>  obj-y				+= $(pci-y) common.o early.o
>>
>> of cause this isn't correct patch, it's just a workaround for me.
>>
> 
> The problem is that := should be += for the VISWS and NUMAQ lines. 
> There is already a patch queued up to fix that.
> 
OK, thanks.

Hiroshi Shimamoto

