Return-Path: <linux-kernel-owner+w=401wt.eu-S932746AbXIMTbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbXIMTbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 15:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbXIMTbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 15:31:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbXIMTbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 15:31:34 -0400
Message-ID: <46E98FF4.4060901@zytor.com>
Date: Thu, 13 Sep 2007 12:31:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andi Kleen <ak@suse.de>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Martin Mares <mj@ucw.cz>,
       dean gaudet <dean@arctic.org>, Robert Richter <robert.richter@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: set cfg_size for AMD Family 10h in case MMCONFIG
 is used
References: <200709121921.43950.yinghai.lu@sun.com>	 <200709131147.43446.ak@suse.de> <20070913104704.GA3878@kroah.com>	 <200709131353.15752.ak@suse.de>	 <86802c440709131001w4b758921r52a23f1732a6e9c8@mail.gmail.com>	 <46E97178.2040903@zytor.com> <86802c440709131222v6e819e4ayed27430ba4e61154@mail.gmail.com>
In-Reply-To: <86802c440709131222v6e819e4ayed27430ba4e61154@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On 9/13/07, H. Peter Anvin <hpa@zytor.com> wrote:
>> Yinghai Lu wrote:
>>> BIOS guys also said that fam 10h need mmconfig via eax accessing, may
>>> need OS do sth, so it is safe to stay with MCFG entry for SB like
>>> mcp55...
>>>
>>> but latest kernel already have that workaround to make mmconfig via eax...
>>>
>> This is actually a good point.  Since the CPU vendor managed to
>> completely fuck up the operation of MMCONFIG itself on this CPU (it's a
>> *MEMORY REFERENCE*, guys!), it is actually to be expected and prudent
>> that BIOS vendors will drop the MCFG entry.  MMCONFIG doesn't actually
>> work on this CPU for any system software which doesn't already know to
>> work around this particular piece of severe braindamage;
>> standards-complicant MMCONFIG isn't supported at all.
> 
> if other mmconfig device on x86 is sick of accessing via eax, may need
> to provide one fam10h_pci_mmcfg to be assigned to raw_pci_ops instead
> and leave pci_mmcfg to default behavior ( *MEMORY REFERENCE*).
> 

We already have the workaround.  WE do.  However, you could easily see
why a BIOS vendor would want to leave out the MCFG ACPI info, since fam
10h's mmconfig is broken.

	-hpa
