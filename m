Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbYFZJrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbYFZJrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYFZJrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:47:07 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:18729 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYFZJrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Tk1A/0BLqtbvTfs8uscr9tYXujT6abx5DHG4T4/yOT9YfEI0fItBt4YutI1wAigErw
         m9c1t9659BK00jVu1WayFJ0xkyEpUiMHEEcyGDpBCbh7cFuoKOm653kkWHR72sc6Pk8L
         5DKL2NZhnBc+1im0VK0utINnthLfvRV/JUe1c=
Message-ID: <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com>
Date: Thu, 26 Jun 2008 02:47:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1214466513.11346.30.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <1214461978.10809.6.camel@caritas-dev.intel.com>
	 <86802c440806260025v3fc1970aq682b568cccba4b4e@mail.gmail.com>
	 <1214466513.11346.30.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m5Q9lMfq030741

On Thu, Jun 26, 2008 at 12:48 AM, Huang, Ying <ying.huang@intel.com> wrote:> On Thu, 2008-06-26 at 00:25 -0700, Yinghai Lu wrote:> [...]>> >                if (pfn >= limit_pfn)>> > @@ -977,7 +978,7 @@ u64 __init early_reserve_e820(u64 startt>> >                return 0;>> >>> >        addr = round_down(start + size - sizet, align);>> > -       e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);>> > +       e820_update_range(addr, sizet, E820_RAM, E820_RESVD_KERN);>>>> this line is not needed.>> Why? Memory reserved by early_rserved_e820 should not be saved during> hibernation? shoudl not be saved by kdump?>>> >        printk(KERN_INFO "update e820 for early_reserve_e820\n");>> >        update_e820();>> >>> > @@ -1191,6 +1192,7 @@ void __init e820_reserve_resources(void)>> >        res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);>> >        for (i = 0; i < e820.nr_map; i++) {>> >                switch (e820.map[i].type) {>> > +               case E820_RESVD_KERN:>> >                case E820_RAM:  res->name = "System RAM"; break;>> >                case E820_ACPI: res->name = "ACPI Tables"; break;>> >                case E820_NVS:  res->name = "ACPI Non-volatile Storage"; break;>> >>> > -->>>> please  move reserve_setup_data() from head.c/head64.c to setup32/64.c>> or merged setup.c>> OK.>>> also need to change reserve_early in reserve_setup_data to>> e820_update_range(,,E820_RAM, E820_RESEVED_EXTRA).>> ï»¿Does this means reserve_early() should be replaced by> e820_update_range()?
Yes. in your case.
>>> calling reserve_setup_data() should around early_reserve_e820_mpc_new.>> I think reserve_xxx should be called before first find_e820_area() to> minimize the possibility of conflict.You already call e820_update_range, that could prevent find_e820_areato get confused.
YHÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
