Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab0BBCct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 21:32:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:41919 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0BBCcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 21:32:48 -0500
Message-ID: <4B679042.2010008@kernel.org>
Date: Tue, 02 Feb 2010 11:38:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: do_IRQ: 0.165 No irq handler for vector (irq -1)
References: <64bb37e1001310502p3d74bdf5ve56f63d3e8d2fd39@mail.gmail.com>
In-Reply-To: <64bb37e1001310502p3d74bdf5ve56f63d3e8d2fd39@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Feb 2010 02:32:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Torsten.

On 01/31/2010 10:02 PM, Torsten Kaiser wrote:
> I'm still trying to get the MSI support for sata_sil24, that was added
> in 2.6.33-rc1, to work. But even with -rc6 it still shows the same
> errors.
> 
> The current best guess is, that there is something fishy going on in
> the IRQ system, as the only error messages before the libata timeouts
> start are:
> 
> [   86.463814] do_IRQ: 0.165 No irq handler for vector (irq -1)
> [   86.463832] do_IRQ: 3.165 No irq handler for vector (irq -1)
> [   86.463848] do_IRQ: 1.165 No irq handler for vector (irq -1)
> [   86.463867] do_IRQ: 2.165 No irq handler for vector (irq -1)
> 
> (Thats why I added CCs for get_maintainer.pl -f arch/x86/kernel/apic/io_apic.c)
> 
> To get these errors I only boot with sata_sil24.msi=1 and then do: dd
> if=1GB-file-on-ro-mounted-xfs-fs of=/dev/null bs=1k
> 
> Writing with enabled MSI also fails with timeouts, but in this case
> there is no error from do_IRQ.

It might be that the silicon implements MSI incorrectly and ends up
sending out invalid MSI packets under certain circumstances.  The
silicon hasn't changed for quite some time now and back when it came
out MSI wasn't too popular and I don't think SIMG's proprietary
drivers use it, so it's quite possible that the feature simply is
broken.  Is there any specific reason why you want to enable MSI
support?  It's not like MSI brings any actual benefit when the
compatibility hardware is already there.

Thanks.

-- 
tejun
