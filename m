Return-Path: <linux-kernel-owner+w=401wt.eu-S1761950AbXIUPEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761950AbXIUPEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbXIUPEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:04:38 -0400
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120]:64842 "EHLO
	pne-smtpout3-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760024AbXIUPEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:04:36 -0400
Message-ID: <46F3DBAB.9010308@kolumbus.fi>
Date: Fri, 21 Sep 2007 17:56:43 +0300
From: =?UTF-8?B?TWlrYSBQZW50dGlsw6Q=?= <mika.penttila@kolumbus.fi>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [RFC][PATCH 0/2 -mm] kexec based hibernation -v3
References: <1190266440.21818.16.camel@caritas-dev.intel.com>	 <46F39345.3040201@kolumbus.fi> <851fc09e0709210644y4a859a2bp223ef56b08a27f0@mail.gmail.com>
In-Reply-To: <851fc09e0709210644y4a859a2bp223ef56b08a27f0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

huang ying wrote:
> On 9/21/07, Mika Penttilä <mika.penttila@kolumbus.fi> wrote:
>   
>>> Usage:
>>>
>>> 1. Compile kernel with following options selected:
>>>
>>> CONFIG_X86_32=y
>>> CONFIG_RELOCATABLE=y # not needed strictly, but it is more convenient with it
>>> CONFIG_KEXEC=y
>>> CONFIG_CRASH_DUMP=y # only needed by kexeced kernel to save/restore memory image
>>> CONFIG_PM=y
>>> CONFIG_KEXEC_JUMP=y
>>>
>>> 2. Download the kexec-tools-testing git tree, apply the kexec-tools
>>>    kjump patches (or download the source tar ball directly) and
>>>    compile.
>>>
>>> 3. Download and compile the krestore tool.
>>>
>>> 4. Prepare 2 root partition used by kernel A and kernel B/C, referred
>>>    as /dev/hda, /dev/hdb in following text. This is not strictly
>>>    necessary, I use this scheme for testing during development.
>>>
>>> 5. Boot kernel compiled for normal usage (kernal A).
>>>
>>> 6. Load kernel compiled for hibernating/restore usage (kernel B) with
>>>    kexec, the same kernel as that of 5 can be used if
>>>    CONFIG_RELOCATABLE=y and CONFIG_CRASH_DUMP=y are selected.
>>>
>>>    The --elf64-core-headers should be specified in command line of
>>>    kexec, because only the 64bit ELF is supported by krestore tool.
>>>
>>>    For example, the shell command line can be as follow:
>>>
>>>    kexec -p -n /boot/bzImage --mem-min=0x100000 --mem-max=0xffffff
>>>        --elf64-core-headers --append="root=/dev/hdb single"
>>>
>>> 7. Jump to the hibernating kernel (kernel B) with following shell
>>>    command line:
>>>
>>>    kexec -j
>>>
>>> 8. In the hibernating kernel (kernel B), the memory image of
>>>    hibernated kernel (kernel A) can be saved as follow:
>>>
>>>    cp /proc/vmcore .
>>>    cp /sys/kernel/kexec_jump_back_entry .
>>>
>>>       
>> Here we save also kernel B's pages.
>>     
>
> No, the kernel B's pages will not be saved. Because when we build the
> elfcore (/proc/vmcore) header, we exclude memory area used by kernel
> B. The details can be found in kexec-tools patches.
>
>   
Ok I see. But should the kernel B's e820 mem map be limited to 1m-16m in 
order not to allocate pages found also in A's space? Or does does the 
--mem-min and --mem-max do that also?
Thanks,
Mika


