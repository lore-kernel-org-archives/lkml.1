Return-Path: <linux-kernel-owner+w=401wt.eu-S1423228AbXEEJjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423228AbXEEJjw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 05:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423264AbXEEJjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 05:39:52 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:53716 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423228AbXEEJjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 05:39:51 -0400
Date: Sat, 5 May 2007 11:37:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: David Johnson <dj@david-web.co.uk>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463C18C4.7030304@interia.pl>
Message-ID: <Pine.LNX.4.61.0705051114130.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
 <200705042320.41278.dj@david-web.co.uk> <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
 <463C18C4.7030304@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 5 2007 07:40, Rafał Bilski wrote:
>Jan,
>
>Can You send output of x86info program and output of 

Where do I find this?

>lspci command? Longhaul wasn't working for You since 2.6.18 right?

# lspci
00:00.0 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
00:00.1 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
00:00.2 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
00:00.3 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
00:00.4 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
00:00.7 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
00:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
00:0e.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
00:0f.0 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 81)
00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge [KT600/K8T800/K8T890 South]
00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
01:00.0 VGA compatible controller: VIA Technologies, Inc. S3 Unichrome Pro VGA Adapter (rev 02)

# dmidecode
Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
        Vendor: Phoenix Technologies, LTD
        Version: 6.00 PG
        Release Date: 11/30/2005
        Address: 0xE0000
        Runtime Size: 128 kB
        ROM Size: 512 kB
        Characteristics:


>I'm going to work now, but I will be available after 14:00 UTC.

2.6.20.2 (2.6.20.2-ccj45-default, slightly different config
than openSUSE 10.2), no preemption, lockup.

2.6.21 (openSUSE 10.3 Alpha 3 2.6.21-3-default), voluntary
preemption, lockup.

If I shall try more combinations, let me know.

>If You have problem with longhaul+powersave there may be one thing 
>related. When I started to change Longhaul it was causing lockups 
>on Epia 800. I added transition protection. Helped, but not for 
>long. After one or two hours machine locked up anyway. I found 
>datasheet in Google and changed "disable BMDMA bit on PCI device" to 
>northbridge support. Problem fixed. Somehow CLE133 chipset didn't 
>like touching "BMDMA master" bits.
>Second: I didn't get answer from VIA why they are blocking ACPI C3 on CPU's 
>faster then 1GHz. I don't know if it is standard practice and if
>Intel and AMD are doing it too.
>
>Things worth checking: disable PREEMPT, change it to "Voluntary preemption". 
>Check if using conservative governor makes any difference. I know that 
>this may sound strange, but transition latency is directly proportional to 
>difference between current and destination frequency. Maybe for faster 
>processors it isn't allowed to change frequency directly from min to max?

I'll try that .. too.


Thanks,
Jan
-- 
