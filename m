Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180AbZK2Qoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbZK2Qoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 11:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZK2Qoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 11:44:38 -0500
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:44161 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751402AbZK2Qoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 11:44:37 -0500
Message-ID: <4B12A4B4.4020404@internode.on.net>
Date: Mon, 30 Nov 2009 03:13:32 +1030
From: indexer <indexer@internode.on.net>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: "Tang, Feng" <feng.tang@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug 14658] Regression in efi.c
References: <bug-14658-6666@http.bugzilla.kernel.org/>	 <200911212017.nALKHLSC029634@demeter.kernel.org>	 <alpine.LFD.2.00.0911221817200.24119@localhost.localdomain>	 <4B09F685.2080201@internode.on.net>	 <alpine.LFD.2.00.0911231034090.24119@localhost.localdomain>	 <4B0A6DCA.70805@internode.on.net>  <4B0C7BBE.3040703@internode.on.net> <1259110243.7068.8.camel@yhuang-dev.sh.intel.com> <4B0CFC10.8050700@internode.on.net> <EADF0A36011179459010BDF5142A457501D006B76C@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <EADF0A36011179459010BDF5142A457501D006B76C@pdsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng, Peter

I decided to go back a few versions and check out if there any previous 
bugs, and upon bisecting i found this one

commit 37ba7ab5e33cebc25c68fffe33e9f21e7c2014e8
Author: H. Peter Anvin <hpa@zytor.com>
Date: Mon May 11 15:56:08 2009 -0700

x86, boot: make kernel_alignment adjustable; new bzImage fields

Make the kernel_alignment field adjustable; this allows us to set it
to a large value (intended to be 16 MB to avoid ZONE_DMA contention,
memory holes and other weirdness) while a smart bootloader can still
force a loading at a lesser alignment if absolutely necessary.

Also export pref_address (preferred loading address, corresponding to
the link-time address) and init_size, the total amount of linear
memory the kernel will require during initialization.

[ Impact: allows better kernel placement, gives bootloader more info ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>

arch/x86/boot/compressed/head_32.S | 7 +++++--
arch/x86/boot/compressed/head_64.S | 14 ++++++++++----
arch/x86/boot/header.S | 15 +++++++++++++--
arch/x86/include/asm/boot.h | 15 +++++++++++++++
arch/x86/kernel/asm-offsets_32.c | 1 +
arch/x86/kernel/asm-offsets_64.c | 1 +
6 files changed, 45 insertions(+), 8 deletions(-)


This seems to stop efi booting as well on x86_64. I have also been able 
to recently test this on a gen 4 macbook pro as well as my own gen 5 to 
make sure it is not an issue specific to this model.

William

Tang, Feng wrote:
> William,
>
> You've confirmed that apply commit 772be899b "x86: Make EFI RTC function depend
> on 32bit again" right after 7bd867dfb "x86: Move get/set_wallclock to 
> x86_platform_ops" will get a bootable kernel.
>
> Then, one debug method may be use "git-rebase -i" to move commit 772be899b right after 
> 7bd867dfb, and do the bisect from there on. 
>
> Thanks,
> Feng
>   
>> -----Original Message-----
>> From: indexer [mailto:indexer@internode.on.net]
>> Sent: 2009年11月25日 17:43
>> To: Tang, Feng
>> Cc: LKML
>> Subject: Re: [Bug 14658] Regression in efi.c
>>
>> Feng tang
>>
>> I have just tested and applied that correction, and it resulted in a
>> working system. I dont really know where to go from here so any advice
>> would be appreciated.
>>
>> William
>>     
> N嫥叉靣笡y氊b瞂千v豝�)藓{.n�+壏{睉赙zXФ洝塄}财爖�&j:+v墾�珣赙zZ+€�+zf＂穐殘啳嗃i�z�畐ア�?櫒璀�&�)撷f旟^j谦y呩@A玜囤�0鹅h�鍜i

