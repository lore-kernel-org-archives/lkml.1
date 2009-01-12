Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZALG6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZALG6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 01:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZALG5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 01:57:17 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34072 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZALG5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:57:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TLYWvj67/gbT55vUYFKJbkCKl2snIO4Qy4kvrVhmwP77JZzs4mK1EXHvw/zUWPl+xx
         oDHmwKSz6iWz7uDb3I9ToJD2U5fePGbrg+oXMo5E26rLR4mdIYWTTgpypGtgzYaIlbG7
         64Y1/jyGipz2npx8Po8XBgeZjB21fgWwYOA38=
Message-ID: <64bb37e0901112257q51b20f8dhf9d80db7d3960d1a@mail.gmail.com>
Date: Mon, 12 Jan 2009 07:57:10 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: Linux 2.6.29-rc1 MAJOR advisory
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200901112150.16108.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.2.00.0901101551420.6528@localhost.localdomain>
	 <200901111510.30064.gene.heskett@gmail.com>
	 <64bb37e0901111306sf1efbachbeb5ad523fa17e26@mail.gmail.com>
	 <200901112150.16108.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 3:50 AM, Gene Heskett <gene.heskett@gmail.com> wrote:
> On Sunday 11 January 2009, Torsten Kaiser wrote:
>>On Sun, Jan 11, 2009 at 9:10 PM, Gene Heskett <gene.heskett@gmail.com> wrote:
>>> I don't believe it is.  MAJOR problem. I have an ASUS M2N-SLI Deluxe
>>> motherboard I paid about $275 for in late Sept 2008, and one attempt to
>>> boot the 2.6.29-rc1 I had built destroyed the MCP55 eth0 port, no power on
>>> the port at all now, and I've rebooted to 2.6.28, still no eth0, so I have
>>> now enabled in the bios and am using the 2nd & last eth1 port on this
>>> mobo.
>>
>>I have also an ASUS MCP55 board, a KFN5-D.
>>
>>To save the crash I reported in the "[git pull] x86 fixes" thread, I
>>had to boot the patch -rc1 a second time.
>>After saving the Oops on my second pc I rebooted my test system (the
>>one with the MCP55) into 2.6.28 and the boot process hung as it wanted
>>to mount its NFS filesystems. Trying to connect from the second system
>>failed, not even a ping reply.
>>But: Just removing the ethernet cable and immediately reconnecting it
>>seemed to have kicked my MCP55 ethernet port back in working order.
>>
> I unplugged it and plugged it back in a couple of times.

I just wanted to report my observations as that might help somebody to
debug this problem.
I assumed that you already tried unplugging the ethernet cable and
would only suggest a complete powerdown instead of only rebooting, but
as you wrote later in your mail, you already tried that. :-(

> Absolutely NO led
> activity in the connector was observed, but since this board has 2 ethernet
> ports, the other port lit up like the 4th of July when I stuck the cable
> into it.  So I rebooted, and enabled that port in the bios, then booted 2.6.28,
> copied /etc/sysconfig/network-scripts/ifcfg-eth0 to ifcfg-eth1, edited it to
> call itself eth1 without even changing the mac address, did a
> 'service network restart' which reported a failure downing eth0, then another
> upping it, and success upping eth1.  Pinged yahoo, works.
>
> I will call my friend at the shop where I bought all this and see if he can
> arrange a preship of another board since ASUS has a years warranty.  But to
> me, its pretty fishy that it was working normally when I shut down 2.6.28,
> failed on the boot to 2.6.29-rc1, twice, and was still dead when 2.6.28
> was rebooted.  That points an awfully straight and strong finger at 2.6.29-rc1.
>
>>No fishy things in the syslog...
>
> As you can see in the dmesg I attached, I had problems from the gitgo.
> But just for grins, I'll check messages too, for the first boot, hang on a sec.
>
> First was the usual your bios is crap, fixing it notice, then:
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI: RSDP 000F7D20, 0024 (r2 Nvidia)
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI: XSDT DFEE3100, 004C (r1 Nvidia ASUSACPI 42302E31 AWRD
> 0)
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI: FACP DFEEADC0, 00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD
> 0)
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in
> Pm1aEventBlock: 32/8 [20081204]
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in
> Pm1aControlBlock: 16/8 [20081204]
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in
> PmTimerBlock: 32/8 [20081204]
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe0Block:
> 64/8 [20081204]
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe1Block:
> 128/8 [20081204]
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aEventBlock: 8,
> using default 32 [20081204]
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0412): Invalid length for Pm1aControlBlock:
> 8, using default 16 [20081204]
> Jan 11 14:15:13 coyote kernel: [    0.000000] ACPI Warning (tbfadt-0412): Invalid length for PmTimerBlock: 8,
> using default 32 [20081204]
> Jan 11 14:15:13 coyote kernel: [    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN
> (4)
>
> No idea what that means.

Something is wrojng with your ACPI tables.
That might have several causes:
a) a new check in 2.6.29-rc1 that now detects an error that was always there
b) the cause for the dead eth0 is a corruption in your bios

