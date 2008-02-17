Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYBQOGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYBQOGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 09:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755401AbYBQOGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 09:06:42 -0500
Received: from www.tglx.de ([62.245.132.106]:42658 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527AbYBQOGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 09:06:41 -0500
Date: Sun, 17 Feb 2008 15:06:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] x86: validate against acpi motherboard resources
In-Reply-To: <200802150127.21247.yinghai.lu@sun.com>
Message-ID: <alpine.LFD.1.00.0802171505510.7583@apollo.tec.linutronix.de>
References: <200802150127.21247.yinghai.lu@sun.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008, Yinghai Lu wrote:
> From: Robert Hancock <hancockr@shaw.ca>
> 
> This path adds validation of the MMCONFIG table against the ACPI reserved
> motherboard resources.  If the MMCONFIG table is found to be reserved in
> ACPI, we don't bother checking the E820 table.  The PCI Express firmware
> spec apparently tells BIOS developers that reservation in ACPI is required
> and E820 reservation is optional, so checking against ACPI first makes
> sense.  Many BIOSes don't reserve the MMCONFIG region in E820 even though
> it is perfectly functional, the existing check needlessly disables MMCONFIG
> in these cases.
> 
> In order to do this, MMCONFIG setup has been split into two phases.  If PCI
> configuration type 1 is not available then MMCONFIG is enabled early as
> before.  Otherwise, it is enabled later after the ACPI interpreter is
> enabled, since we need to be able to execute control methods in order to
> check the ACPI reserved resources.  Presently this is just triggered off
> the end of ACPI interpreter initialization.
> 
> There are a few other behavioral changes here:
> 
> - Validate all MMCONFIG configurations provided, not just the first one.
> 
> - Validate the entire required length of each configuration according to
>   the provided ending bus number is reserved, not just the minimum required
>   allocation.
> 
> - Validate that the area is reserved even if we read it from the chipset
>   directly and not from the MCFG table.  This catches the case where the
>   BIOS didn't set the location properly in the chipset and has mapped it
>   over other things it shouldn't have.
> 
> This also cleans up the MMCONFIG initialization functions so that they
> simply do nothing if MMCONFIG is not compiled in.
> 
> Based on an original patch by Rajesh Shah from Intel.

Applied. Thanks,

	 tglx
