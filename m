Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbYECHOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbYECHOk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 03:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbYECHO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 03:14:28 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:58596 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbYECHO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 03:14:28 -0400
Date: Sat, 3 May 2008 10:13:32 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: x86 git acpi issue?
Message-ID: <20080503071332.GF5838@cs181133002.pp.htv.fi>
References: <481BAC6F.5090509@ct.jp.nec.com> <481BACEC.8080902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <481BACEC.8080902@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 05:08:12PM -0700, H. Peter Anvin wrote:
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
>>   pci-y				:= fixup.o
>> +pci-$(CONFIG_ACPI)		+= acpi.o
>>  pci-y				+= legacy.o irq.o
>>   pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
>>  pci-$(CONFIG_X86_NUMAQ)		:= numa.o irq.o
>> -pci-$(CONFIG_ACPI)		+= acpi.o
>>  pci-$(CONFIG_NUMA)		+= mp_bus_to_node.o
>>   obj-y				+= $(pci-y) common.o early.o
>>
>> of cause this isn't correct patch, it's just a workaround for me.
>>
>
> The problem is that := should be += for the VISWS and NUMAQ lines. There 
> is already a patch queued up to fix that.

Commit afcab879e4044f952b7a031d5fd504e0feb7df41 is the commit where Ingo 
both _reverts_ his patch you describe in the x86 tree and additionally 
moves pci-$(CONFIG_ACPI) in exactly the way that causes this breakage.

In the 4 hours between Ingo doing the += change and Ingo reverting his 
own patch in the x86 tree it was in a pull request to Linus, so the
"queued up" patch is in Linus' tree but reverted in the x86 tree.

I saw neither the patch changing the :='s to += on linux-kernel nor does 
"do not override the existing pci-y rule when adding visws or numaq 
rules." in the commit description give any indication what the actual 
problem was.

It's also not obvious why the revert with the subject "visws: build fix" 
also moved the pci-$(CONFIG_ACPI) causing this bug here.

> 	-hpa

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

