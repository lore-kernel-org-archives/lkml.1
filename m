Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYKCNe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYKCNe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 08:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbYKCNes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 08:34:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52021 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbYKCNer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 08:34:47 -0500
Date: Mon, 3 Nov 2008 11:33:06 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrey Borzenkov <arvidjaar@mail.ru>,
       Avi Kivity <avi@qumranet.com>, mingo@redhat.com,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Use BIOS reboot on Toshiba Portege 4000
Message-ID: <20081103133306.GZ23893@blackpad>
References: <200810312118.45368.arvidjaar@mail.ru> <20081103090843.GI11730@elte.hu> <490ECC4D.9090704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490ECC4D.9090704@redhat.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 12:02:53PM +0200, Avi Kivity wrote:
> Ingo Molnar wrote:
>>> Subject: [PATCH] Use BIOS reboot on Toshiba Portege 4000
>>>
>>> From: Andrey Borzenkov <arvidjaar@mail.ru>
>>>
>>> After commit c7ffa6c26277b403920e2255d10df849bd613380 which defaults
>>> to reboot via ACPI keyboard is dead on Toshiba Portege 4000 upon reboot.
>>> Power off is required to revive it again. Add DMI entry to force BIOS
>>> reboot method as it was before.
>>>
>>> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
>>>     
>>
>> Avi, i expect more boxes to be affected by this bug, and the DMI  
>> solution just does not scale.
>>
>> So could we please disable VMX from the emergency-shutdown code  
>> instead of twiddling with the reboot method?
>>
>> Something like this might work as well: iff VMX is enabled, we just do  
>> smp_send_stop() (instead of skipping it) which should take care of  
>> this.
>>   
>
> There is already some code being worked on for kdump (which suffers from  
> the same symptoms), only kdump uses NMI IPIs for increased stopping  
> power.  Eduardo, can you take a look at porting it to emergency reboot?

We probably need to disable vmx on all CPUs, but emergency reboot skips
native_smp_send_stop() (where we could hook a virt_disable call in).

As relying on IPIs defeats the whole point of emergency_restart, a proper
fix will need to use NMIs like the kdump code does.

-- 
Eduardo
