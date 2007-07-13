Return-Path: <linux-kernel-owner+w=401wt.eu-S935709AbXGMWbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935709AbXGMWbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbXGMWbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:31:35 -0400
Received: from opinicus.com ([24.73.193.242]:47696 "EHLO thing2.opinicus.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751782AbXGMWbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:31:34 -0400
Message-ID: <4697FD19.6030005@opinicus.com>
Date: Fri, 13 Jul 2007 18:30:49 -0400
From: William Montgomery <william@opinicus.com>
User-Agent: Mozilla Thunderbird 1.0.6 (X11/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: e100 PCI bridge problem
References: <4697B85B.4040902@opinicus.com> <4697E24A.4030609@intel.com>
In-Reply-To: <4697E24A.4030609@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for responding.  I am very interested to find the source of this 
problem.

Kok, Auke wrote:

> William Montgomery wrote:
>
>> In an earlier post to the list I described a hard lockup condition
>> that occurs on linux kernels 2.4.22, 2.6.13, and 2.6.17 when using
>> a 4 port 10/100 fast ethernet card.  The lockup is easily repeatable
>> and occurs on 2 out of 3 computers.
>>
>> Further testing has revealed that the lockup can be prevented on all
>> computers by making sure the card is installed on the primary PCI bus.
>> If the card is installed in a slot on the secondary PCI bus (behind a
>> PCI to PCI bridge) the lockup occurs.
>
>
> sounds like int-A/B/C/D routing issues

The strange thing is that all the ports on the card work fine for a few 
minutes, then when some condition (as yet unknown) occurs the system 
locks up hard.  I am currently using a PCI bus analyzer to capture bus 
activity just prior to the lockup to try and find out what leads up to 
this condition.

>
>> Are there any PCI tuning registers that I can tweak to get around
>> this problem?  Any changes I could make to the e100 driver to fix this?
>
>
> this issue might be resolvable by quirking the bridgee chips and 
> adjusting any APIC where needed. Unfortunately I don't know much about 
> this but it's physically not possible from the e100 driver. The 
> special (non-intel) card that has these 4 ports onboard contains a 
> bridge chip itself which explains the issues. Even a BIOS issue could 
> be the cause here.

I am aware of the bridge chip on the card but not sure what you mean 
when you say this explains the issues?  I sure would like to figure out 
a way around this.

The PCI info follows:
  00:00.0 Host bridge: Intel Corp. 82845G/GL[Brookdale-G]/GE/PE DRAM 
Controller/Host-Hub Interface (rev 03)
  00:02.0 VGA compatible controller: Intel Corp. 
82845G/GL[Brookdale-G]/GE Chipset Integrated Graphics Device (rev 03)
  00:1d.0 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #1 (rev 02)
  00:1d.1 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #2 (rev 02)
  00:1d.2 USB Controller: Intel Corp. 82801DB (ICH4) USB UHCI #3 (rev 02)
  00:1d.7 USB Controller: Intel Corp. 82801DB (ICH4) USB2 EHCI 
Controller (rev 02)
  00:1e.0 PCI bridge: Intel Corp. 82801BA/CA/DB/EB/ER Hub interface to 
PCI Bridge (rev 82)
  00:1f.0 ISA bridge: Intel Corp. 82801DB (ICH4) LPC Bridge (rev 02)
  00:1f.1 IDE interface: Intel Corp. 82801DB (ICH4) Ultra ATA 100 
Storage Controller (rev 02)
  00:1f.3 SMBus: Intel Corp. 82801DB/DBM (ICH4) SMBus Controller (rev 02)
  01:08.0 Ethernet controller: Intel Corp. 82801BD PRO/100 VE (CNR) 
Ethernet Controller (rev 82)
  01:0c.0 PCI bridge: Pericom Semiconductor: Unknown device 8150 (rev 02)
  02:06.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge 
(non-transparent mode) (rev 15)
  03:04.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
(rev 08)
  03:05.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
(rev 08)
  03:06.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
(rev 08)
  03:07.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] 
(rev 08)

>
> Perhaps the linuxfirmwarekit will reveal more information. In any 
> case, fixing this in software would be a gigantic effort.
>
I will look into that on Monday and report what I find.  It seems like 
it is premature to say how much effort the fix will take since the 
problem is not yet known?  At least not known to me yet.  I would just 
like to find out what parameters on the bridge/bridges might affect this 
problem and how to modify them.

> Auke
>

