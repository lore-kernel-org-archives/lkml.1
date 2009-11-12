Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbZKLDO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbZKLDO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 22:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbZKLDOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 22:14:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:56372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760043AbZKLDOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 22:14:24 -0500
Message-ID: <4AFB7D21.6050004@kernel.org>
Date: Wed, 11 Nov 2009 19:12:33 -0800
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
References: <4AF7D820.5040503@kernel.org> <200911091315.13151.rjw@sisk.pl>	 <4AFA210B.3020207@kernel.org>	 <1257930767.31183.113.camel@localhost.localdomain>	 <4AFB0B02.4050306@kernel.org> <1257988632.31183.134.camel@localhost.localdomain>
In-Reply-To: <1257988632.31183.134.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ykzhao wrote:
> On Thu, 2009-11-12 at 03:05 +0800, Yinghai Lu wrote:
>> ykzhao wrote:
>>> On Wed, 2009-11-11 at 10:27 +0800, Yinghai Lu wrote:
>>>> try to find_e820_area/reserve_early, and call acpi_reserve_memory early
>>>>
>>>> to get area is below 1M
>>>>
>>>> -v2: change function name to acpi_reserve_wakeup_memory according to Rafael
>>> It seems that the function of find_e820_area is called in several
>>> places.
>>>    >Initmem_init: bootmap = find_e820_area(0, end_pfn<<PAGE_SHIFT,
>>> bootmap_size, PAGE_SIZE);
>>>    
>>> If we also call it in the acpi_reserve_wakeup_memory, do we get the same
>>> base address as that obtained in initmem_init?
>> no. find_e820_area will check the reserve res array that could be updated by reserve_early.
> It will check the reserved region array when calling the function of
> find_e820_area. 
> But it seems that the array is not updated when the find_e820_area is
> called in the function of initmem_init.

right after that will use reserve_bootmem for those range in initmem_init.

also we could reserve_early there and let bootmem conversion to do that for us.

but for numa there is some chance to use other node bootmem to for that bootdata and bitmap.
so make it simple just use reserve_bootmem there.

YH
