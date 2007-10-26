Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbXJZC2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbXJZC2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXJZC2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:28:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:61994 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXJZC2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:28:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,330,1188802800"; 
   d="scan'208";a="255883845"
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
	runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, pjones@redhat.com
In-Reply-To: <472118C7.3060909@zytor.com>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	 <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
	 <m1r6jj5e27.fsf@ebiederm.dsl.xmission.com>
	 <20071025095639.22f6cad0@laptopd505.fenrus.org>
	 <4720CCBC.1050700@zytor.com>	<m1y7dr3xha.fsf@ebiederm.dsl.xmission.com>
	 <4720D797.1020903@zytor.com>	<m1tzof3wbk.fsf@ebiederm.dsl.xmission.com>
	 <4720FE38.3050802@zytor.com> <m1lk9q4z17.fsf@ebiederm.dsl.xmission.com>
	 <472118C7.3060909@zytor.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Oct 2007 10:31:19 +0800
Message-Id: <1193365879.23935.263.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Oct 2007 02:28:28.0961 (UTC) FILETIME=[E4F11110:01C81777]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 15:29 -0700, H. Peter Anvin wrote:
> Eric W. Biederman wrote:
> > "H. Peter Anvin" <hpa@zytor.com> writes:
> > 
> >> Eric W. Biederman wrote:
> >>>> Ying claimed that GOP requires EFI runtime services.  Is that not true?
> >>> None of the EFI framebuffer patches that I saw used EFI runtime services.
> >>>
> >> Ying, could you please clarify this situation?
> >>
> >> (Eric: do note that there are two EFI framebuffer standard, UGA and
> >> GOP. Apparently UGA is obsolete and we have always been at war with GOP at the
> >> moment.)
> > 
> > Peter please look back in your email archives to yesterday and
> > see Ying's patch:
> > 
> > [PATCH 1/2 -v2 resend] x86_64 EFI boot support: EFI frame buffer driver
> > 
> > All of the data the GOP needs is acquired through the a query made
> > by the bootloader and passed through screen info.
> > 
> 
> Then I fully agree with your assessment.

EFI framebuffer doesn't depend on EFI runtime service.

But EFI variable service depends on EFI runtime service, and most people
think it is useful. It can be used to:

- Provide a standard method to communicate with BIOS, such as specifying
the boot device or bootloader for the next boot.
- Provide a standard method to write the OOPS information to flash.

To improve the reliability of OOPS information writing, the virtual mode
of EFI should be used. And through mapping all memory area used by EFI
to the same virtual address across kexec, EFI can work with kexec under
virtual mode just like that of IA-64.

So, I think the EFI runtime service is useful and it does not break
anything. But the code duplication between efi_32.c and efi_64.c should
be eliminated and I will work on this.

Best Regards,
Huang Ying
