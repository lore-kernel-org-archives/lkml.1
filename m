Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbXK0IZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbXK0IZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXK0IZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:25:24 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:3344 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXK0IZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:25:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hVnpCeB1rN7v/5FdvbW6gUm1Pm1jmXcRQdemgpCoxs8uUBM2v5gI+Mu7NWiUmF8Fiyi7EZHvVpkqVFUG6d1CvYXlAbcD+mN+J7Y+63JkNHAoQXpNHka56pkVbkb8nz25Dck36tpqVoYCwuC6Ic3zUxObQFyeMTyxK23FwSPCRjk=
Message-ID: <a8e1da0711270025v4c6c04b6gf8d5916670f5efa6@mail.gmail.com>
Date: Tue, 27 Nov 2007 16:25:22 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.24-rc3-mm1 - brick my Dell Latitude D820
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4210.1196147786@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	 <4210.1196147786@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 27, 2007 3:16 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Tue, 20 Nov 2007 20:45:25 PST, Andrew Morton said:
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/
>
> Finally got both time and motivation to at least start a bisect..
>
> 2.6.23-mm1 works on my D820 (x86_64 kernel, Core2 Duo T7200)
>
> 24-rc3-mm1 (plus 3 patches from hotfixes/) bricks *instantly* at boot - grub
> prints its 3 or 4 lines saying what it loaded, the screen clears, and *blam*
> dead. No serial console output, no pair of penguins on the monitor, no
> netconsole, no earlyprintk=vga output, no alt-sysrq, only thing that does
> *anything* is "hold the power button for 5 seconds".  Whatever it is, it
> happens *very* early (before we get as far as the 'Linux version 2.6.mumble'
> banner), and happens *hard*.
>
> I've bisected it down this far:
>
> git-ipwireless_cs.patch GOOD
> git-x86.patch
> git-x86-fixup.patch
> git-x86-thread_order-borkage.patch
> git-x86-thread_order-borkage-fix.patch
> git-x86-identify_cpu-fix.patch
> git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko.patch
> git-x86-memory_add_physaddr_to_nid-export-for-acpi-memhotplugko-checkpatch-fixes.patch
> git-x86-inlining-borkage.patch
> x86_64-set-cpu_index-to-nr_cpus-instead-of-0.patch
> x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch BAD
>
> Anybody got any good debugging ideas before I go through and do the final
> 3 or 4 bisects?  I suspect I'll need them once I find the offending patch
> to tell *why* said patch dies on my box - I've seen enough traffic regarding
> -rc3-mm1 dying *later* to know it's probably a subtle issue and not one
> that will be obvious once I finger a specific patch.  For example, it's
> probably not the IO-APIC panic that people are seeing, because their kernels
> live long enough to panic. ;)

Hi,
does boot_delay helps?

Regards
dave
