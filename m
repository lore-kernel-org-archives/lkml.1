Return-Path: <linux-kernel-owner+w=401wt.eu-S1767349AbXDEWSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767349AbXDEWSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767367AbXDEWSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:18:38 -0400
Received: from lucidpixels.com ([75.144.35.66]:41786 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767349AbXDEWSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:18:38 -0400
Date: Thu, 5 Apr 2007 18:18:37 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: Re: Any Intel folks on the list? Intel PCI-E bridge ACPI resource
 question
In-Reply-To: <Pine.LNX.4.64.0704051812340.14476@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0704051818020.14651@p34.internal.lan>
References: <Pine.LNX.4.64.0704051809160.14476@p34.internal.lan>
 <Pine.LNX.4.64.0704051812340.14476@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Apr 2007, Justin Piszcz wrote:

>
>
> On Thu, 5 Apr 2007, Justin Piszcz wrote:
>
>> http://www.ussg.iu.edu/hypermail/linux/kernel/0701.3/0315.html
>> 
>> I have similar issues as this poster-- I was wondering (if anyone) had an 
>> idea to the root cause of this issue; is it a problem with the chipset, the 
>> BIOS revision?
>> 
>> Mobo: Intel DG965WHMKR
>> BIOS: 1666
>> 
>> Is it only Intel Chipsets that suffer from this problem?
>> 
>> ... or is it a way the kernel handles ACPI/IO-APIC/etc?
>> 
>> Justin.
>> 
>
> p34:~# /usr/bin/time badblocks -b 512 -s -v -w /dev/sdl
> Checking for bad blocks in read-write mode
> From block 0 to 293046768
> Testing with pattern 0xaa: done
> Reading and comparing: done
> Testing with pattern 0x55: done
> Reading and comparing: done
> Testing with pattern 0xff: done
> Reading and comparing: done
> Testing with pattern 0x00: done
> Reading and comparing: done
> Pass completed, 0 bad blocks found.
> 1929.06user 467.89system 4:36:23elapsed 14%CPU (0avgtext+0avgdata
> 0maxresident)k
> 0inputs+0outputs (1major+257minor)pagefaults 0swaps
> p34:~#
>
> Not a single bad block found.  Does the ICH8 chipset have issues, or the
> cards I am using and how they are routed?
>
> Any suggestions as to what this is?
>
> Justin.
>
>

http://www.linuxhq.com/kernel/v2.6/18/drivers/scsi/sata_sil24.c

+   [PORT_CERR_SEND]   = { AC_ERR_ATA_BUS, ATA_EH_SOFTRESET,
+                "failed to transmit command FIS" },
+   [PORT_CERR_INCONSISTENT] = { AC_ERR_HSM, ATA_EH_SOFTRESET,
+                 "protocol mismatch" },

Is this a chipset or a problem with the PCI-e x1 SiI dual SATA port card?

Justin.
