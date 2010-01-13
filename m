Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506Ab0AMT6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0AMT6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625Ab0AMT6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:58:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:52448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441Ab0AMT6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:58:46 -0500
Message-ID: <4B4E25A1.5010303@kernel.org>
Date: Wed, 13 Jan 2010 11:57:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Volker Lanz <vl@fidra.de>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [BISECTED, REGRESSION] Successful resume from suspend but freezes
 after I/O
References: <200912071856.48125.vl@fidra.de> <200912210955.00086.vl@fidra.de> <86802c441001122335gda44dd2v93c613609dac7584@mail.gmail.com> <201001131904.39254.vl@fidra.de>
In-Reply-To: <201001131904.39254.vl@fidra.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 10:04 AM, Volker Lanz wrote:
> On Wednesday 13 January 2010 08:35:39 Yinghai Lu wrote:
>> On Mon, Dec 21, 2009 at 12:54 AM, Volker Lanz <vl@fidra.de> wrote:
>>> Any news on this problem? Anything else I can do to help debug the
>>> situation? The prospect of being confined to distros with kernels <
>>> 2.6.29 for the next couple of years on this machine worries me,
>>> obviously.
>>
>> as 6d794 said that is used fix exposed bug.
> 
> I beg your pardon?
> 
>> please checkout out
>>
>> c61cf4cfe7c73c7aa62dde3ff82cd475b9c41481
>>
>> and boot with debug.
> 
> This is the boot log:
> 
> -----------------------------------------------------------------------------
> 
> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 2.6.29-rc7 (vl@trevor) (gcc version 4.4.1 (Ubuntu 
> 4.4.1-4ubuntu8) ) #2 SMP Wed Jan 13 18:04:42 CET 2010
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.29-rc7 
> root=UUID=160351ee-c9b0-4a72-9fd5-9962c8137a7e ro debug nosplash
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
> [    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
> [    0.000000] DMI 2.4 present.
> [    0.000000] last_pfn = 0x1b0000 max_arch_pfn = 0x100000000
> [    0.000000] e820 update range: 00000000cff00000 - 0000000100000000 (usable) 
> ==> (reserved)
> [    0.000000] last_pfn = 0xcfee0 max_arch_pfn = 0x100000000
> [    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) 
> ==> (reserved)
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
> [    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
> [    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
> [    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
> [    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
> [    0.000000]  modified: 0000000000100000 - 00000000cfee0000 (usable)
> [    0.000000]  modified: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
> [    0.000000]  modified: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
> [    0.000000]  modified: 00000000cfef0000 - 00000000cff00000 (reserved)
> [    0.000000]  modified: 00000000e0000000 - 00000000e4000000 (reserved)
> [    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
> [    0.000000]  modified: 0000000100000000 - 00000001b0000000 (usable)

so e820_update_range does right job...

please you try to disable

X86_CHECK_BIOS_CORRUPTION

and

CONFIG_X86_RESERVE_LOW_64K

YH
