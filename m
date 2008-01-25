Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYAYC77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYAYC77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 21:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbYAYC7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 21:59:50 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48105 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbYAYC7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 21:59:49 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ian Campbell <ijc@hellion.org.uk>,
       Ingo Molnar <mingo@elte.hu>,
       Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native format.
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>
	<479634A9.1090908@zytor.com>
	<1201031325.15491.66.camel@cthulhu.hellion.org.uk>
	<47964B7B.9000905@zytor.com> <20080122203611.GA12892@elte.hu>
	<1201121530.30671.15.camel@cthulhu.hellion.org.uk>
	<4797E487.8010108@goop.org>
	<1201167544.30671.64.camel@cthulhu.hellion.org.uk>
	<47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org>
	<479913BA.8000506@zytor.com> <47991809.9060903@goop.org>
	<47991A6C.8060007@zytor.com> <479921F5.9020902@goop.org>
	<479922D0.3010708@zytor.com> <4799248F.9080404@goop.org>
	<47992710.2060108@zytor.com> <47992948.60308@goop.org>
	<47992A3B.7000607@zytor.com> <47992DD9.8060604@goop.org>
	<47992F31.1070705@zytor.com>
Date: Thu, 24 Jan 2008 19:56:22 -0700
In-Reply-To: <47992F31.1070705@zytor.com> (H. Peter Anvin's message of "Thu,
	24 Jan 2008 16:37:05 -0800")
Message-ID: <m1d4rqipex.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Jeremy Fitzhardinge wrote:
>> H. Peter Anvin wrote:
>>> No, if Xen wasn't an issue there wouldn't be anything to do for the PAE case
>>> at all (since the PGD is trivial.)
>>>
>>> Copying PMDs is more or less an analogous case of the !PAE case, once the
>>> allocation is already done.  The allocation should be trivial though, since
>>> this would be a one-time thing.
>>
>> I think we're in vehement agreement here.  In either case, its just a matter
>> of something like:
>>
>>    memcpy(pgd, &pgd[USER_PTRS_PER_PGD], sizeof(pgd_t) * KERNEL_PTRS_PER_PGD);
>>     which would work for both PAE and non-PAE.
>>
>>>> It would be easy enough to add some code on xen side to look for pmd aliases
>>>> when using/pinning a pagetable, and allocate'n'copy a new pmd page as
>>>> needed.  That way the core code can ignore the issue.
>>>
>>> As much as I'd rather see Xen fixing this than having it continue to impact
>>> the kernel, I presume it will take some time to flush the broken hypervisors
>>> out?
>>
>> Sorry, I was unclear.  I meant in the purely Xen-specific parts of the kernel
>> (arch/x86/xen).  It wouldn't require a hypervisor change.
>>
>
> Oh, that makes that option much more viable and probably preferrable.

Note.  I don't believe we use either trampoline (cpu startup or acpi wakeup)
in the hypervisor case (esp Xen).  So we should be able to completely ignore
Xen and do the memcpy of pgd entries.

I expect Xen gives us other cpus already in protected mode (which is overall
the sane thing to do).

Eric
