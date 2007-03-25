Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXCYLks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXCYLks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 07:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbXCYLks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 07:40:48 -0400
Received: from www17.your-server.de ([213.133.104.17]:4694 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXCYLkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 07:40:47 -0400
Message-ID: <46065FED.8030206@m3y3r.de>
Date: Sun, 25 Mar 2007 13:41:33 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>	<20070323185022.GQ752@stusta.de> <46055A3B.6050107@m3y3r.de>	<m1slbu4j0p.fsf@ebiederm.dsl.xmission.com> <46056BF3.3070707@m3y3r.de>	<m1odmi4gx5.fsf@ebiederm.dsl.xmission.com> <46058B47.60204@m3y3r.de> <m1fy7u3sas.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1fy7u3sas.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman schrieb:
>
> Thomas could you verify the patch below makes the problem go away
> for you.
>   

The patch solves the problem. I'm writing this after the third suspend
and resume cycle.
msi irq stays enabled for libata device:
cat /sys/devices/pci0000\:00/0000\:00\:1f.2/irq
218

cat /proc/interrupts
           CPU0       CPU1
  0:     274190          0   IO-APIC-edge      timer
  9:      13417          0   IO-APIC-fasteoi   acpi
 16:        166          0   IO-APIC-fasteoi   uhci_hcd:usb4
 17:      70908      88643   IO-APIC-fasteoi   wifi0
 18:       3060          0   IO-APIC-fasteoi   libata, uhci_hcd:usb3
 19:          8          0   IO-APIC-fasteoi   ohci1394, uhci_hcd:usb2
 20:      46252          0   IO-APIC-fasteoi   HDA Intel
 21:     168437          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
218:      15896          0   PCI-MSI-edge      libata
219:          1          0   PCI-MSI-edge      eth0
NMI:          0          0
LOC:      87574     123338
ERR:          0
MIS:          0


BUT...


The first suspend to disk is ok. The second suspend to disk has a
strange behaviour:
1.) write pm image
2.) the system disable the non-boot cpus again (i guess this happens in
power_down())
3.) the system doesn't power down.
4.) pressing any key and the system powers down.

The same is true for the third suspend cycle. Maybe an acpi problem?


