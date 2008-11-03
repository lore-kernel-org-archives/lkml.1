Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYKCKET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYKCKET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 05:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbYKCKEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 05:04:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60121 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbYKCKEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 05:04:10 -0500
Message-ID: <490ECC4D.9090704@redhat.com>
Date: Mon, 03 Nov 2008 12:02:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrey Borzenkov <arvidjaar@mail.ru>, Avi Kivity <avi@qumranet.com>,
       mingo@redhat.com, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eduardo Habkost <ehabkost@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] Use BIOS reboot on Toshiba Portege 4000
References: <200810312118.45368.arvidjaar@mail.ru> <20081103090843.GI11730@elte.hu>
In-Reply-To: <20081103090843.GI11730@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> Subject: [PATCH] Use BIOS reboot on Toshiba Portege 4000
>>
>> From: Andrey Borzenkov <arvidjaar@mail.ru>
>>
>> After commit c7ffa6c26277b403920e2255d10df849bd613380 which defaults
>> to reboot via ACPI keyboard is dead on Toshiba Portege 4000 upon reboot.
>> Power off is required to revive it again. Add DMI entry to force BIOS
>> reboot method as it was before.
>>
>> Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
>>     
>
> Avi, i expect more boxes to be affected by this bug, and the DMI 
> solution just does not scale.
>
> So could we please disable VMX from the emergency-shutdown code 
> instead of twiddling with the reboot method?
>
> Something like this might work as well: iff VMX is enabled, we just do 
> smp_send_stop() (instead of skipping it) which should take care of 
> this.
>   

There is already some code being worked on for kdump (which suffers from 
the same symptoms), only kdump uses NMI IPIs for increased stopping 
power.  Eduardo, can you take a look at porting it to emergency reboot?

-- 
error compiling committee.c: too many arguments to function

