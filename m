Return-Path: <linux-kernel-owner+w=401wt.eu-S1751613AbZEYE4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613AbZEYE4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 00:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbZEYE4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 00:56:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41601 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZEYE4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 00:56:31 -0400
Message-ID: <4A1A24C0.20701@redhat.com>
Date: Mon, 25 May 2009 07:55:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] Xen APIC hooks (with io_apic_ops)
References: <1242170724-13349-1-git-send-email-jeremy@goop.org> <20090519123548.GA26439@elte.hu> <4A19A9A4.8010002@redhat.com> <20090525035158.GB9396@elte.hu>
In-Reply-To: <20090525035158.GB9396@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> We do something similar for Windows (by patching it) very 
>> successfully; Windows likes to touch the APIC TPR ~ 100,000 times 
>> per second, usually without triggering an interrupt.  We hijack 
>> these writes, do the checks in guest context, and only exit if the 
>> TPR write would trigger an interrupt.
>>     
>
> I suspect you aware of that this is about the io-apic not the local 
> APIC. The local apic methods are already driver-ized - and they sit 
> closer to the CPU so they matter more to performance.
>   

Yeah, I gave this as an example.  It's very different -- io-apic vs. 
local apic, paravirtualization vs. patching the guest behind its back, 
Linux vs. Windows.

Of course if we hook the io-apic EOI we'll want to hook the local apic 
EOI as well.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

