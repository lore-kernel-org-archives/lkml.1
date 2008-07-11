Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbYGKQZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbYGKQZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 12:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYGKQZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 12:25:46 -0400
Received: from smtp5.server.rpi.edu ([128.113.2.225]:51649 "EHLO
	smtp5.server.rpi.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbYGKQZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 12:25:45 -0400
X-Greylist: delayed 5248 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2008 12:25:45 EDT
Message-ID: <487774F9.6000001@rpi.edu>
Date: Fri, 11 Jul 2008 10:58:01 -0400
From: David Brigada <brigad@rpi.edu>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: jim.cromie@gmail.com, linux-geode@lists.infradead.org
Subject: PCI-ISA Bridge not operating
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-RPI-SA-Score: undef - spam scanning disabled
X-CanItPRO-Stream: default
X-Canit-Stats-ID: Bayes signature not available
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working with the MSM800XEV board from Digital-Logic.  This board 
uses a Geode LX800 for a CPU and has the CS5536 companion board also 
installed.  The board works with an IT8888G IC that provides a PCI/ISA 
bridge to a PC/104 bus that is externally provided.

If I boot with FreeDOS, I can twiddle I/O ports, and the proper ISA 
signaling comes over the PC/104 bus.  In Linux, the /IOW or /IOR line 
goes low as expected, but the address doesn't come over the bus.  The 
DOS that I'm running doesn't seem to have any specific drivers for the 
chip, I'm guessing that the hardware should "just work" --- the IT8888G 
is designed to grab I/O requests in the ISA range off the PCI bus after 
a short delay if nothing else grabs them first.

I have a feeling that it has something to do with the CS5536 companion 
chip, as it seems as though there is a driver for a PCI/ISA bridge on 
that chip, though I can't get much detail from AMD's datasheet on that 
functionality.  I do know that on the MSM800XEV, any such functionality 
is wired to the IT8888G, not the CS5536.

There are two kernel config options related to the PCI IDs of the parts 
of the device that handle the ISA bus, CONFIG_SCx200_ACB and 
CONFIG_CS5535_GPIO.  I've tried disabling both, but it doesn't seem to help.

In lspci, the CS5536 PCI/ISA bridge is shown, but not the IT8888G.

Any ideas?

Thanks,
David Brigada
