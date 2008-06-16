Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbYFPFjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbYFPFjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 01:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYFPFjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 01:39:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60059 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYFPFjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 01:39:40 -0400
Message-ID: <4855FC70.9050900@zytor.com>
Date: Sun, 15 Jun 2008 22:38:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: use add_highpages_with_active_regions for high	pages
 init
References: <200806132005.45836.yhlu.kernel@gmail.com>	 <200806140056.32601.yhlu.kernel@gmail.com> <20080614082343.GB11277@elte.hu>	 <86802c440806140205g3ff113ffq39272c18ef5b9654@mail.gmail.com>	 <1213579241.2433.7.camel@caritas-dev.intel.com>	 <86802c440806152046s71916de8g6f8e3e8d272d336a@mail.gmail.com> <1213594669.10376.19.camel@caritas-dev.intel.com>
In-Reply-To: <1213594669.10376.19.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> On Sun, 2008-06-15 at 20:46 -0700, Yinghai Lu wrote:
> [...]
>> don't need,
>> EFI memmap should be reserved in e820map, so it should not show up in
>> early_node_map.
> 
> I don't think so. EFI memmap comes from boot-loader not from BIOS. It
> contains boot-loader execution information (such as EfiLoaderCode,
> EfiLoaderData, etc), and it will be located at different position for
> each system reboot.
> 
> If it is reserved in E820 memmap, hibernation can not work. Because the
> memory area for EFI memmap is not E820 RAM, it is not saved during
> hibernating and restored after restoring from disk.
> 
> Linked list of struct setup_data has similar requirement too.
> 

That doesn't mean we can't use the E820 memory map structure for it.  We 
just have to define a new kernel-internal memory type, instead of using 
type 2 (reserved).

	-hpa
