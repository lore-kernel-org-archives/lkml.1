Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYGQKc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYGQKc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 06:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYGQKcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 06:32:50 -0400
Received: from mail.suse.de ([195.135.220.2]:51806 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707AbYGQKct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 06:32:49 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Linux - Novell
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with nohz and highres enabled
Date: Thu, 17 Jul 2008 12:32:43 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, "linux-kernel" <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>,
       Richard <tuxbox.guru@gmail.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807171232.46542.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2008 21:03:12 Thomas Gleixner wrote:
> On Wed, 16 Jul 2008, Thomas Renninger wrote:
...
> We definitely do not add x86 quirks into the generic code.
>
> Is there really no other way to fix this problem ? Which chipset is
> involved here ? SB400/600 perhaps ?

Evgeny's (eumaster) and Uli's chipsets are both:

north-bridge: nvidia c51mv
south-bridge: nvidia mcp51m

Also both are MSI laptops:
  - MSI-M670, modell MS-1632
  - MSI S430x
(This could also be a chipset or even an MSI specific BIOS bug?
Richard could you compare with your HW, pls if still possible).

Some more info:
  - things break entering C2 or deeper
  - noapictimer workaround helps to come a bit further, but results in sever
    other errors, disk(dma error), keyboad, mouse etc., also see:
    https://bugzilla.novell.com/show_bug.cgi?id=396220#c13
  - "nohz=off" works (tested on 2.6.25.4-8-pae and 2.6.22.17-0.1-default SUSE kernels)
  - processor.max_cstate=1 works

       Thomas

lspci
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
00:05.0 VGA compatible controller: nVidia Corporation MCP51 PCI-X GeForce Go 6100 (rev a2)
00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
00:0a.3 Co-processor: nVidia Corporation MCP51 PMU (rev a3)
00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1)
00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
