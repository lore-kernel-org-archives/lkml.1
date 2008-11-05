Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYKEAcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYKEAcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYKEAcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:32:04 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:38389 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYKEAcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:32:02 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=xqJ5GrSIoz4x4Za2X_sA:9 a=lVxhGVJpOiGXwdRFrgMA:7 a=u4SgTTRL-EdvX1cJK9OonjkoyQcA:4
Message-ID: <4910E97E.4090604@shaw.ca>
Date: Tue, 04 Nov 2008 18:31:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: dmesg excerpt, 2.6.28-rc3
References: <fa.UVByY+pUhR/zVwHzSt3LRHOLndY@ifi.uio.no>
In-Reply-To: <fa.UVByY+pUhR/zVwHzSt3LRHOLndY@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Greetings all;
> 
> I have been seeing an ACPI message saying it expected something it didn't get 
> while booting, but that message never makes it to any log. I turned on some 
> verbosity with the rc3 config, and now see this early in dmesg:
> 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404 
> generic_get_mtrr+0x11c/0x130()
> [    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.28-rc3 #1
> [    0.000000] Call Trace:
> [    0.000000]  [<c04282e6>] warn_slowpath+0x76/0x90
> [    0.000000]  [<c0511657>] vsnprintf+0x2e7/0x680
> [    0.000000]  [<c042903b>] printk+0x1b/0x20
> [    0.000000]  [<c041b6dc>] pat_init+0x7c/0xa0
> [    0.000000]  [<c040fe0c>] post_set+0x1c/0x50
> [    0.000000]  [<c0428a8d>] release_console_sem+0x18d/0x1c0
> [    0.000000]  [<c041045c>] generic_get_mtrr+0x11c/0x130
> [    0.000000]  [<c0728ffa>] mtrr_trim_uncached_memory+0x7a/0x330
> [    0.000000]  [<c042903b>] printk+0x1b/0x20
> [    0.000000]  [<c0725d45>] e820_end_pfn+0xc5/0xf0
> [    0.000000]  [<c0724120>] setup_arch+0x420/0xb60
> [    0.000000]  [<c072726b>] reserve_early_overlap_ok+0x4b/0x60
> [    0.000000]  [<c071d9c8>] start_kernel+0x58/0x2e0
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> This is the latest, non-beta bios (1502, as of about a month ago anyway) for 
> this ASUS M2N-SLI deluxe mother board, with a slow 4 core phenom in the 
> socket.  Is anyone fam enough with the ASUS bios to suggest a fix?

Not likely that anyone other than Asus can do much with it.. you could 
try the beta BIOS and see if it's fixed there. (After the board's been 
out for a while, generally Asus only releases beta versions and not 
"final" versions.)

> 
> This may have something to do with an extremely slow boot time, with a good 30 
> seconds wasted between the last bios message spit out, the time when grub 
> should be loading.  Each message from grub, until it finally presents the 
> boot choice menu, takes 7 to 15 seconds, and once its presented the menu, 
> then booting resumes at a normal speed.
> 
> I should make a movie so folks see what I'm talking about I guess.
> 
> Ahh, I found the ACPI message too!
> 
> [    0.625198] fan PNP0C0B:00: registered as cooling_device0
> [    0.625202] ACPI: Fan [FAN] (on)
> [    0.625608] processor ACPI0007:00: registered as cooling_device1
> [    0.625654] processor ACPI0007:01: registered as cooling_device2
> [    0.625703] processor ACPI0007:02: registered as cooling_device3
> [    0.625754] processor ACPI0007:03: registered as cooling_device4
> [    0.626200] ACPI Warning (nspredef-0858): \_TZ_.THRM._PSL: Return Package 
> type mismatch at index 0 - found [NULL Object Descriptor], expected Reference 
> [20080926]
> [    0.626206] ACPI: Expecting a [Reference] package element, found type 0
> 
> What if anything can I do about these?

Same deal as the MTRR problem, most likely..
