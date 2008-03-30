Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYC3ULJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYC3ULJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYC3ULB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:11:01 -0400
Received: from www.tglx.de ([62.245.132.106]:59281 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYC3ULB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:11:01 -0400
Date: Sun, 30 Mar 2008 22:10:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Martin Michlmayr <tbm@cyrius.com>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
In-Reply-To: <47EFD09D.3020906@s5r6.in-berlin.de>
Message-ID: <alpine.LFD.1.10.0803302201110.3219@apollo.tec.linutronix.de>
References: <20080321153952.GA26354@deprecation.cyrius.com> <47E3E2CF.5070408@s5r6.in-berlin.de> <47EF757F.9080501@s5r6.in-berlin.de> <20080330161339.GC28821@deprecation.cyrius.com> <47EFD09D.3020906@s5r6.in-berlin.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Mar 2008, Stefan Richter wrote:
> I tend to believe it is a problem to be addressed in the x86 platform support,
> not a driver problem.

Depends. It might be unfixable.

> I Cc'd some random x86 folk...  To rehash the issue:
> 
>   - Controller: Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04)
>     Board: PM965/GM965/GL960 based
>     The R5C832 is known to work with ohci1394 according to
>     http://hardware4linux.info/component/14348/ and other reports.
> 
>   - Martin also saw it happen with Linux 2.6.22.
> 
>   - firewire-ohci + firewire-core as well as ohci1394 + ieee1394
>     appear to initialize the controller on Martin's laptop just fine.
>     Among else this means that a number of register reads and writes
>     succeed.
> 
>   - Some time later, without having actually used the FireWire
>     controller, "irq 19: nobody cared"/ "Disabling IRQ #19" occurs.
>     AFAIU the code, this is apparently because firewire-ohci's or
>     ohci1394's IRQ handler was called repeatedly but got either 0 or ~0
>     when reading the chip's interrupt event register.

Can we please have a full boot log (dmesg) and the output of /proc/interrupts and "lspci -vvv"

Thanks,
	tglx
