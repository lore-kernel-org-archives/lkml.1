Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbYJTHwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbYJTHwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751134AbYJTHwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:52:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52450 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbYJTHwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:52:16 -0400
Message-ID: <48FC38AE.3030007@suse.de>
Date: Mon, 20 Oct 2008 09:52:14 +0200
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: "M. Vefa Bicakci" <bicave@superonline.com>
Cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Olaf Dabrunz <odabrunz@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.27: "irq 18: nobody cared" on Toshiba Satellite
 A100
References: <48FB3ED5.60904@superonline.com> <1224431722.26279.4.camel@sven.thebigcorporation.com> <48FB6321.7030501@superonline.com>
In-Reply-To: <48FB6321.7030501@superonline.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

M. Vefa Bicakci wrote:
> Sven-Thorsten Dietrich wrote:
>> On Sun, 2008-10-19 at 10:06 -0400, M. Vefa Bicakci wrote:
>>> Hello,
>>>
>>> As you might guess from the subject line, since I started to use 2.6.27-rcX
>>> series, I began to get "irq 18: nobody cared" messages in dmesg. Currently I am
>>> using 2.6.27.2 with Sidux on this laptop, which is a Toshiba Satellite A100.
>>> I have reproduced this problem with vanilla and sidux's kernels.
>>>
>> Can you provide the contents of /proc/interrupts? 

Could you provide the following:
- output of lspci -nn
- dmesg output with kernel commandline option apic=debug

> My computer is currently in the "nobody cared" state. Here are the current
> contents of /proc/interrupts:
> 
> --- 8< ---
>            CPU0       CPU1       
>   0:   45249492      60399   IO-APIC-edge      timer
>   1:      25451          0   IO-APIC-edge      i8042
>   8:          1          0   IO-APIC-edge      rtc0
>   9:      36514          0   IO-APIC-fasteoi   acpi
>  12:    1147983       2103   IO-APIC-edge      i8042
>  14:     170245          0   IO-APIC-edge      ata_piix
>  15:     558085        819   IO-APIC-edge      ata_piix
>  16:        508          0   IO-APIC-fasteoi   uhci_hcd:usb5, i915@pci:0000:00:02.0
>  17:       1353          0   IO-APIC-fasteoi   firewire_ohci
>  18:     300158          1   IO-APIC-fasteoi   uhci_hcd:usb4, tifm_7xx1, yenta
>  19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  20:      26606          2   IO-APIC-fasteoi   eth0
>  22:    3206279          1   IO-APIC-fasteoi   HDA Intel
>  23:          3          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb2
> 220:    2105545          0   PCI-MSI-edge      iwl3945
> NMI:          0          0   Non-maskable interrupts
> LOC:    5971997   27874747   Local timer interrupts
> RES:     938710    1791498   Rescheduling interrupts
> CAL:     138135     180813   function call interrupts
> TLB:      48455      64413   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> SPU:          0          0   Spurious interrupts
> ERR:          0
> MIS:          0
> --- >8 ---

Nothing unusual at first glance. How long did the system run?

> 
>> If you can reproduce the keyboard issue, it would be helpful to have the
>> above a few seconds before and after the device failure.
> 
> The keyboard issue happens every time I get the "nobody cared" message.
> 
> Unfortunately, this regression requires me to wait a long time before it shows itself.
> As I mentioned in my original e-mail, the "nobody cared" message appears at 3:00
> or 5:00 in the morning. However, I can write a cron job which saves the contents
> of /proc/interrupts every minute or so. If this would be helpful, please let me know.
> 
>>> Note 2: Another interesting thing which might be relevant is the following
>>> message which appears in dmesg some time after I boot:
>>>
>>> --- 8< ---
>>> hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.
>>> --- >8 ---
>>>
>> Is this card using IRQ 18?
> 
> It seems to use IRQ 22. I thought that there might be a connection, but it looks
> like it isn't relevant.
> 
>> Thanks,
>> Sven
> 
> Thank you; I appreciate your help.
> 
> Regards,
> 
> M. Vefa Bicakci
> 

  Stefan

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail : sassmann@suse.de | GF: Markus Rex, HRB 16746 (AG Nuernberg)
