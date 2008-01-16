Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYAPTgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYAPTgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYAPTgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:36:43 -0500
Received: from mga03.intel.com ([143.182.124.21]:22720 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbYAPTgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:36:42 -0500
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Date: Wed, 16 Jan 2008 11:37:33 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5E8B8D@orsmsx423.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Thread-Index: AchYceSIwTg7bnr3RZSOJxF4Nw9L5gAAMd+gAAEevmA=
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> 
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Cc: <ak@muc.de>, <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <torvalds@linux-foundation.org>, <gregkh@suse.de>, <airlied@skynet.ie>,
       <davej@redhat.com>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <hpa@zytor.com>, <akpm@linux-foundation.org>, <arjan@infradead.org>,
       "Barnes, Jesse" <jesse.barnes@intel.com>, <davem@davemloft.net>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 16 Jan 2008 19:36:37.0095 (UTC) FILETIME=[1BCECF70:01C85877]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry. Never mind about e820 map. Somehow I did not notice the boot.log
you had attached earlier.

Thanks,
Venki 

>-----Original Message-----
>From: Pallipadi, Venkatesh 
>Sent: Wednesday, January 16, 2008 11:06 AM
>To: 'Andreas Herrmann'
>Cc: ak@muc.de; ebiederm@xmission.com; rdreier@cisco.com; 
>torvalds@linux-foundation.org; gregkh@suse.de; 
>airlied@skynet.ie; davej@redhat.com; mingo@elte.hu; 
>tglx@linutronix.de; hpa@zytor.com; akpm@linux-foundation.org; 
>arjan@infradead.org; Barnes, Jesse; davem@davemloft.net; 
>linux-kernel@vger.kernel.org
>Subject: RE: [patch 0/4] x86: PAT followup - Incremental 
>changes and bug fixes
>
>
>Can you attach the e820 map from the top of your dmesg.
>
>Thanks,
>Venki 
>
>>-----Original Message-----
>>From: Andreas Herrmann [mailto:andreas.herrmann3@amd.com] 
>>Sent: Wednesday, January 16, 2008 10:58 AM
>>To: Pallipadi, Venkatesh
>>Cc: ak@muc.de; ebiederm@xmission.com; rdreier@cisco.com; 
>>torvalds@linux-foundation.org; gregkh@suse.de; 
>>airlied@skynet.ie; davej@redhat.com; mingo@elte.hu; 
>>tglx@linutronix.de; hpa@zytor.com; akpm@linux-foundation.org; 
>>arjan@infradead.org; Barnes, Jesse; davem@davemloft.net; 
>>linux-kernel@vger.kernel.org
>>Subject: Re: [patch 0/4] x86: PAT followup - Incremental 
>>changes and bug fixes
>>
>>Hi,
>>
>>I just want to report that the PAT support in x86/mm causes crashes
>>on two of my test machines. On both boxes the SATA detection does
>>not work when the PAT support is patched into the kernel.
>>
>>Symptoms are as follows -- best described by a diff between the
>>two boot.logs:
>>
>># diff boot-failing.log boot-working.log
>>
>>-Linux version 2.6.24-rc8-ga9f7faa5 (root@hunter) (gcc version ...
>>+Linux version 2.6.24-rc8-g2ea3cf43 (root@hunter) (gcc version ...
>>...
>> early_iounmap(ffffffff82a0b000, 00001000)
>>-early_ioremap(000000000000c000, 00001000) => -000002103394304
>>-early_iounmap(ffffffff82a0c000, 00001000)
>> early_iounmap(ffffffff82808000, 00001000)
>>...
>>-ACPI: PCI interrupt for device 0000:00:12.0 disabled
>>-sata_sil: probe of 0000:00:12.0 failed with error -12
>>+scsi0 : sata_sil
>>+scsi1 : sata_sil
>>+ata1: SATA max UDMA/100 mmio m512@0xc0403000 tf 0xc0403080 irq 22
>>...
>>-AC'97 space ioremap problem
>>-ACPI: PCI interrupt for device 0000:00:14.5 disabled
>>-ATI IXP AC97 controller: probe of 0000:00:14.5 failed with error -5
>> ALSA device list:
>>-  No soundcards found.
>>+  #0: ATI IXP rev 80 with ALC655 at 0xc0403800, irq 17
>>...
>>-VFS: Cannot open root device "sda1" or unknown-block(0,0)
>>-Please append a correct "root=" boot option; here are the 
>>available partitions:
>>-1600    4194302 hdc driver: ide-cdrom
>>-Kernel panic - not syncing: VFS: Unable to mount root fs on 
>>unknown-block(0,0)
>>+kjournald starting.  Commit interval 5 seconds
>>+EXT3-fs: mounted filesystem with ordered data mode.
>>+VFS: Mounted root (ext3 filesystem) readonly.
>>...
>>
>>   <snip>
>> 
>>The second test machine uses ahci. But the symptoms are similar.
>>
>>I performed a git-bisect on x86/mm. Last commit that worked for me was
>>
>>2ea3cf43fddecbfd66353caafdf73ec21ea3760b (x86: fix 
>>early_ioremap() ISA window)
>>
>>The subsequent commits for PAT support introduced the problem.
>>I noticed that PAT should be disabled by default, but 
>>obviously the patches
>>still have some side-effect. (Maybe ioremap changes lead to 
>>the problem?)
>>
>>Boot-logs are attached:
>>
>>  boot-failing.log for x86/mm as of v2.6.24-rc8-672-ga9f7faa
>>  boot-working.log for x86/mm as of v2.6.24-rc8-621-g2ea3cf4
>>
>>Hopefully it helps to track down the problem.
>>Maybe someone has an idea why the PAT patches are causing that
>>ominous "PCI interrupt for device ... disabled" messages.
>>
>>
>>Thanks and regards,
>>
>>Andreas
>>
