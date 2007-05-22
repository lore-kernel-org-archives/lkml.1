Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbXEVH6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbXEVH6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 03:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbXEVH6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 03:58:00 -0400
Received: from [216.16.235.2] ([216.16.235.2]:36972 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbXEVH57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 03:57:59 -0400
X-Originating-Ip: 72.143.65.211
Date: Tue, 22 May 2007 03:55:43 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Clean up the contents of module.h and moduleparam.h.
In-Reply-To: <20070522000937.33897e3f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705220352400.21478@localhost.localdomain>
References: <Pine.LNX.4.64.0705210523180.30935@localhost.localdomain>
 <20070522000937.33897e3f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, Andrew Morton wrote:

> On Mon, 21 May 2007 06:43:50 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> > Shift the contents of module.h and moduleparam.h so that generic
> > module content is exclusively in module.h, while parameter-specific
> > content is in moduleparam.h.
> >
>
> Causes weird runtime errors with
> http://userweb.kernel.org/~akpm/config-sony.txt
>
> [    1.347665] speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
> [    1.347667]  Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
> [    1.354537] Using IPI Shortcut mode
> [    1.358936] Freeing unused kernel memory: 196k freed
> [    1.401304] input: PS/2 Mouse as /class/input/input3
> [    1.405223] input: AlpsPS/2 ALPS GlidePoint as /class/input/input4
> [    1.417894] ide_core: no version magic, tainting kernel.
> [    1.421081] ide_core: module license 'unspecified' taints kernel.
> [    1.424279] ide_core: Unknown symbol bus_for_each_drv
> [    1.427463] ide_core: Unknown symbol bus_unregister
> [    1.430503] ide_core: Unknown symbol device_release_driver
> [    1.433563] ide_core: Unknown symbol add_uevent_var
> [    1.436637] ide_core: Unknown symbol device_register
> [    1.439647] ide_core: Unknown symbol device_attach
> [    1.442519] ide_core: Unknown symbol bus_register
> [    1.445282] ide_core: Unknown symbol device_unregister
> [    1.453848] ide_disk: no version magic, tainting kernel.
> [    1.456626] ide_disk: Unknown symbol __ide_error
> [    1.459374] ide_disk: Unknown symbol ide_raw_taskfile
> [    1.462103] ide_disk: Unknown symbol task_in_intr
> [    1.464745] ide_disk: Unknown symbol driver_unregister
> [    1.467390] ide_disk: Unknown symbol ide_map_sg
... snip ...
> [    1.645951] Kernel panic - not syncing: Attempted to kill init!

ok, that's just weird, since that patch should *theoretically* not
have made any difference in the long run -- any errors in the patch
should have shown up in the build.

i'll look at this closer.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
