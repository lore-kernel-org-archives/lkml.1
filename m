Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZHKMLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZHKMLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZHKMLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:11:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38853 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbZHKMLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:11:03 -0400
Message-ID: <4A8121FD.1050307@redhat.com>
Date: Tue, 11 Aug 2009 09:47:09 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Olaf Dabrunz <Olaf.Dabrunz@gmx.net>
Subject: Re: drivers/pci/quirks.c: irq_reroute_variant is dead code?
References: <4A6F5670.4010405@goop.org>	<20090807103318.06ed3ecd@jbarnes-g45>	<20090808144520.GB25931@elte.hu> <20090810093228.54406cab@jbarnes-g45>
In-Reply-To: <20090810093228.54406cab@jbarnes-g45>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.08.2009 18:32, Jesse Barnes wrote:
> [Corrected Stefan's address.]

Thanks Jesse! CCing Olaf as well.

> On Sat, 8 Aug 2009 16:45:20 +0200
> Ingo Molnar<mingo@elte.hu>  wrote:
>
>> * Jesse Barnes<jbarnes@virtuousgeek.org>  wrote:
>>
>>> On Tue, 28 Jul 2009 12:50:08 -0700
>>> Jeremy Fitzhardinge<jeremy@goop.org>  wrote:
>>>
>>>> quirk_reroute_to_boot_interrupts_intel() goes to some effort to
>>>> scan for a bunch of Intel devices and set
>>>> dev->irq_reroute_variant = INTEL_IRQ_REROUTE_VARIANT.  However,
>>>> as far as I can see that's the only reference to
>>>> dev->irq_reroute_variant and INTEL_IRQ_REROUTE_VARIANT, so the
>>>> whole thing appears to have no effect.
>>>>
>>>> Is it all dead code?  Is there something else which should be
>>>> there missing?
>>> Hm my quick look couldn't find a user either.  The initial patch
>>> to add that stuff (e1d3a90846b40ad3160bf4b648d36c6badad39ac) had
>>> an ACPI component, but it looks like that may have vanished
>>> somehow (maybe some of the IOAPIC code got shuffled around and
>>> this bit was missed?).
>>>
>>> Stefan or Ingo?
>> I dont remember ioapic interactions. Stefan?
>>
>> 	Ingo
>>

Actually the ACPI part of the commit got trashed by some major ACPI
rewrite. The changes in ACPI code made it non-trivial (as far as I can
see) to manipulate the ACPI IRQ for the relevant devices. I'm not an
ACPI expert and couldn't come up with a solution yet. I'm aware of the
fact that especially the ACPI part was considered arguable by some
people but it was the only place we found to alter the IRQ a driver will
get installed on.
I'd be happy to finally set this right. Any help is greatly appreciated
and I'll try to spend some time with recent ACPI code searching for
possible solutions.

   Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                        | HR: Amtsgericht Muenchen HRB 153243
                        | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
