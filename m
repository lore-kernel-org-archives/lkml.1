Return-Path: <linux-kernel-owner+w=401wt.eu-S1758637AbYEPWOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758637AbYEPWOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbYEPWNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:13:54 -0400
Received: from mx.4pi.com ([24.172.19.59]:54708 "EHLO mx.4pi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbYEPWNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:13:54 -0400
X-Greylist: delayed 1606 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2008 18:13:53 EDT
Mime-Version: 1.0
Message-Id: <p0623098ac453a5767fbb@[192.168.2.55]>
Date: Fri, 16 May 2008 17:46:01 -0400
To: linux-kernel@vger.kernel.org
From: "Scott D. Davilla" <davilla@4pi.com>
Subject: Re: [PATCH] Input: add appleir USB driver
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That would be me sending to Greg. my bad. I should be posting here 
and I've disciplined myself accordingly (a smack upside the head).

The history of the appleir patch is that James McKenzie created it as 
a method to get IR controller support working for the MacMini. This 
was way back in time before Apple EFI even had a PC BIOS 
compatibility layer.

The patch was migrated to the MacTel mactel-linux svn by huceke and 
stayed for 2.6.17, 2.6.18, 2.6.20 and 2.6.21 kernel usage. There were 
numerous other patches there that did not migrate upstream for 
various reasons mainly I think because it was known that they would 
never be accepted. These were niche patches for Linux support on 
Apple hardware, some using EFI boots, others using Apples EFI PC BIOS 
compatibility layer. Some patches were pushed upstream (imacfb), 
others stayed.

In 2.6.22, the appleir patch was dropped at mactel-linux because 
usbhid support was added in the kernel by including the proper 
VID/PID so that the Apple IR devices (now more than one) was 
recognized by usbhid and can be seen as "/dev/usb/usbhid0" typically. 
I'm not sure when support for the MacMini using usbhid was added to 
LIRC.

Just about every distro that has any form of IR support uses LIRC and 
LIRC uses usbhid for Apple IR support. This is a userland device as 
it should be.

The Apple IR remote can increment an IR user device id such that you 
can pair specific IR remotes to computers and not have them control 
each other. This user device id is the last byte in the pre_data 
(LIRC speak) so there are 256 possible values. There are also 256 
possible key values. I believe there might be forbidden values as the 
actual IR protocol has a checksum. You can use a JP1 programmable 
remote or a learning remote to "extend" beyond the six button limit 
of the Apple IR remote controller. Numerous users do this as it 
eliminates having to purchase a replacement IR remote and IR receiver 
if they find a six button IR remote limiting.

So while you could continue with including this patch, you would need 
to include key tables for 256 x 256 keys and provide a method to 
disable this device in favor of the usbhid method. A method to 
disable the usbhid usage could be using the modprobe option usbhid 
quirk and passing the ignore flag (the usbhid modprobe quirk passing 
was enabled in 2.6.23.x

I do not understand why this patch is not dropped. The Apple IR is a 
USB HID device and LIRC handles this very nicely. If you do not want 
to use LIRC, then talk to the usbhid device directly.

I use it for the AppleTV (which has an even different device id). I 
have two patches pending that add IR support and audio support for 
the AppleTV. They are pending even though the patches have existed 
since the 2.6.22 kernel because the only way then to boot the AppleTV 
was a nasty EFI patch which would never be accepted.

The AppleTV now has a stable bootloader (atv-bootloader) that uses a 
standard non-EFI linux kerenel and kexec to launch the real standard 
kernel in a similar method as Linux on the PS3. The atv-bootloader 
translates EFI structures into E820 structures and moves the ACPI and 
SMBIOS pointers to where Linux can find them and sets up for a vesafb 
device. The AppleTV is a pure EFI box with no PC BIOS compatibility 
layer.

With atv-bootloader in place and stable (several months and numerous 
users), now I can work on pushing these two patches upstream.

I'm off list so please "CC" to respond.

Scott








