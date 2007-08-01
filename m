Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbXHAR2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbXHAR2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbXHAR2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:28:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46291 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbXHAR2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:28:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86_64 EFI support -v3
References: <1185851569.23149.25.camel@caritas-dev.intel.com>
	<m1bqdtus0w.fsf@ebiederm.dsl.xmission.com>
	<1185872127.23149.81.camel@caritas-dev.intel.com>
Date: Wed, 01 Aug 2007 11:21:59 -0600
In-Reply-To: <1185872127.23149.81.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Tue, 31 Jul 2007 16:55:27 +0800")
Message-ID: <m1myxbnpag.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> On Mon, 2007-07-30 at 22:16 -0600, Eric W. Biederman wrote:
>> "Huang, Ying" <ying.huang@intel.com> writes:
>> > - The variable efi_enabled is used throughout across architecutres if
>> >  CONFIG_EFI option is enabled. The i386 code also uses this variable.
>> >  This is something that can be revisited with code consolidation
>> >  across architectures.
>> 
>> Fix it first. arch/i386/ efi support is horrible, and show what happens
>> when things are not done properly the first time.  Later doesn't happen.
>> With the partvirt logic we have a lot of operations properly split out
>> already.  Figure out how to use them.
>
> What do you suggest to use instead of efi_enabled?
>
> Current method is (efi_enabled based):
>
> (1) Encapsulate EFI based implementation and legacy BIOS based
> implementation into separate functions.
> (2) Define a wrapper function for each interface in (1), efi_enabled is
> used to choose implementation between EFI and legacy BIOS.
>
> Another possible method is (function pointer based):

Exactly.  Which is what everything else in the kernel does and is
extensible.

> 1. Encapsulate EFI based implementation and legacy BIOS based
> implementation into separate functions.

> 2. Define a function pointer for each interface in (1), the function
> pointer is set to legacy BIOS based implementation by default and
> changed to EFI based implementation if appropriate.
>
> Because there are only two possible choice, I think the function pointer
> based method has no big advantages over the efi_enabled based method.

Not at all every hypervisor does these things differently as well,
so in the real world there are a lot of choices. 

Eric
