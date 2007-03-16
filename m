Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbXCPIH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbXCPIH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbXCPIH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:07:26 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:48432
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064AbXCPIHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:07:24 -0400
Message-Id: <45FA5E7B.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Fri, 16 Mar 2007 08:08:11 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Zachary Amsden" <zach@vmware.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Virtualization Mailing List" <virtualization@lists.osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, "Linus Torvalds" <torvalds@osdl.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Chris Wright" <chrisw@sous-sol.org>, "Andi Kleen" <ak@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with
	CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com> <45FA0D13.6080601@goop.org>
 <45FA16FE.7010805@vmware.com> <45FA26DA.7020109@goop.org>
In-Reply-To: <45FA26DA.7020109@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 16.03.07 06:10 >>>
>Zachary Amsden wrote:
>> Well testing that is not so fun.  I installed SUSE Pro 9.0, and
>> strings on ld.so contains the magic at_sysinfo assert!  But it doesn't
>> install TLS libraries, so I'll have to install them by hand.
>>
>> In works - in theory.  Look, a puppy!
>>
>> Scratchbox is rumored to produce the fabled assertion even on modern
>> distros by installing its own toolchain which includes the dreaded glibc.
>
>I think Andi and Andrew have boxes which are afflicted.

I have one, too (which is one reasone why I created the original Xen patch).

>> I'm playing safe.  Binary identical relocation to 0xffffe000 was my goal.
>
>Yeah, fair enough.  But as Eric likes to keep pointing out, an
>executable ELF file need not have any sections at all, so the only safe
>course for anything "real" is via the section headers.

Program headers you mean.

>So I guess the right thing to do is relocate the dynamic stuff via
>PT_DYNAMIC, and relocate the symtab if its present.

Symtab should also be deduced from program headers.

I'm actually surprised this got re-implemented from scratch, when my patch
already had both variants (one just #ifdef-ed out), and was tested in both
forms (actually, I first implemented the ELF form, and only after seeing the
bloat it added to the sources I came up with the second variant, which in
the end unfortunately didn't add significantly less bloat to the Makefile.

Jan
