Return-Path: <linux-kernel-owner+w=401wt.eu-S1763752AbXGJSGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763752AbXGJSGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbXGJSGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:06:38 -0400
Received: from mail-1.epublica.de ([213.238.59.6]:60318 "EHLO
	mail-1.epublica.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759292AbXGJSGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:06:37 -0400
X-Greylist: delayed 1937 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2007 14:06:37 EDT
Message-ID: <4693C318.8040105@hanno.de>
Date: Tue, 10 Jul 2007 19:34:16 +0200
From: Hanno Zulla <abos@hanno.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Nova-T, cx88-dvb & "cx88_wakeup: 2 buffers handled (should be 1)"
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ please cc me with replies. ]

I have asked this upstream at linux-dvb [1] and to the Ubuntu kernel's
bugtracker [2], but no help so far. Googling around, one can find other
reports about this, but no solution, either.


Using a Nova-T dvb card, I get the following in /var/log/messages...

22:09:54 kernel: cx88_wakeup: 2 buffers handled (should be 1)
22:09:57 kernel: cx88_wakeup: 2 buffers handled (should be 1)
22:10:06 kernel: cx88_wakeup: 2 buffers handled (should be 1)
22:10:09 kernel: cx88_wakeup: 2 buffers handled (should be 1)
22:10:12 kernel: cx88_wakeup: 2 buffers handled (should be 1)
22:10:15 kernel: cx88_wakeup: 2 buffers handled (should be 1)

...every few seconds while watching TV with xine or other dvb-apps. The
event results in a visible interruption of the video stream.


Looking on the net for solutions, I tried these:

- changing pci latency in the bios settings

- putting the card into a different pci slot

- using "pci=routeirq" or "pci=noacpi" kernel boot parameters

NONE of these solved the problem.

Please see [2] for more info.


The problem appears with three different recent Linux distribution
kernels: Ubuntu 2.6.22-7-generic, Ubuntu 2.6.20-15-generic, Suse
2.6.18.2-34-default.

The problem is not hardware-specific, it appears with an Intel CPU and
Intel chipset as well as with an AMD CPU and a VIA chipset.

The problem appears to be shared irq resources [3]. However, my
mainboard doesn't allow to choose specific irqs for pci slots and
anyway, shared irqs shouldn't break this dvb card, in the first place.


What else can I try?


Thanks for any help,

Hanno


[1]
http://www.linuxtv.org/pipermail/linux-dvb/2007-May/018232.html
http://www.linuxtv.org/pipermail/linux-dvb/2007-July/018881.html

[2]
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/119115

[3]
http://launchpadlibrarian.net/8036103/lspci-vvnn.log
http://launchpadlibrarian.net/8283449/lspci-vv.log
