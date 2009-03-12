Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZCLLZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZCLLZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbZCLLY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:24:58 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:34430 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZCLLY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:24:57 -0400
Message-Id: <49B8FF3E.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 11:25:34 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <jeremy.fitzhardinge@citrix.com>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86-64: fix HYPERVISOR_update_descriptor()
References: <49B8F3D4.76E4.0078.0@novell.com>
 <20090312105426.GC30204@elte.hu>
In-Reply-To: <20090312105426.GC30204@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 12.03.09 11:54 >>>
>* Jan Beulich <jbeulich@novell.com> wrote:
>> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> 
>> ---
>>  arch/x86/include/asm/xen/hypercall.h |    2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> --- linux-2.6.29-rc7/arch/x86/include/asm/xen/hypercall.h	2009-03-11 17:52:10.000000000 +0100
>> +++ 2.6.29-rc7-x86_64-xen-update-descr/arch/x86/include/asm/xen/hypercall.h	2009-02-13 11:41:39.000000000 +0100
>> @@ -296,6 +296,8 @@ HYPERVISOR_get_debugreg(int reg)
>>  static inline int
>>  HYPERVISOR_update_descriptor(u64 ma, u64 desc)
>>  {
>> +	if (sizeof(u64) == sizeof(long))
>> +		return _hypercall2(int, update_descriptor, ma, desc);
>>  	return _hypercall4(int, update_descriptor, ma, ma>>32, desc, desc>>32);
>
>missing changelog and Impact line.

I'm confused: What point is there to add a textual description that matches
the subject? And where is the need for an impact line documented (clearly
neither SubmitChecklist no SubmittingPatches have any occurrence of the
word impact), i.e. what are the valid values to chose from?

Jan

