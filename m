Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbYGKRR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbYGKRR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 13:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbYGKRRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 13:17:41 -0400
Received: from mail-va3.bigfish.com ([216.32.180.113]:54406 "EHLO
	mail135-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754469AbYGKRRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 13:17:40 -0400
X-Greylist: delayed 1939 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2008 13:17:40 EDT
X-BigFish: VPS-15(zz1432R98dR7efV1805Mzz10d3izzz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K3UP74-01-IVV-01
Date: Fri, 11 Jul 2008 10:48:45 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: David Brigada <brigad@rpi.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, jim.cromie@gmail.com,
       linux-geode@lists.infradead.org
Subject: Re: PCI-ISA Bridge not operating
Message-ID: <20080711164845.GB28720@cosmic.amd.com>
References: <487774F9.6000001@rpi.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487774F9.6000001@rpi.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 11 Jul 2008 16:45:11.0617 (UTC) FILETIME=[7C4D2B10:01C8E375]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/08 10:58 -0400, David Brigada wrote:
> Hi,
> 
> I'm working with the MSM800XEV board from Digital-Logic.  This board 
> uses a Geode LX800 for a CPU and has the CS5536 companion board also 
> installed.  The board works with an IT8888G IC that provides a PCI/ISA 
> bridge to a PC/104 bus that is externally provided.
> 
> If I boot with FreeDOS, I can twiddle I/O ports, and the proper ISA 
> signaling comes over the PC/104 bus.  In Linux, the /IOW or /IOR line 
> goes low as expected, but the address doesn't come over the bus.  The 
> DOS that I'm running doesn't seem to have any specific drivers for the 
> chip, I'm guessing that the hardware should "just work" --- the IT8888G 
> is designed to grab I/O requests in the ISA range off the PCI bus after 
> a short delay if nothing else grabs them first.
> 
> I have a feeling that it has something to do with the CS5536 companion 
> chip, as it seems as though there is a driver for a PCI/ISA bridge on 
> that chip, though I can't get much detail from AMD's datasheet on that 
> functionality.  I do know that on the MSM800XEV, any such functionality 
> is wired to the IT8888G, not the CS5536.
> 
> There are two kernel config options related to the PCI IDs of the parts 
> of the device that handle the ISA bus, CONFIG_SCx200_ACB and 
> CONFIG_CS5535_GPIO.  I've tried disabling both, but it doesn't seem to help.
> 
> In lspci, the CS5536 PCI/ISA bridge is shown, but not the IT8888G.
> 
> Any ideas?

ISA should indeed "just work".  The only thing I'm wondering is if
the kernel is interfering (it shouldn't).  I assume that since it works
in FreeDOS that there is no possibility that something on the PCI bus
is grabbing the cycles instead.

How are you trying to access the device in Linux?  Through a kernel module
or a user application running as root?

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