For me I see this with 2.6.29-rc1:
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match
PM1_EVT_LEN (4)

2.6.28 does not complain about that.

It would probably be good to compare the boot messages from an older
kernel when eth0 was still working with the boot messages from the
same kernel now that the port is dead.
Any differences might give a better clue than all the errors from 2.6.29...

> Then:
[snip]
> Jan 11 14:15:13 coyote kernel: [   18.231257] Oops: 0002 [#1] PREEMPT SMP
[snip]
> Jan 11 14:15:13 coyote kernel: [   18.232006] Pid: 1724, comm: modprobe Tainted: G        W  (2.6.29-rc1 #1)
[snip]
> Now the above claims I am 'tainted' but I am not.

The taint is because this is the second problem that the kernel
encounterd, the first one from the log you attached to your first post
was:
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:398
generic_get_mtrr+0x11c/0x130()
[    0.000000] Hardware name: System Product Name
[    0.000000] mtrr: your BIOS has set up an incorrect mask, fixing it up.
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.29-rc1 #1
[    0.000000] Call Trace:
[    0.000000]  [<c0428939>] warn_slowpath+0x99/0xc0
[    0.000000]  [<c043f561>] up+0x11/0x40
[    0.000000]  [<c042906d>] release_console_sem+0x18d/0x1c0
[    0.000000]  [<c0600020>] iret_exc+0x1dc/0x882
[    0.000000]  [<c06ffac1>] dmi_string_nosave+0x51/0x70
[    0.000000]  [<c042962b>] printk+0x1b/0x20
[    0.000000]  [<c041ba8c>] pat_init+0x7c/0xa0
[    0.000000]  [<c040fd5c>] generic_get_mtrr+0x11c/0x130
[    0.000000]  [<c06ea68b>] mtrr_trim_uncached_memory+0x7b/0x360
[    0.000000]  [<c06eaa41>] mtrr_bp_init+0xd1/0x700
[    0.000000]  [<c042962b>] printk+0x1b/0x20
[    0.000000]  [<c06e7125>] e820_end_pfn+0xc5/0xf0
[    0.000000]  [<c06e5689>] setup_arch+0x409/0x980
[    0.000000]  [<c06e864b>] reserve_early_overlap_ok+0x4b/0x60
[    0.000000]  [<c06e1a0a>] start_kernel+0x6a/0x2e0
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---

The W-Taint is there to notify that there already was some (other) problem.

> Then, just about 10 lines later:
> Jan 11 14:20:57 coyote kernel: [   22.214383] eth0: no link during initialization.
> Jan 11 14:20:57 coyote kernel: [   23.784997] eth0: link up.
>
> But it wasn't. ifconfig said it was, but no pings worked.  So I fixed the
> ifcfg-eth1 script to run, rebooted, enabling the other port in the bios as I
> did so, and here I am.  The one thing I haven't done is a full powerdown,
> which is next.
>
> And I have now done that full powerdown reset, but the eth0 port is still dark
> and powerless.
>
> And this is all that showed up in dmesg's output when I moved the cable back
> for a few seconds:
>
> [  135.940984] eth1: link down.
> [  145.266298] eth1: link up.
>
> No note that a cable had been plugged into eth0. But it was.

Any other messages about eth0 in the syslog?
It would probably be most helpful, if you could compare any messages
about eth0/ the MCP55 from a known good boot with the current
output...

> This could be a 'co-inky dance', but my almost 60 years in electronics
> troubleshooting says there is a connection.
>
> I sure won't reboot to 2.6.29-rc1 again until I have a replacement
> motherboard sitting next to me, I don't want to wreck the last port
> cuz I have no slots left to stick a nic in this one.

Torsten
