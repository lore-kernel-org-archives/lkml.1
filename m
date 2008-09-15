Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYIOVlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYIOVlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbYIOVlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:41:08 -0400
Received: from ptb-relay02.plus.net ([212.159.14.146]:58200 "EHLO
	ptb-relay02.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbYIOVlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:41:07 -0400
Message-ID: <48CED670.40105@yahoo.com>
Date: Mon, 15 Sep 2008 22:41:04 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
Subject: Re: Turning off camera also kills card reader on EeePC 900
References: <fa.ynuVPnbW9HmrQpG9wbWk/u+hqkw@ifi.uio.no> <fa.HT4htA0oryTT1h7ADNggfgkJnyY@ifi.uio.no> <fa.5D0cM9TkJ80O2GfXhZm3n4hc+GI@ifi.uio.no> <fa.1xyAj/9KUcq9nDwCEVhSHc5KBBs@ifi.uio.no> <fa.jr7R0e2XSjOS0yWom34xSWH95yM@ifi.uio.no>
In-Reply-To: <fa.jr7R0e2XSjOS0yWom34xSWH95yM@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 3dd8bdff1ab1b6b0194d06b9e3989080
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Sitsofe Wheeler wrote:
>>
>> Alan Jenkins wrote:
>>
>>> The "HC died" message is interesting.  Sounds like the controller for
>>> these two USB devices stops working.  Maybe try unloading and reloading
>>> the ehci module?  I don't think I can help any more though.
>>
>> I compiled the kernel without module support so unless there's some 
>> sysfs trick that can be done...
>>
> Well, since you ask :-P.  Here's an equivalent incantation.  I hope it's 
> not too brittle.  Don't forget to unmount the SD card first.
> 
> cd /sys/module/ehci_hcd/drivers/pci:ehci_hcd
> echo -n 0000:00:1d.7 | sudo tee unbind; echo -n 0000:00:1d.7 | sudo tee 
> bind
> 
> The magic number is the PCI ID for the USB Host Controller, taken from 
> your error message.
> 
> If the manual "bind" works you should then see a symlink, "0000:00:1d.7" 
> in that directory.

Unfortunately when the SD card disappears so do the typical shell 
commands (as that's the device I'm booting off). I was left having to 
use source to look at the contents of things in /sys when the SD card died.

>>> - It might be necessary to compare with the pre-installed OS
>>>  - Is the pre-installed kernel any better (files might be under
>>> /proc/acpi/asus instead)?  I guess you might not have the time or
>>> resources to test that though.
>>
>> The Xandros 2.6.21.4-eeepc install has the following files in 
>> /proc/acpi/asus/
>> brn camera cardr cpufv disp hdps init type wlan
>>
>> I have no idea what cpufv, disp, hdps, init or type are. Doing echo 1 
>> > camera && echo 0 > camera under this setup does NOT disappear the SD 
>> card.
> Rats.  So there is some secret the mainline driver is missing :-(.

Looks it.

>> Additionally brn seems to really represent the current LCD brightness 
>> (whereas it does not on a stock kernel and seems to always be set to -19)
> It might have bitrotted on stock kernels?  The newer interface is under 
> /sys/class/backlight.

Ah I see - the stuff in there is correct. Does that mean that brn should 
quietly disappear now this alternative interface is present?

>> and the hotkeys (e.g. for brightness) seem to respond far more quickly 
>> than the stock kernel too.
> Heh heh.  I know all too much about that.  It's a problem with the ACPI 
> Embedded Controller driver, a hardware bug which triggered a regression 
> in 2.6.25.
> 
> I'm currently running... it claims to be 2.6.27-rc4 but it might be 
> 2.6.27-rc5 or something in between... which includes a fix.  I'm not 
> confident that they haven't broken it again since then.  The problem is 
> there are just so many different types of buggy EC's.  "Fixes" for some 
> buggy hardware break other buggy hardware.  Very nasty.

Sigh. I think I've seen those posts ( 
http://thread.gmane.org/gmane.linux.acpi.devel/32779/focus=33442 ? ) and 
hadn't fully comprehended what you were fighting against. Doesn't this 
just lead to DMI based quirks?

>>>  - The source code is... a 2Gb+ rar file someone would have to download
>>> and pick apart.
>>
>> Does anyone know if the archives on
>> http://support.asus.com/download/download_item_4.aspx?product=20&model=Eee%20PC%20900/Linux&SLanguage=en-us&os=5 
>> (release dates appear to be 5th September 2008) are actually any 
>> different?
>>
> Why do you say that?  Are the filesizes suspiciously identical?

I wish I could say - for some reason every option to download the source 
code in the dropdown on http://eeepc.asus.com/global/download.htm goes 
to a 404 page. I can't say I'm looking forward to downloading 2.6Gbytes 
on this network connection regardless.

--
Sitsofe
