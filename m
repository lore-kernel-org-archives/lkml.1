Return-Path: <linux-kernel-owner+w=401wt.eu-S1751411AbZKLHVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbZKLHVJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZKLHVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:21:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49009 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZKLHVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:21:05 -0500
Message-ID: <4AFBB72F.6070907@zytor.com>
Date: Wed, 11 Nov 2009 23:20:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: ykzhao <yakui.zhao@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] x86: make sure wakeup code is below 1M -v2
References: <4AF7D820.5040503@kernel.org> <200911091315.13151.rjw@sisk.pl>	 <4AFA210B.3020207@kernel.org>	 <1257930767.31183.113.camel@localhost.localdomain>	 <4AFB0B02.4050306@kernel.org>	 <1257988632.31183.134.camel@localhost.localdomain>	 <4AFB7D21.6050004@kernel.org>	 <1257997072.3888.4.camel@localhost.localdomain>	 <4AFB9B60.7010009@kernel.org> <1258010067.3802.11.camel@localhost.localdomain>
In-Reply-To: <1258010067.3802.11.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2009 11:14 PM, ykzhao wrote:
> 
> In this patch the find_e820_area is used in the
> acpi_reserve_wakeup_memory, which is called after initializing the
> bootmem allocator.
> Can we still use the find_e820_area after the bootmem allocator is
> initialized? 

Obviously not: the bootmem allocator now thinks it owns memory, and it
wouldn't know not to allocate something that is later claimed by
find_e820_area.  Problem.

> It seems that the bootmem bitmap is also found by using the
> find_e820_area. But we don't update the reserved_early array any more.
> Maybe we will get the overlap address with the bootmem bitmap for the
> wakeup code.

Not just the bitmap, but any bootmem allocation could conflict...

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

