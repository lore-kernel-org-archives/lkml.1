Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYI3PcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYI3PcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYI3PcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:32:16 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:6418 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYI3PcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:32:16 -0400
Message-Id: <48E262BD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Tue, 30 Sep 2008 16:32:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Joel Schopp" <jschopp@austin.ibm.com>,
       "Andy Whitcroft" <apw@shadowen.org>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Randy Dunlap" <rdunlap@xenotime.net>
Cc: "Linux Kernel Development" <linux-kernel@vger.kernel.org>
Subject: [PATCH] checkpatch: Check for %L for all integer formats (was:
	 Re:[PATCH] fix printk format compiler warnings)
References: <48C13CE0.76E4.0078.0@novell.com>
 <Pine.LNX.4.64.0809301314270.6954@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0809301314270.6954@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> 30.09.08 13:29 >>>
>On Fri, 5 Sep 2008, Jan Beulich wrote:
>> %llx and the like cannot be used on u64-derived data types - they must
>> be cast to long long explicitly for arch-es where u64 is a typedef of
>> unsigned long (ia64 is where I observed the problem).
>
>> -		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
>> +		printk(KERN_INFO "PCI: bridge %s io port: [%Lx, %Lx]\n",
>
>> -		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
>> +		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%Lx, %Lx]\n",
>
>> -		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
>> +		printk(KERN_INFO "PCI: bridge %s %dbit mmio pref: [%Lx, %Lx]\n",
>
>> -		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n", bus->number, i, (res->flags & IORESOURCE_IO)? "io port":"mmio", res->start, res->end);
>> +		printk(KERN_INFO "bus: %02x index %x %s: [%Lx, %Lx]\n",
>
>Why did you replace `%ll' by `%L'?

Because it's one byte shorter.

>While `L' is used as an internal flag in Linux' vsnprintf() implementation and
>is still supported because of historical (pre-C99) reasons, the `L' conversion
>qualifier is meant for the `long double' floating point type, as per C99.
>The recommended conversion qualifier for the `long long' integer type is `ll'.

I understand all of this, but can't see why you would care about floating point
formats in the kernel (when specifically you know that vsnprintf() & Co aren't
able to handle it anyway).

So I think rather than widening the set of specifiers checkpatch looks for, the
check should rather be removed altogether.

Jan

