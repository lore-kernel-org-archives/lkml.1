Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbXCPIll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbXCPIll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 04:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbXCPIll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 04:41:41 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:51392 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752983AbXCPIlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 04:41:39 -0400
Message-ID: <45FA5842.3070109@vmware.com>
Date: Fri, 16 Mar 2007 00:41:38 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC, PATCH] Fixup COMPAT_VDSO to work with	CONFIG_PARAVIRT
References: <45FA054F.6020107@vmware.com> <45FA0D13.6080601@goop.org> <45FA16FE.7010805@vmware.com> <45FA26DA.7020109@goop.org> <45FA5E7B.76E4.0078.0@novell.com>
In-Reply-To: <45FA5E7B.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>> So I guess the right thing to do is relocate the dynamic stuff via
>> PT_DYNAMIC, and relocate the symtab if its present.
>>     
>
> Symtab should also be deduced from program headers.
>   

Learning more all the time..

> I'm actually surprised this got re-implemented from scratch, when my patch
> already had both variants (one just #ifdef-ed out), and was tested in both
> forms (actually, I first implemented the ELF form, and only after seeing the
> bloat it added to the sources I came up her than with the second variant, which in
> the end unfortunately didn't add significantly less bloat to the Makefile.
>   

This wasn't re-implemented from scratch - I did this in another lifetime:

http://lists.xensource.com/archives/html/xen-devel/2005-08/msg00284.html

Either way of doing things is fine with me - I would just prefer that if 
it has to get down and dirty, we do it in source rather than hidden in a 
makefile.  But just a personal preference.

Zach
