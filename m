Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbXKMMf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbXKMMf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbXKMMfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:35:17 -0500
Received: from fw3.q-free.com ([62.92.116.8]:2806 "HELO fw3.q-free.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752603AbXKMMfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:35:16 -0500
X-Greylist: delayed 981 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 07:35:15 EST
From: Frank Aune <Frank.Aune@broadpark.no>
To: linux-kernel@vger.kernel.org
Subject: No UEVENT generated when removing PCMCIA hardware
Date: Tue, 13 Nov 2007 13:18:31 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131318.32091.Frank.Aune@broadpark.no>
X-OriginalArrivalTime: 13 Nov 2007 12:18:32.0291 (UTC) FILETIME=[4E680330:01C825EF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When removing a PCMCIA pc card from the kernel, no kernel UEVENT is generated 
for UDEV to process:

<code>
$ sudo udevmonitor
udevmonitor will print the received events for:
UDEV the event which udev sends out after rule processing
UEVENT the kernel uevent

UEVENT[1194953228.779786] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953228.959397] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953230.598672] 
remove   /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UEVENT[1194953233.415975] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953233.508582] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953234.972943] 
remove   /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UEVENT[1194953237.759973] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953237.867551] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953239.028915] 
remove   /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UEVENT[1194953241.624024] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953241.753107] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UEVENT[1194953243.323935] 
remove   /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953243.326690] 
remove   /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UEVENT[1194953246.291972] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953246.443285] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953247.602263] 
remove   /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UEVENT[1194953249.891969] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953250.035555] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953251.129067] 
remove   /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UEVENT[1194953253.427974] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953253.579552] 
add      /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
UDEV  [1194953254.633208] 
remove   /devices/pci0000:00/0000:00:1e.0/0000:02:00.0/0.0 (pcmcia)
</code>

Interestingly as you can see from the excerpt above, one time an UEVENT was in 
fact generated when the PCMCIA card was removed. But usually no UEVENT is 
reported when removing the PCMCIA pc card.

I've verified this behavior on both:
- Kubuntu 7.03 Feisty Fawn
- Kubuntu 7.10 Gutsy Gibon

using different PCMCIA pc cards, and they all behave the same way. On Kubuntu 
6.10 OTOH, I get the desired behavior:

<code>
udevmonitor prints the received event from the kernel [UEVENT]
and the event which udev sends out after rule processing [UDEV]

UEVENT[1194955803.201066] 
add@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UDEV  [1194955803.235275] 
add@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UEVENT[1194955804.801254] 
remove@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UDEV  [1194955804.802018] 
remove@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UEVENT[1194955807.657327] 
add@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UDEV  [1194955807.691431] 
add@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UEVENT[1194955808.583364] 
remove@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UDEV  [1194955808.584129] 
remove@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UEVENT[1194955811.209548] 
add@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UDEV  [1194955811.244305] 
add@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UEVENT[1194955811.764918] 
remove@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
UDEV  [1194955811.765911] 
remove@/devices/pci0000:00/0000:00:1e.0/0000:05:04.1/1.0
</code>

Is this a bug, or is it a design decision to not report UEVENTS when removing 
PCMCIA pccards? If the latter, why did it happen once in the first excerpt?

Best regards,
Frank Aune

Please CC me if replying.
