Return-Path: <linux-kernel-owner+w=401wt.eu-S1031560AbXEHTaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031560AbXEHTaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031545AbXEHT36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:29:58 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031535AbXEHT35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:29:57 -0400
Date: Tue, 8 May 2007 12:29:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kako@zhnet.hu
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 8454] New: system freeze during boot before
 ACPI initialising
Message-Id: <20070508122934.3b3b7c13.akpm@linux-foundation.org>
In-Reply-To: <200705081628.l48GSBYm015491@fire-2.osdl.org>
References: <200705081628.l48GSBYm015491@fire-2.osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(please follow up via emailed reply-to-all, not via the bugzilla web interface)

On Tue, 8 May 2007 09:28:11 -0700
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8454
> 
>            Summary: system freeze during boot before ACPI initialising
>     Kernel Version: 2.6.21
>             Status: NEW
>           Severity: blocking
>              Owner: other_other@kernel-bugs.osdl.org
>          Submitter: kako@zhnet.hu
> 
> 
> Most recent kernel where this bug did *NOT* occur:2.6.20
> Distribution:Fedora Core 6.91 and up
> Hardware Environment: Asus P4V8X-X motherboard, Celeron2400, 512M RAM IDE drives
> Software Environment: fedora core
> Problem Description: 
> This problem occured at first when I tried to install a FC7rc2 on my home-box,
> but didn't succeded. At second time, when I wanted to compile a new 2.6.21
> kernel from vanilla. Both times there was the same halts
> 
> The booting procedure halts BEFORE acpi initialisation before these lines
> -------------------
> ACPI: Processor [CPU1] (supports 16 throttling states)
> ACPI Exception (acpi_processor-0677): AE_NOT_FOUND, Processor Device is not
> present [20060707]
> -------------------
> 
> The last lines in character console mode are:
> ----------
> io scheduler deadline registered
> io scheduler cfq registered (default)
> PCI: Bypassing VIA 8237 APIC De-Assert Message
> ----------
> 
> and in framebuffer console mode:
> ----------
> vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> Console: switching to colour frame buffer device 128x48
> fb0: VESA VGA frame buffer device
> ----------
> 
> Once the system halts, the ctrl-alt-del is not working any more, only reset button.
> 
> 
> 
> Steps to reproduce: get a p4v8x-x motherboard, and try to boot.
> 
> >From that dvd-media I successfully installed many systems without problems, but
> not with this MB.
> 

This is the sort of bug where everyone sits in stunned silence because we
don't have any idea of who broke it.

It would be great if you could help us fix it, but it will take some time.

First step: please add `initcall_debug' to the kernel boot command line so
we get a better idea of where it failed.

Second step: try older kernels.  2.6.12, 2.6.16, etc.  If one of those
works OK then we know that we can find the buggy change via git-bisect.

Thanks.

