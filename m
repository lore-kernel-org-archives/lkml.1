Return-Path: <linux-kernel-owner+w=401wt.eu-S1753063AbYAYAbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbYAYAbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYAYAbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:31:25 -0500
Received: from gw.goop.org ([64.81.55.164]:52520 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbYAYAbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:31:24 -0500
Message-ID: <47992DD9.8060604@goop.org>
Date: Thu, 24 Jan 2008 16:31:21 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ian Campbell <ijc@hellion.org.uk>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?TWlrYSBQZW50dGlsw6Q=?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>	 <47939363.8040603@kolumbus.fi>	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>	 <479510CE.7010706@zytor.com>	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>	 <479551FD.5040801@zytor.com>	 <1201023401.5643.52.camel@localhost.localdomain>	 <479634A9.1090908@zytor.com>	 <1201031325.15491.66.camel@cthulhu.hellion.org.uk>	 <47964B7B.9000905@zytor.com>  <20080122203611.GA12892@elte.hu>	 <1201121530.30671.15.camel@cthulhu.hellion.org.uk>	 <4797E487.8010108@goop.org> <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <47990BDC.4070008@zytor.com> <479912B0.2080506@goop.org> <479913BA.8000506@zytor.com> <47991809.9060903@goop.org> <47991A6C.8060007@zytor.com> <479921F5.9020902@goop.org> <479922D0.3010708@zytor.com> <4799248F.9080404@goop.org> <47992710.2060108@zytor.com> <47992948.60308@goop.org> <47992A3B.7000607@zytor.com>
In-Reply-To: <47992A3B.7000607@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> No, if Xen wasn't an issue there wouldn't be anything to do for the 
> PAE case at all (since the PGD is trivial.)
>
> Copying PMDs is more or less an analogous case of the !PAE case, once 
> the allocation is already done.  The allocation should be trivial 
> though, since this would be a one-time thing.

I think we're in vehement agreement here.  In either case, its just a 
matter of something like:

    memcpy(pgd, &pgd[USER_PTRS_PER_PGD], sizeof(pgd_t) * KERNEL_PTRS_PER_PGD);
      

which would work for both PAE and non-PAE.

>> It would be easy enough to add some code on xen side to look for pmd 
>> aliases when using/pinning a pagetable, and allocate'n'copy a new pmd 
>> page as needed.  That way the core code can ignore the issue.
>
> As much as I'd rather see Xen fixing this than having it continue to 
> impact the kernel, I presume it will take some time to flush the 
> broken hypervisors out? 

Sorry, I was unclear.  I meant in the purely Xen-specific parts of the 
kernel (arch/x86/xen).  It wouldn't require a hypervisor change.

    J
