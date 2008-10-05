Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYJEDzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYJEDzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 23:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYJEDzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 23:55:23 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:48021 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYJEDzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 23:55:23 -0400
Message-ID: <f488382f0810042055o68778028t1bb0754126d6bb0@mail.gmail.com>
Date: Sat, 4 Oct 2008 20:55:21 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: drivers/pci/probe.c compile warnings on -tip
Cc: "Mikael Pettersson" <mikpe@it.uu.se>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <200810010851.15969.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0810010102y551f4a3bs64524fa70ef04ca3@mail.gmail.com>
	 <18659.21853.41967.715062@harpo.it.uu.se>
	 <200810010851.15969.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2008 at 8:51 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wednesday, October 1, 2008 3:47 am Mikael Pettersson wrote:
>> Steven Noonan writes:
>>  > I was hunting down some warnings I got when compiling -tip, and with
>>  > one of them, I'm not sure what would be a proper way to handle it.
>>  >
>>  > If CONFIG_PHYS_ADDR_T_64BIT is not enabled, these warnings show up:
>>  >
>>  > drivers/pci/probe.c: In function '__pci_read_base':
>>  > drivers/pci/probe.c:308: warning: format '%llx' expects type 'long
>>  > long unsigned int', but argument 4 has type 'resource_size_t'
>>  > drivers/pci/probe.c:308: warning: format '%llx' expects type 'long
>>  > long unsigned int', but argument 5 has type 'resource_size_t'
>>  > drivers/pci/probe.c:320: warning: format '%llx' expects type 'long
>>  > long unsigned int', but argument 5 has type 'resource_size_t'
>>  > drivers/pci/probe.c:320: warning: format '%llx' expects type 'long
>>  > long unsigned int', but argument 6 has type 'resource_size_t'
>>  > drivers/pci/probe.c: In function 'pci_read_bridge_bases':
>>  > drivers/pci/probe.c:392: warning: format '%llx' expects type 'long
>>  > long unsigned int', but argument 3 has type 'resource_size_t'
>>  > drivers/pci/probe.c:392: warning: format '%llx' expects type 'long
>>  > long unsigned int', but argument 4 has type 'resource_size_t'
>>  > drivers/pci/probe.c:405: warning: format '%llx' expects type 'long
>>  > long unsigned int', but argument 3 has type 'resource_size_t'
>>  > drivers/pci/probe.c:405: warning: format '%llx' expects type 'long
>>  > long unsigned int', but argument 4 has type 'resource_size_t'
>>  > drivers/pci/probe.c:443: warning: format '%llx' expects type 'long
>>  > long unsigned int', but argument 4 has type 'resource_size_t'
>>  > drivers/pci/probe.c:443: warning: format '%llx' expects type 'long
>>  > long unsigned int', but argument 5 has type 'resource_size_t'
>>  >
>>  >
>>  > Each of the lines is something like this:
>>  >
>>  > printk(KERN_DEBUG "PCI: %s reg %x 64bit mmio: [%llx, %llx]\n",
>>  > pci_name(dev), pos, res->start, res->end);
>>  >
>>  > res->start and res->end are resource_size_t (which is phys_addr_t),
>>  > and are sized either 32-bit or 64-bit, based on whether
>>  > CONFIG_PHYS_ADDR_T_64BIT is set.
>>
>> Oh not those again. Similar warnings in 27-rc's drivers/pci
>> were fixed recently, but apparently someone out there likes
>> to create new ones.
>>
>> The fix is to cast the resource_size_t arguments to unsigned long long.
>> With "%llx" that's the /only/ valid argument type.
>>
>> Also note that these warnings aren't harmless. On 32-bit machines
>> with parameters passed on the stack the mismatch in size between
>> 32-bit resource_size_t and the 64-bit %llx causes undefined
>> behaviour as printk mis-enumerates its parameters.
>
> AFAICT, these are fixed in Linus' tree, maybe the x86 tree needs an update?
>

Hey Ingo, these warnings are still showing up on the latest -tip. Any idea why?

- Steven
