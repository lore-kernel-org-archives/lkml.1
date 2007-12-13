Return-Path: <linux-kernel-owner+w=401wt.eu-S1762121AbXLMPDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762121AbXLMPDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbXLMPDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:03:34 -0500
Received: from host.infinivid.com ([64.119.179.76]:54944 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbXLMPDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:03:33 -0500
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 10:03:33 EST
Subject: PCI resource unavailable on mips
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 13 Dec 2007 09:56:46 -0500
Message-Id: <1197557806.3370.7.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've done a bit of linux driver development on x86 in the past.
Currently I am working on my first ever linux driver for a mips box. I
started by testing the device in an x86 box and got it reasonable stable
and am now testing it in the mips box. There appears to be a major
problem, one unlike I have ever seen before.

My PCI device has three BARS. This can be confirmed by the Technical
documentation and the x86 code. When the pci device is first probed, I
run a loop to printk out the bar information, this is just as a sanity
check. Here is the output on the x86:

Bar0:PHYS=e0000000 LEN=04000000
Bar1:PHYS=efa00000 LEN=00200000
Bar2:PHYS=e8000000 LEN=04000000

but here is the output on the mips:
Bar0:PHYS=20000000 LEN=04000000
Bar1:PHYS=24000000 LEN=00200000
Bar2:PHYS=00000000 LEN=00000000

notice, BAR2 has no valid information on the mips. I tried to run
"pci_enable_device" before printing this information, as suggested by
LDD but it did not help.

Has anyone seen a problem like this before and any idea how I can get
BAR2 a proper address?

If I examine the config space directly there is an address in BAR2's
register, however it isn't in the 0x20000000 range like the other two,
instead it is 0x1c000000. Also if I do a ``cat /proc/iomem'' I correctly
see BAR0 and BAR1 in the output, but not BAR2.

Thanks for any help,
Jon

