Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbXFDS52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbXFDS52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759044AbXFDS5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:57:21 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:51236 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704AbXFDS5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:57:20 -0400
Date: Mon, 4 Jun 2007 20:57:19 +0200
From: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
To: Antonio Mignolli <antoniomignolli@gmail.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: lid switch hangs notebook
Message-ID: <20070604185719.GA25527@rhlx01.hs-esslingen.de>
References: <a790ea7a0703120753i232ace2bg7272fa479b821e32@mail.gmail.com> <20070315110606.741c2dc4.akpm@linux-foundation.org> <200704131553.54787.bjorn.helgaas@hp.com> <a790ea7a0706040357g799e8756ue758e95d5b460307@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a790ea7a0706040357g799e8756ue758e95d5b460307@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 04, 2007 at 12:57:21PM +0200, Antonio Mignolli wrote:
> Hi.
> The problem reported below has not been solved,
> I tried with the last stable kernel 2.6.21.3.
> 
> But it seems not to be an ACPI issue,
> I removed ACPI support from the kernel,
> and still have the problem.
> What else could be?

Have you enabled local APIC ("lapic" command line) since?
Enabling local APIC is known to cause just these issues on some
machines (HARD lockup on AC power/screen dimming/Fn keys change),
and I'm currently trying to nail what exactly the problem is.
People say it's a broken BIOS (probably one which doesn't contain support
for local APIC despite the CPU offering one), but I'm not willing to assume
this yet, it may just as well be incomplete APIC IRQ routing setup
or so).
OTOH I'm not entirely sure whether "lapic" use is fully independent
from ACPI support (which you disabled), but I think it is, so my reasoning
may be valid.

find /sys -name "*lapic*"
should reveal whether local APIC is currently active or not and thus
whether this might be responsible or not.

Andreas Mohr
