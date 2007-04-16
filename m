Return-Path: <linux-kernel-owner+w=401wt.eu-S1752696AbXDPNeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbXDPNeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 09:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXDPNeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 09:34:11 -0400
Received: from smtp-1.hut.fi ([130.233.228.91]:47067 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXDPNeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 09:34:10 -0400
Date: Mon, 16 Apr 2007 16:33:13 +0300 (EEST)
From: Mikko Tiihonen <mikko.tiihonen@iki.fi>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: clemens@ladisch.de, bob.picco@hp.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] hpet: Enable hidden HPET on NVidia motherboards
In-Reply-To: <m3y7kssg98.fsf@maximus.localdomain>
Message-ID: <Pine.OSF.4.64.0704161624010.487506@kosh.hut.fi>
References: <1176708094.22969.7.camel@dual.local> <m3y7kssg98.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at putosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 16 Apr 2007, Krzysztof Halasa wrote:

> Mikko Tiihonen <mikko.tiihonen@iki.fi> writes:
>
>> Enables HPET for NVidia motherboards with broken BIOS. The patch reads
>> the HPET address from the pci config space. The patch should also work
>> if ACPI is disabled.
>>
>> The HPET search is done in early-quirks because even
>> DECLARE_PCI_FIXUP_EARLY was too late. If the new quirk causes problems
>> it can be disabled with the nohpet boot option.
>>
>> The patch assumes that the BIOS has done the basic setup of HPET, but
>> has not published the result in ACPI tables. This is at least true for
>> some Asus and Gigabyte motherboards.
>
> I think the code should only be enabled by its CONFIG_*.

Currently the all the code is protected by CONFIG_HPET.
Are you proposing to use for example CONFIG_HPET_NVIDIA instead?

I think that the code should be safe even without it's own config option.
It won't override values from ACPI tables and can still be disabled with
nohpet boot option. Also all the code and data are __init.

-Mikko
