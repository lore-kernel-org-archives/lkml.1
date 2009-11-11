Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbZKKTHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbZKKTHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758521AbZKKTHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:07:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:41062 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758469AbZKKTHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:07:03 -0500
Message-ID: <4AFB0B02.4050306@kernel.org>
Date: Wed, 11 Nov 2009 11:05:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: ykzhao <yakui.zhao@intel.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
References: <4AF7D820.5040503@kernel.org> <200911091315.13151.rjw@sisk.pl>	 <4AFA210B.3020207@kernel.org> <1257930767.31183.113.camel@localhost.localdomain>
In-Reply-To: <1257930767.31183.113.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ykzhao wrote:
> On Wed, 2009-11-11 at 10:27 +0800, Yinghai Lu wrote:
>> try to find_e820_area/reserve_early, and call acpi_reserve_memory early
>>
>> to get area is below 1M
>>
>> -v2: change function name to acpi_reserve_wakeup_memory according to Rafael
> It seems that the function of find_e820_area is called in several
> places.
>    >Initmem_init: bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT,
> bootmap_size, PAGE_SIZE);
>    
> If we also call it in the acpi_reserve_wakeup_memory, do we get the same
> base address as that obtained in initmem_init?

no. find_e820_area will check the reserve res array that could be updated by reserve_early.

YH
