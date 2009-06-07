Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZFGUhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZFGUhH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 16:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbZFGUg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 16:36:57 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48208 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbZFGUg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 16:36:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NWOCyuvdzl5tmoyBj3XCHqERtP4jGtI46uCTu6wVwCoPjZARYKap3uj/yXXiFFkB7p
         2pYhpEKW6rFzcEdo5sNb4LpPOiqTSDjvPyWQ4XE51LXR7uKc0UBYsHQ4FE+4oXQRGdDJ
         vv2yTSlYx8AdGHWR/hRGZokTJPupi0TLgD5rI=
Message-ID: <4A2C24E3.5090609@gmail.com>
Date: Sun, 07 Jun 2009 22:36:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.2 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: usb fails to suspend [was: mmotm 2009-06-05-16-19]
References: <4A2AA469.5020709@gmail.com> <200906070028.32631.rjw@sisk.pl>
In-Reply-To: <200906070028.32631.rjw@sisk.pl>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2009 12:28 AM, Rafael J. Wysocki wrote:
> On Saturday 06 June 2009, Jiri Slaby wrote:
>> Hi,
>>
>> there is a suspend regression somewhere between mmotm 2009-05-17-12-15
>> and 2009-06-05-16-19:
>> hcd_pci_suspend_noirq(): pci_prepare_to_sleep+0x0/0x80 returns -19
>> pci_pm_suspend_noirq(): hcd_pci_suspend_noirq+0x0/0xb0 returns -19
>> pm_noirq_op(): pci_pm_suspend_noirq+0x0/0x180 returns -19
>> PM: Device 0000:00:1d.2 failed to suspend late: error -19
>>
>> $ lspci -xxvvs 0000:00:1d.2
>> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
>> Controller #3 (rev 02) (prog-if 00 [UHCI])
>>         Subsystem: Intel Corporation 82801I (ICH9 Family) USB UHCI
>> Controller #3
>>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>> ParErr- Stepping- SERR- FastB2B- DisINTx-
>>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>         Latency: 0
>>         Interrupt: pin D routed to IRQ 16
>>         Region 4: I/O ports at d000 [size=32]
>>         Capabilities: [50] Vendor Specific Information <?>
>>         Kernel driver in use: uhci_hcd
>> 00: 86 80 36 29 05 00 90 02 02 00 03 0c 00 00 00 00
>> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 20: 01 d0 00 00 00 00 00 00 00 00 00 00 86 80 36 29
>> 30: 00 00 00 00 50 00 00 00 00 00 00 00 05 04 00 00
>>
>> Any ideas?
> 
> Not really.  Is it -mm-only or is the mainline affected too?

Yup, only an -mm thing. I reverted these two:
pci-pm-read-device-power-state-from-register-after-updating-it.patch
pci-pm-read-device-power-state-from-register-after-updating-it-update.patch
and it works now :).
