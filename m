Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbYIFWSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbYIFWSi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 18:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYIFWS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 18:18:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:2751 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYIFWS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 18:18:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wl3jqTdH/vEEE9d3RuId+TWw4vkVPeZd008wSyVUNQcBQhY2r6tChbFnhfGdjPOhdS
         lxnFcuoWGWQqY6caFi+iae2vyPqueFUSITX2vOiamPd5/O2rS9tHa1qB0VBZw3+bLU6S
         IDxAKOUd1lpyBSkRtn1WS7Ae8uYhCgQklMe+s=
Message-ID: <86802c440809061518w1c74c0f4u4ccc7b6b0da7b398@mail.gmail.com>
Date: Sat, 6 Sep 2008 15:18:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alex Chiang" <achiang@hp.com>, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: hotplug create_slot hang
In-Reply-To: <20080906215041.GD27298@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440809061015v21b6c1eat8718618a6ae25e47@mail.gmail.com>
	 <20080906215041.GD27298@ldl.fc.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2008 at 2:50 PM, Alex Chiang <achiang@hp.com> wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com>:
>> calling  pci_hotplug_init+0x0/0x1d
>> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>> initcall pci_hotplug_init+0x0/0x1d returned 0 after 11 msecs
>>
>> calling  acpiphp_init+0x0/0x5f
>> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>> decode_hpp: Could not get hotplug parameters. Use defaults
>> pci_create_slot: created pci_slot on 0000:07:00
>> acpiphp: Slot [1] registered
>> decode_hpp: Could not get hotplug parameters. Use defaults
>> pci_create_slot: created pci_slot on 0000:0d:00
>> acpiphp: Slot [2] registered
>> initcall acpiphp_init+0x0/0x5f returned 0 after 105 msecs
>
> Is this the hang?
>
>> calling  pcied_init+0x0/0x7b
>> pciehp: HPC vendor_id 8086 device_id 340a ss_vid 0 ss_did 0
>> pci_create_slot: inc refcount to 2 on 0000:07:00
>> pci_destroy_slot: dec refcount to 1 on 0000:07:00
>> pciehp: pci_hp_register failed with error -16
>> pciehp: pciehp: slot already registered by another hotplug driver
>
> This failure is by design -- we only allow one hotplug driver to
> claim a slot now, and it's "first one loaded wins".
>
> Unless you're talking about something else?

after

pciehp: pciehp: slot already registered by another hotplug driver

never go on...

YH
