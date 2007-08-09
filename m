Return-Path: <linux-kernel-owner+w=401wt.eu-S938050AbXHIHXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938050AbXHIHXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762289AbXHIHXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:23:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:57645 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760963AbXHIHXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:23:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nup39H58LTsXZyagjL/X/9T4HV+PV0MZFuSIxUNpOzIDw7iUw2MxsdxRAf/P34Px5DTth1g80mzkhoc2E8vZdXkECgBcghOakEc/g8NlLlQ9VNFKEDbHYgGI6/OKZFOBDtp9kIiz1NieDcVcAV7gVfU+8sn3YTu4SI4buGw8d1U=
Message-ID: <dc5675e90708090023o6dc20e70rdceb1cfa6ca5164c@mail.gmail.com>
Date: Thu, 9 Aug 2007 03:23:02 -0400
From: "Richard Harman" <richard.harman@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: IO-APIC/ACPI/SMP problems on HP Pavilion DV6000 series laptop (2.6.22.1, from Fedora 7)
Cc: richard.harman@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(I'm not subscribed to lkml, please CC me in your replies)

Anyone have an HP Pavilion DV6000 series laptop (mine's a dv6408nr to
be exact) that successfully brings up both cores of its AMD Turion 64
X2 TL-56 and is stable?  I get the feeling that there's a problem with
the APIC, or ACPI or even both.

Generally, the system locks up just before it should print "Brought up 2 CPUs".

The Windows vista that came with it somehow brings the system up using
the APIC, and msinfo32 shows it "seeing" >150 IRQs numbered as high as
190 (and two that are such a high number it can only be wrong), with
only 16 IRQs really in use.

Booting with 'noapic' results in the system bringing up both cores,
but IRQ7 getting disabled later with "nobody cares".  Using irqpoll
causes the system to be excessively slow.

I've run through the various kernel command line params in
Documentation/{kernel-paramaters.txt,x86_64/boot_options.txt} and not
any of the pci/apic/acpi options individually seem to bring the system
into full working order.  The APIC timer related options result in the
SATA controller going nuts, some result in 'APIC error on CPU0:
40(40)' to be printed on every key-down/key-up event.  Most result in
the system locking up hard between 40 seconds to 2 minutes after
booting if the system boots at all.  The ERR: line in /proc/interrupts
is >1, many times 80 or higher and grows over time.

Booting maxcpus=1 results in the APIC being happy (/proc/interrupts
has all the IRQs managed by the APIC), and there aren't more than one
ERR: interrupts.


Any thoughts?

Thanks in advance,
Richard
