Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbXIYHzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbXIYHzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbXIYHz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:55:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:16081 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbXIYHz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:organization:to:subject:date:user-agent:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XF7LwRoPEXkVcXTCKArrchX7bcYyQxsvZzDYr1x2mty4MN0Q7gOnFQRXQnZ6oRf/hhSa0taycSBVOyDhDSFSYHMPK0BOL7FUQ7cCLHHkLfZF/T6AXYagHG2cNJ9KiG1h3+9SSoQN/+fXY/dO91Ekpo7oHB4BiBgGZZSx/LjCDTg=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: linux-kernel@vger.kernel.org
Subject: s2ram + usb
Date: Tue, 25 Sep 2007 10:55:21 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709251055.21767.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been trying to make suspend-to-ram part of my day-by-day life, but there
are still some issues. For example, I did:

$ sync && echo "mem" >/sys/power/state

(I don't know if sync is needed or helps, but I do it anyway - I *really* love my data)

unplugged everything (power, mouse, network cable, ...), got to work, plugged
everything back, power up, dmesg:

[    1.367928] Restarting tasks ... <4>ohci_hcd 0000:00:13.1: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
[    1.402715] done.
[    1.627564] tg3: eth0: Link is up at 100 Mbps, full duplex.
[    1.627568] tg3: eth0: Flow control is on for TX and on for RX.
[   10.448935] usb 3-3: USB disconnect, address 3
[   10.811866] ohci_hcd 0000:00:13.1: IRQ INTR_SF lossage
[   10.811871] ohci_hcd 0000:00:13.1: leak ed ffff810037991050 (#00) state 0 (has tds)

After this my mouse doesn't work and I'm unable to reboot/poweroff my laptop (not
even alt+sysreq+b work). It locks hard.

I have been playing with pci=assign-busses (thinking about IRQ-s here) and pci=noacpi.
No result. However, with pci=assign-busses I got this (a small variation of the message above):

[    1.743528] Restarting tasks ... <3>hub 1-0:1.0: port 5 disabled by hub (EMI?), re-enabling...
[    1.743563] usb 1-5: USB disconnect, address 3
[    1.782485] usb 1-5: new high speed USB device using ehci_hcd and address 6
[    1.785747] done.
[    1.831805] usb 1-5: configuration #1 chosen from 1 choice
[    1.834418] scsi3 : SCSI emulation for USB Mass Storage devices
[    1.834741] usb-storage: device found at 6
[    1.834785] usb-storage: waiting for device to settle before scanning
[    1.845293] ohci_hcd 0000:00:13.1: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.

I looked in 'kernel-parameters.txt" and in "x86_86/boot-options.txt" but I did not find
anything that could help (that is: usb related).

Has anyone else experienced this?

I'll try to pull 2.6.23-rc8 tonight and play with it. I've seen some ACPI related stuff
in ChangeLog. Who knows ...

Thanks,

-- 
Mihai Donțu
