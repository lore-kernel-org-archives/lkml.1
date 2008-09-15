Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYIONhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYIONhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 09:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYIONhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 09:37:22 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:18304 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbYIONhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 09:37:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=LstD8SaRcHHL90DfJzOAAuOz/M1JEmGQP2qgd3OvEkLj4zUaIOM2mY2cSIFegDM+g9
         lYCq1ccAdQpME4n9g6P/tuNoWSwPFY6ZBlMyGE0mwibsQzj3msxustZYilPselNkWxEy
         3Iq1lxLJt3IozuEHozW+3qvX/SAoXBj4Jc2JU=
Message-ID: <48CE650B.6000708@tuffmail.co.uk>
Date: Mon, 15 Sep 2008 14:37:15 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Corentin Chary <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
Subject: Re: Turning off camera also kills card reader on EeePC 900
References: <48CE217A.1080409@tuffmail.co.uk> <48CE52EC.9060505@yahoo.com>
In-Reply-To: <48CE52EC.9060505@yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> Alan Jenkins wrote:
>> Firstly, I understand these kill-switches are supposed to be persistent
>> over reboots.  You should check that the SD card stays disabled when you
>> reboot.
>
> The settings are persistent (so changing a camera value that is 0 to 1
> will show the camera as being enabled if you go to the BIOS). However
> the SD card will be present at reboot.
>
>> Next, these settings are also exposed in the BIOS configuration screen,
>> right?  If it's the same as my 701 then the BIOS will have a separate
>> option for disabling the cardreader.  So you could see if the platform
>> driver "camera" switch is simply disabling and enabling the two switches
>> together.
>
> The option for disabling the cardreader is indeed separate from the
> one to disable the camera. There is, however a switch for disabling
> USB in the BIOS too...
>
>> Or if there's only a BIOS option for the camera, and not the SD card,
>> then you should test whether it disables the SD card.
>
> OK there are separate switches in the BIOS for disabling (among other
> things) the Camera, CardReader, and USB Ports.
>
> Doing echo 0 > camera when camera is already 0 does nothing. The value
> in cardr remains 1.
> Doing echo 0 > camera when camera is 1 seemingly results in the SD
> card disappearing too (ehci_hcd 0000:00:1d.7: HC died; cleaning up).
> cardr value remains 1. The CardReader and USB Ports options will be in
> the enabled state when looking in the BIOS after rebooting. The Camera
> option will be in the disabled state in the BIOS.
> Doing echo 1 > camera after the SD card  has disappeared (but before
> rebooting) in the above step will result in the SD card seemingly
> coming back at a different address and the kernel reporting 'irq 23:
> nobody cared (try booting with the "irqpoll" option)' and a
> usb_hcd_irq backtrace.
> Doing echo 0 > cardr when cardr is 1 results in the SD card
> disappearing and an ext3 error being printed on the console. The
> CardReader option will be in the disabled state in the BIOS after
> rebooting.
> Doing echo 0 > camera after the SD card  has disappeared (but before
> rebooting) in the above step will result in 'ehci_hcd 0000:00:1d.7: HC
> died; cleaning up' being printed.
>

Ok.  So the platform driver settings do match those in the BIOS.  My
guess would be the platform driver is fine and the BIOS screws up.

The "HC died" message is interesting.  Sounds like the controller for
these two USB devices stops working.  Maybe try unloading and reloading
the ehci module?  I don't think I can help any more though.

- I CC: the maintainer, maybe Corentin has other reports or ideas

- Are any BIOS upgrades available?  None of them mention this problem,
but the descriptions often miss out details. [1][2]

- It might be necessary to compare with the pre-installed OS
 - Is the pre-installed kernel any better (files might be under
/proc/acpi/asus instead)?  I guess you might not have the time or
resources to test that though.
 - The source code is... a 2Gb+ rar file someone would have to download
and pick apart.

Regards
Alan

[1] Asus downloads <http://eeepc.asus.com/global/download.htm>
[2] BIOS update howto <http://wiki.eeeuser.com/howto:updatebios>
