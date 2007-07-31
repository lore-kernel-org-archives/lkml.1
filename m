Return-Path: <linux-kernel-owner+w=401wt.eu-S965963AbXGaESR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965963AbXGaESR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbXGaESI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:18:08 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40038 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbXGaESH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:18:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86_64 EFI support -v3
References: <1185851569.23149.25.camel@caritas-dev.intel.com>
Date: Mon, 30 Jul 2007 22:16:31 -0600
In-Reply-To: <1185851569.23149.25.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Tue, 31 Jul 2007 11:12:49 +0800")
Message-ID: <m1bqdtus0w.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> Following sets of patches add EFI/UEFI (Unified Extensible Firmware
> Interface) support to x86_64 architecture. The patches have been
> tested against 2.6.23-rc1 kernel on Intel platforms with EFI1.10 and
> UEFI2.0 firmware.
>
> UEFI specification can be found here: http://www.uefi.org

Is it still the case you must sign a license you won't implement
it if you read the specification?

> For booting the UEFI x86_64 enabled kernel, the machine with EFI/UEFI
> firmware and the support of bootloader is required. Detailed usage
> guide can be found in Documentation/x86_64/uefi.txt, which is added in
> the patch: efi-doc.patch.
>
> Issues _not_ addressed (per feedback from Eric Biederman)

Thank you for acknowledging them.

I would really prefer to see something start simple and obviously
correct and grow (typical unix/linux development) rather then
attempt to use all of the cool efi features at once.

> - Virtual mode support is still retained in this patch. There is at
>   least one EFI call is fast path: efi_set_rtc_mmss, which must
>   complete as soon as possible.

Bogus.  You are setting the wall clock time in the granularity
of a second.  Yes we can achieve high accuracy by setting things
as soon after the change as we can.  I don't see a couple of
extra micro second being a bit deal here.  If a couple of
extra micro seconds are a big deal we shouldn't be going through
efi to perform this logic in the first place.  This is x86 
and we know the hardware programming interface.

Why in the world are we going through efi for real time clock
operations anyway.  That seems completely silly.

> - The variable efi_enabled is used throughout across architecutres if
>  CONFIG_EFI option is enabled. The i386 code also uses this variable.
>  This is something that can be revisited with code consolidation
>  across architectures.

Fix it first. arch/i386/ efi support is horrible, and show what happens
when things are not done properly the first time.  Later doesn't happen.
With the partvirt logic we have a lot of operations properly split out
already.  Figure out how to use them. 

Ok. Looking what more I can tear into.

Eric
