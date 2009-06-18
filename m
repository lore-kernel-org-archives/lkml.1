Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbZFRVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbZFRVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZFRVJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:09:21 -0400
Received: from claw.goop.org ([74.207.240.146]:47716 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbZFRVJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:09:21 -0400
Message-ID: <4A3AACFD.5020805@goop.org>
Date: Thu, 18 Jun 2009 14:09:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>	<4A36B3EC.7010004@goop.org> <m1fxe117n5.fsf@fess.ebiederm.org>	<4A37F4AE.5050902@goop.org> <m1vdmvxe3u.fsf@fess.ebiederm.org>	<4A392896.9090408@goop.org> <m1zlc6memu.fsf@fess.ebiederm.org>	<4A3A96BC.1000302@goop.org> <m1ab45i8vs.fsf@fess.ebiederm.org>
In-Reply-To: <m1ab45i8vs.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/09 13:28, Eric W. Biederman wrote:
>>> How does Xen handle domU with hardware directly mapped?
>>>   
>>>       
>> We call that "pci passthrough".  Dom0 will bind the gsi to a pirq as
>> usual, and then pass the pirq through to the domU.  The domU will bind
>> the pirq to an event channel, which gets mapped to a Linux irq and
>> handled as usual.
>>     
>
> Interesting.  How does domU find out the pirq -> pci device mapping?
>   

Hm, I haven't looked at it closely, but conventionally it would be via
xenbus (which is how all the split frontend-backend drivers communicate).

>> It is already; once the pirq is prepared, the process is the same in
>> both cases.
>>     
>
> I 3/4 believe that.  map_domain_pirq  appears to setup a per domain
> mapping between the hardware vector and the irq name it is known as.
> So I don't see how that works for other domains.
>
> msi is setup on a per domain basis.
>   

Ah, OK.  The pirq is set up for a specific domain rather than being
global (otherwise it would need some kind of "which domain can access
which pirq" table).  dom0 can either create a pirq for itself or someone
else, and the final user of the pirq binds it to a domain-local evtchn.

I think.  I really haven't looked into the pci-passthrough parts very
closely yet.

    J
