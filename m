Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYFKBvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYFKBvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 21:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbYFKBu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 21:50:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51958 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbYFKBu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 21:50:58 -0400
Message-ID: <484F2F05.3050001@jp.fujitsu.com>
Date: Wed, 11 Jun 2008 10:48:53 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4, v14] PCI, ACPI: Physical PCI slot objects
References: <20080604200829.GC379@ldl.fc.hp.com> <484CE515.4030205@jp.fujitsu.com> <20080609221108.GA16588@ldl.fc.hp.com> <484DEF46.7080106@jp.fujitsu.com> <20080610173408.GE25295@ldl.fc.hp.com>
In-Reply-To: <20080610173408.GE25295@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex-san, Jesse-san,

> Note how we're checking get_slot_from_name. That should prevent
> your scenario (b) that you describe above.
> 
> Maybe the diff was confusing, but I am definitely not removing
> your code. I'm simply adding on top of a86161b3134465f, and not
> removing it.
>

I have to apologize. I was using v14 unintentionally on my test
environment yesterday, while I thought I was using v15.

I think v15 will prevent senario (b), though I have not tried it
yet. I'll check it again.

And I agree that Alex-san's patch go to Jesse-san's linux-next.
If I found something after that, I'll report it or send a
incremental patch. To tell the truth, I have several patches
that are waiting for Alex-san's patch to be merged to linux-next:)

>> I made a below patch to prevent (b), please take a look. And could you
>> please consider merging it to "[PATCH 2/3] Introduce pci_slot" in your
>> latest series.
> 
> Ok, now this is very confusing to me. Why is this patch so
> different from a86161b3134465f?
> 
> Are you saying the call to get_slot_from_name() is no longer
> sufficient?
> 

Though I might misunderstand something about your patch, I thought
get_slot_from_name() approach would break what your patch is trying
to do.

My understanding about your patch is as follows:

(x) If multiple hotplug drivers try to register the same slot (try
    to handle the same slot, in other words), pci_hp_register()
    returns -EBUSY.

(y) If one or more drivers try to assign the same name to multiple
    slots, pci_hp_register() returns -EEXIST.

I thought senario (x) will return -EEXIST instead of -EBUSY if we
use get_slot_from_name() approach. So I made a different patch.

In addition, regardless of whether my understanding is correct or not,
I noticed my patch I sent yesterday might be not good, because I made
it under the misunderstanding that I thought pci_hp_register() is called
even by ACPI pci slot driver...

Anyway, I'll look at your patch again after having several cups of coffee.

Thanks,
Kenji Kaneshige

