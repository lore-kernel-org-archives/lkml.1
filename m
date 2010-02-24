Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0BXK3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:29:10 -0500
Received: from thoth.sbs.de ([192.35.17.2]:21286 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756471Ab0BXK3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:29:07 -0500
Message-ID: <4B84FF5C.5090603@siemens.com>
Date: Wed, 24 Feb 2010 11:28:44 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, KVM <kvm@vger.kernel.org>,
       Gleb Natapov <gleb@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Kick VCPU outside PIC lock again
References: <20100217135901.331576359@linutronix.de> <4B842A1F.50601@siemens.com> <alpine.LFD.2.00.1002232321320.3232@localhost.localdomain> <4B84F466.2080009@siemens.com> <4B84F5D4.5020202@redhat.com> <4B84F765.5040209@siemens.com> <4B84F9AF.8060804@redhat.com> <4B84FBDB.1070006@siemens.com> <4B84FCBB.8070702@redhat.com> <4B84FDF5.5080106@siemens.com>
In-Reply-To: <4B84FDF5.5080106@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> Avi Kivity wrote:
>> On 02/24/2010 12:13 PM, Jan Kiszka wrote:
>>>    
>>>> I see.  Won't we hit the same issue when we call pic functions from
>>>> atomic context during the guest entry sequence?
>>>>
>>>>      
>>> If there are such call paths, for sure. What concrete path(s) do you
>>> have in mind?
>>>
>>>    
>> vcpu_enter_guest() -> inject_pending_event() -> 
>> kvm_cpu_{has,get}_interrupt() -> various pic functions if you're unlucky.
> 
> But do they kick anyone or just check/pull information? Never saw any
> warnings during my tests last year (granted: with older -rt and kvm
> versions).

Mmh, they could if there is > 1 IRQ pending. Guess this just never
triggered in real life due to typical APIC use and low IRQ load during
PIC times in my tests.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
