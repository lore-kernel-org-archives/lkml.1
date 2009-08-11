Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbZHKNuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbZHKNuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZHKNuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:50:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58972 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbZHKNuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:50:03 -0400
Message-ID: <4A8176CA.5040501@redhat.com>
Date: Tue, 11 Aug 2009 15:48:58 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Olaf Dabrunz <Olaf.Dabrunz@gmx.net>
CC: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: drivers/pci/quirks.c: irq_reroute_variant is dead code?
References: <4A6F5670.4010405@goop.org> <20090807103318.06ed3ecd@jbarnes-g45> <20090808144520.GB25931@elte.hu> <20090810093228.54406cab@jbarnes-g45> <4A8121FD.1050307@redhat.com> <20090811080622.GA23226@elte.hu> <20090811123605.GD14714@santana.dyndns.org>
In-Reply-To: <20090811123605.GD14714@santana.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.08.2009 14:36, Olaf Dabrunz wrote:
> On 11-Aug-09, Ingo Molnar wrote:
>> * Stefan Assmann<sassmann@redhat.com>  wrote:
>>
>>> On 10.08.2009 18:32, Jesse Barnes wrote:
>>>> [Corrected Stefan's address.]
>>> Thanks Jesse! CCing Olaf as well.
>>>
>>>> On Sat, 8 Aug 2009 16:45:20 +0200
>>>> Ingo Molnar<mingo@elte.hu>   wrote:
>>>>
>>>>> * Jesse Barnes<jbarnes@virtuousgeek.org>   wrote:
>>>>>
>>>>>> On Tue, 28 Jul 2009 12:50:08 -0700
>>>>>> Jeremy Fitzhardinge<jeremy@goop.org>   wrote:
>>>>>>
>>>>>>> quirk_reroute_to_boot_interrupts_intel() goes to some effort to
>>>>>>> scan for a bunch of Intel devices and set
>>>>>>> dev->irq_reroute_variant = INTEL_IRQ_REROUTE_VARIANT.  However,
>>>>>>> as far as I can see that's the only reference to
>>>>>>> dev->irq_reroute_variant and INTEL_IRQ_REROUTE_VARIANT, so the
>>>>>>> whole thing appears to have no effect.
>>>>>>>
>>>>>>> Is it all dead code?  Is there something else which should be
>>>>>>> there missing?
>>>>>> Hm my quick look couldn't find a user either.  The initial patch
>>>>>> to add that stuff (e1d3a90846b40ad3160bf4b648d36c6badad39ac) had
>>>>>> an ACPI component, but it looks like that may have vanished
>>>>>> somehow (maybe some of the IOAPIC code got shuffled around and
>>>>>> this bit was missed?).
>>>>>>
>>>>>> Stefan or Ingo?
>>>>> I dont remember ioapic interactions. Stefan?
>>>>>
>>>>> 	Ingo
>>>>>
>>> Actually the ACPI part of the commit got trashed by some major
>>> ACPI rewrite. [...]
>> Yeah, i remember some larger reject resolved by Len i think, about
>> two cycles ago, in this area. So we probably lost those bits there -
>> i've Cc:-ed Len.
>>
>> There's no urgency in terms of v2.6.31 (since we never really
>> exposed this new functionality in a new release), but it would be
>> nice to get to the bottom of this.
>
> Yep, that would be nice.
>
> I was made aware of that problem early this year when the ACPI code
> change was made. Since then I heard that someone already wrote some
> patch for the boot IRQ quirks. But obviously that referred to some other
> part of the quirk. Stefan?

That's a whole different story (other chipset). ;-)

> As I am currently unemployed, demotivated and trying to get my work on
> fctrace going again (as well as to get the rest of my life in order),
> it seems I have no time to fix this. I would love to, really. We need to
> get these quirks in, and I would like to discuss how to do this The Right
> Way with the rewritten ACPI code (and the existing MP code).

Well, best of luck!

   Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                        | HR: Amtsgericht Muenchen HRB 153243
                        | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
