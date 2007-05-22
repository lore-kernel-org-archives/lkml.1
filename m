Return-Path: <linux-kernel-owner+w=401wt.eu-S1765419AbXEVIOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765419AbXEVIOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 04:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbXEVIOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 04:14:23 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:52252 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbXEVIOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 04:14:21 -0400
Message-ID: <4652A635.8070507@free.fr>
Date: Tue, 22 May 2007 10:13:41 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Dumping the checksums in a module
References: <464DC019.6010008@free.fr> <Pine.LNX.4.61.0705182225450.9015@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705182225450.9015@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:

> On May 18 2007 17:02, John Sigler wrote:
>> I'm getting "disagrees about version of symbol struct_module" messages,
>> and I'm trying to understand why.
>>
>> As far as I understand (which is not very far), if I define
>> CONFIG_MODVERSIONS, then checksums for various functions (all exported
>> functions?) and various structures (which ones?) will be included inside
>> the kernel image, and written to Module.symvers. When an out-of-tree
>> module is built, it will also include these checksums.
>>
>> How do I list the checksums within a module?
>>
>> Is there a simpler way to list all the checksums?
> 
> 22:25 ichi:~ > modinfo aes
> srcversion:     8CB82B3A254D5A950FD0D14
> 
> I think this one checksum is computed out of all functions that
> the module uses.

You've enabled MODULE_SRCVERSION_ALL which adds a checksum computed from 
the source files used to build a given module. What I want is to list 
ALL the checksums of the symbols included inside a given module.

e.g. for the kernel:

$ head Module.symvers
0x4da3749b      firmware_unregister     vmlinux EXPORT_SYMBOL_GPL
0xbf9d1364      generic_file_splice_write       vmlinux EXPORT_SYMBOL
0x436417ac      set_anon_super  vmlinux EXPORT_SYMBOL
0x894bc434      kmem_cache_alloc        vmlinux EXPORT_SYMBOL
0x1120b731      request_firmware        vmlinux EXPORT_SYMBOL
0x0a2487e0      unblock_all_signals     vmlinux EXPORT_SYMBOL
0x07d50a24      csum_partial    vmlinux EXPORT_SYMBOL
0xcd6c78f9      __generic_unplug_device vmlinux EXPORT_SYMBOL
0x59ab4080      cap_bset        vmlinux EXPORT_SYMBOL
0xee413334      softirq_preemption      vmlinux EXPORT_SYMBOL
[...]


config MODVERSIONS
bool "Module versioning support"
depends on MODULES
help
   Usually, you have to use modules compiled with your kernel.
   Saying Y here makes it sometimes possible to use modules
   compiled for different kernels, by adding enough information
   to the modules to (hopefully) spot any changes which would
   make them incompatible with the kernel you are running.  If
   unsure, say N.

config MODULE_SRCVERSION_ALL
bool "Source checksum for all modules"
depends on MODULES
help
   Modules which contain a MODULE_VERSION get an extra "srcversion"
   field inserted into their modinfo section, which contains a
   sum of the source files which made it.  This helps maintainers
   see exactly which source was used to build a module (since
   others sometimes change the module source without updating
   the version).  With this option, such a "srcversion" field
   will be created for all modules.  If unsure, say N.

Regards.
