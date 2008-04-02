Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbYDBE0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbYDBE0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 00:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYDBE01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 00:26:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:26963 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbYDBE0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 00:26:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pSyXssh1WdMi8mEWDHfXhz7msa/fWyOsLMflbHEoYpXnnocAKCbveqiqZBkP0bCLIguYvFO5jrN+vc+KyO/T7QMxsUM5C/5YC+36lvSGUzm2Xw8x/QnQWUmPDx4mPi2ZxiMu/hwv20DiM6kshRt9QwkfRedEFPrD3VdbxE7Rmjg=
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: Tim Ricketts <tr@earth.li>
Subject: Re: gettimeofday() jumping into the future
Date: Wed, 2 Apr 2008 07:26:11 +0300
User-Agent: KMail/1.9.7
Cc: Michael Smith <msmith@xiph.org>, LKML <linux-kernel@vger.kernel.org>,
       Andy Wingo <wingo@fluendo.com>
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com> <Pine.LNX.4.64.0803302210060.3056@falcon.foo>
In-Reply-To: <Pine.LNX.4.64.0803302210060.3056@falcon.foo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804020726.11300.mihai.dontu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008, Tim Ricketts wrote:
> On Thu, 23 Aug 2007, Michael Smith wrote:
> 
> > We've been seeing some strange behaviour on some of our applications
> > recently. I've tracked this down to gettimeofday() returning spurious
> > values occasionally.
> >
> > Specifically, gettimeofday() will suddenly, for a single call, return
> > a value about 4398 seconds (~1 hour 13 minutes) in the future. The
> > following call goes back to a normal value.
> 
> I have also seen this.

I don't know if gettimeofday() and dmesg's logging facility use the same
time source, but I'm seeing jumps into the past:

[   11.010300] ACPI: SSDT 3F6D3F27, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[    9.344283] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    9.344528] ACPI: Processor [CPU0] (supports 8 throttling states)
[    9.344989] ACPI: SSDT 3F6D4374, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
[    9.345458] ACPI: SSDT 3F6D40ED, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
[   11.013089] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])

and the future:

[   11.081332] usb 1-2: new high speed USB device using ehci_hcd and address 2
[   12.748489] usb usb4: configuration #1 chosen from 1 choice
[   12.748653] hub 4-0:1.0: USB hub found
[   12.748772] hub 4-0:1.0: 2 ports detected
[   12.849090] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 23
[   12.849338] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   12.849341] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   12.849505] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   12.849734] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000bf20
[   12.850020] usb usb5: configuration #1 chosen from 1 choice
[   12.850185] hub 5-0:1.0: USB hub found
[   12.850311] hub 5-0:1.0: 2 ports detected
[   11.194688] usb 1-2: configuration #1 chosen from 1 choice

I have a 2.6.24, 64bit, SMP kernel (Intel Core 2 Duo).

-- 
Mihai Donțu
