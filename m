Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbYFKCx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbYFKCx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 22:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbYFKCxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 22:53:20 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29579 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbYFKCxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 22:53:19 -0400
Date: Tue, 10 Jun 2008 20:53:16 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4, v14] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080611025316.GB12778@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	jbarnes@virtuousgeek.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	kristen.c.accardi@intel.com, greg@kroah.com, lenb@kernel.org,
	pbadari@us.ibm.com, linux-pci@vger.kernel.org,
	pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080604200829.GC379@ldl.fc.hp.com> <484CE515.4030205@jp.fujitsu.com> <20080609221108.GA16588@ldl.fc.hp.com> <484DEF46.7080106@jp.fujitsu.com> <20080610173408.GE25295@ldl.fc.hp.com> <484F2F05.3050001@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484F2F05.3050001@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex-san, Jesse-san,
>
>> Note how we're checking get_slot_from_name. That should prevent
>> your scenario (b) that you describe above.
>>
>> Maybe the diff was confusing, but I am definitely not removing
>> your code. I'm simply adding on top of a86161b3134465f, and not
>> removing it.
>>
>
> I have to apologize. I was using v14 unintentionally on my test
> environment yesterday, while I thought I was using v15.
>
> I think v15 will prevent senario (b), though I have not tried it
> yet. I'll check it again.

You can check either v15, which applies to Stephen Rothwell's
linux-next, or you can check v16, which applies to Jesse's
linux-next.

The only difference is in patch 1/3, where we are touching
fakephp, which is not the patch that is confusing us here. :)

> And I agree that Alex-san's patch go to Jesse-san's linux-next.
> If I found something after that, I'll report it or send a
> incremental patch. To tell the truth, I have several patches
> that are waiting for Alex-san's patch to be merged to linux-next:)

Yeah, I think incremental patches from here out are good.

>>> I made a below patch to prevent (b), please take a look. And could you
>>> please consider merging it to "[PATCH 2/3] Introduce pci_slot" in your
>>> latest series.
>>
>> Ok, now this is very confusing to me. Why is this patch so
>> different from a86161b3134465f?
>>
>> Are you saying the call to get_slot_from_name() is no longer
>> sufficient?
>>
>
> Though I might misunderstand something about your patch, I thought
> get_slot_from_name() approach would break what your patch is trying
> to do.
>
> My understanding about your patch is as follows:
>
> (x) If multiple hotplug drivers try to register the same slot (try
>    to handle the same slot, in other words), pci_hp_register()
>    returns -EBUSY.
>
> (y) If one or more drivers try to assign the same name to multiple
>    slots, pci_hp_register() returns -EEXIST.

That was the original intent, but I think that returning -EEXIST
for (x) should be sufficient. If it turns out we really do want
-EBUSY for (x), we can add your latest fixup patch later.

> I thought senario (x) will return -EEXIST instead of -EBUSY if we
> use get_slot_from_name() approach. So I made a different patch.
>
> In addition, regardless of whether my understanding is correct or not,
> I noticed my patch I sent yesterday might be not good, because I made
> it under the misunderstanding that I thought pci_hp_register() is called
> even by ACPI pci slot driver...

Yes, it is confusing.

	- PCI hotplug drivers call pci_hp_register()

	- pci_hp_register() calls pci_slot_create()
	- ACPI pci slot driver calls pci_slot_create()

So the get_slot_from_name() approach will not break the ACPI pci
slot driver, and it will continue to fix the broken platforms you
are dealing with.

> Anyway, I'll look at your patch again after having several cups of coffee.

:)

Thanks,

/ac

