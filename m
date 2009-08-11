Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZHKNWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZHKNWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbZHKNWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:22:20 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:51959 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZHKNWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:22:20 -0400
Date: Tue, 11 Aug 2009 10:06:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Assmann <sassmann@redhat.com>, Len Brown <lenb@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Olaf Dabrunz <Olaf.Dabrunz@gmx.net>
Subject: Re: drivers/pci/quirks.c: irq_reroute_variant is dead code?
Message-ID: <20090811080622.GA23226@elte.hu>
References: <4A6F5670.4010405@goop.org> <20090807103318.06ed3ecd@jbarnes-g45> <20090808144520.GB25931@elte.hu> <20090810093228.54406cab@jbarnes-g45> <4A8121FD.1050307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8121FD.1050307@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefan Assmann <sassmann@redhat.com> wrote:

> On 10.08.2009 18:32, Jesse Barnes wrote:
>> [Corrected Stefan's address.]
>
> Thanks Jesse! CCing Olaf as well.
>
>> On Sat, 8 Aug 2009 16:45:20 +0200
>> Ingo Molnar<mingo@elte.hu>  wrote:
>>
>>> * Jesse Barnes<jbarnes@virtuousgeek.org>  wrote:
>>>
>>>> On Tue, 28 Jul 2009 12:50:08 -0700
>>>> Jeremy Fitzhardinge<jeremy@goop.org>  wrote:
>>>>
>>>>> quirk_reroute_to_boot_interrupts_intel() goes to some effort to
>>>>> scan for a bunch of Intel devices and set
>>>>> dev->irq_reroute_variant = INTEL_IRQ_REROUTE_VARIANT.  However,
>>>>> as far as I can see that's the only reference to
>>>>> dev->irq_reroute_variant and INTEL_IRQ_REROUTE_VARIANT, so the
>>>>> whole thing appears to have no effect.
>>>>>
>>>>> Is it all dead code?  Is there something else which should be
>>>>> there missing?
>>>> Hm my quick look couldn't find a user either.  The initial patch
>>>> to add that stuff (e1d3a90846b40ad3160bf4b648d36c6badad39ac) had
>>>> an ACPI component, but it looks like that may have vanished
>>>> somehow (maybe some of the IOAPIC code got shuffled around and
>>>> this bit was missed?).
>>>>
>>>> Stefan or Ingo?
>>> I dont remember ioapic interactions. Stefan?
>>>
>>> 	Ingo
>>>
>
> Actually the ACPI part of the commit got trashed by some major 
> ACPI rewrite. [...]

Yeah, i remember some larger reject resolved by Len i think, about 
two cycles ago, in this area. So we probably lost those bits there - 
i've Cc:-ed Len.

There's no urgency in terms of v2.6.31 (since we never really 
exposed this new functionality in a new release), but it would be 
nice to get to the bottom of this.

	Ingo
