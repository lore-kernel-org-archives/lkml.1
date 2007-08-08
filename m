Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbXHHQLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbXHHQLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXHHQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:11:26 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39033 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbXHHQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:11:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86_64 EFI support -v3: EFI document
References: <1185851583.23149.30.camel@caritas-dev.intel.com>
	<200708071154.23150.ak@suse.de>
	<1186561082.4430.63.camel@caritas-dev.intel.com>
	<200708081208.01080.ak@suse.de>
Date: Wed, 08 Aug 2007 10:10:32 -0600
In-Reply-To: <200708081208.01080.ak@suse.de> (Andi Kleen's message of "Wed, 8
	Aug 2007 12:08:00 +0200")
Message-ID: <m1tzrac8hz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

>> The needed code changing is minimal. In fact, I can boot 32bit Linux
>> kernel on my x86_64 EFI machine. With setup as follow:
>>
>> 1. Apply the efi-fb.patch
> Just for the frame buffer, right?
>
>> 2. make efi fb driver not depend on EFI
>> 3. configure kernel as follow:
>>    a. CONFIG_EFI is turned off
>>    b. CONFIG_FB_EFI is turned on
>
> Hmm, how does the 32bit kernel know where the e820 map is passed then?
> With CONFIG_EFI turned off it will just ask the real mode BIOS I think
> and I doubt elilo simulates that.

This is the classic skip the 16bit code and enter the kernel
in 32bit mode filling in the fields that the 16bit mode code would
have filled in the same way approach.

It isn't clearly documented as a public interface but is the way
everything without a classic x86 BIOS has been booting for quite a
while.  We can even reasonably handle Xen & lguest this way.  Dotting
the last couple of i's and crossing the last couple of t's is a pain
to make it a really solid and documented interface but I haven't
seen any real opposition to it.



On the other side since EFI doesn't not seem to have dual mode
interfaces I think this thread makes a very good case for not using
efi_enter_virtual_mode.  Always using a trampoline and keeping EFI
at it's original physical addresses. 

A trampoline switching to physical mode and maybe doing a 32->64
or 64->32 bit mode switch isn't that hard and should not be noticeably
slower then anything else.  Plus it makes EFI much more useful.


I agree with Andi that the variable services are more interesting
then reboots or setting the CMOS both of which we can talk to the
hardware directly to handle.

Eric

p.s.  On future patches that update the x86 boot protocol please
also copy HPA.  Thanks.
