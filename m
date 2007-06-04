Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbXFDU0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbXFDU0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXFDU0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:26:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:60071 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbXFDU0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:26:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VVGf7Y2RAwKefN+jVWylLAR89soczQCTxLa/6Zl8wiNNaD+FRN1P+bl6jAZv8A1KvBOy146hvAehCBT8N/cIStjzJMvPqldHWamgg8MND5TKfcT46f9BINR3e4XkDhpktxaNkYcJ6znxLySoC2VVO8BQH+Fz77WwWPnth/KIhKA=
Message-ID: <a790ea7a0706041326h7bf1bc77kf4db7ac48b8ab209@mail.gmail.com>
Date: Mon, 4 Jun 2007 22:26:05 +0200
From: "Antonio Mignolli" <antoniomignolli@gmail.com>
To: "Andreas Mohr" <andi@rhlx01.hs-esslingen.de>
Subject: Re: lid switch hangs notebook
Cc: linux-kernel@vger.kernel.org, "Bjorn Helgaas" <bjorn.helgaas@hp.com>
In-Reply-To: <20070604185719.GA25527@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a790ea7a0703120753i232ace2bg7272fa479b821e32@mail.gmail.com>
	 <20070315110606.741c2dc4.akpm@linux-foundation.org>
	 <200704131553.54787.bjorn.helgaas@hp.com>
	 <a790ea7a0706040357g799e8756ue758e95d5b460307@mail.gmail.com>
	 <20070604185719.GA25527@rhlx01.hs-esslingen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Interesting...
The lid problem was solved, but many others arised.
I don't remember what lapic is, I didn't put the lapic on kernel
command line, but it seemed to be active by default:
# find /sys -name "*lapic*"
/sys/devices/system/lapic_nmi
/sys/devices/system/lapic_nmi/lapic_nmi0
/sys/devices/system/lapic
/sys/devices/system/lapic/lapic0

I put a "nolapic" in cmdline, and this time no hangs,
even WITH acpi support in kernel, pressing the button
a dozen of times (without nolapic it hanged after a couple of times).

BUT:
- Module b44 (broadcom network adapter) fails to load, giving,
    with debug actived:
    b44 0000:01:0e.0: Cannot find proper PCI device base address, aborting.
- Alsa does not work
 ... No time for analyze other issues.

Thanks for helping,
I'll take a look to lapic.

On 6/4/07, Andreas Mohr <andi@rhlx01.hs-esslingen.de> wrote:
> Hi,
>
> On Mon, Jun 04, 2007 at 12:57:21PM +0200, Antonio Mignolli wrote:
> > Hi.
> > The problem reported below has not been solved,
> > I tried with the last stable kernel 2.6.21.3.
> >
> > But it seems not to be an ACPI issue,
> > I removed ACPI support from the kernel,
> > and still have the problem.
> > What else could be?
>
> Have you enabled local APIC ("lapic" command line) since?
> Enabling local APIC is known to cause just these issues on some
> machines (HARD lockup on AC power/screen dimming/Fn keys change),
> and I'm currently trying to nail what exactly the problem is.
> People say it's a broken BIOS (probably one which doesn't contain support
> for local APIC despite the CPU offering one), but I'm not willing to assume
> this yet, it may just as well be incomplete APIC IRQ routing setup
> or so).
> OTOH I'm not entirely sure whether "lapic" use is fully independent
> from ACPI support (which you disabled), but I think it is, so my reasoning
> may be valid.
>
> find /sys -name "*lapic*"
> should reveal whether local APIC is currently active or not and thus
> whether this might be responsible or not.
>
> Andreas Mohr
>
