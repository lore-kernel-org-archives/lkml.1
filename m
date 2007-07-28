Return-Path: <linux-kernel-owner+w=401wt.eu-S1759266AbXG1XpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266AbXG1XpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 19:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbXG1Xot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 19:44:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:54460 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107AbXG1Xos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 19:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=JyXOIB5RcBj316lxR9i+d9JMb50A2/baaeSHlDlf0f/Ei6vVPNl9y5cN/QVJoTv/aVkxD9oh8jNIQp0xlRgJ9FpMdsVkReTCPglMecPKO2Oz+HxqhpHVFXIC8RkEIRv3OxPSOr4BvmJ2rk/l/b9SN+qEUy6GPkS5U+7hA9dGhiY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: dth <dth@dth.net>
Subject: Re: ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
Date: Sun, 29 Jul 2007 01:42:53 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070727193832.GA20289@dth.net>
In-Reply-To: <20070727193832.GA20289@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707290142.53689.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday 27 July 2007, dth wrote:
> I have a via mini-itx epia 5000 motherboard as a firewall.
> It has an ide device: PQI 128MB flash DOM [1] which just plugs
> directly into the ide connector on the motherboard.
> 2.6.22-git17 works, although it gives some warning 
> hda: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
> hda: set_drive_speed_status: error=0x04 { DriveStatusError }

Should be harmless for now but we would like to fix it the long-term,
please send "hdparm --Istdout /dev/hda" output.

> Full dmesg output [2]
> 
> When i compiled any 2.6.23-rc1 kernel out so far it always froze on me.
> Yesterday i tried 2.6.23-rc1-git3 and i booted until:

No IDE changes yet after 2.6.22-git17 so something else must have broke down.

Please retry with the latest -git kernel and if the problem is still
there install git, get kernel tree and run git-bisect.

Since 2.6.22-git17 works fine the initial "good" commit would be
e51f802babc5e368c60fbfd08c6c11269c9253b0 and the initial "bad" one
f695baf2df9e0413d3521661070103711545207a (for 2.6.23-rc1).

If you need some practical examples on using git-bisect, this one

http://www.reactivated.net/weblog/archives/2006/01/using-git-bisect-to-find-buggy-kernel-patches/

is a very good one (IMO).

> VP_IDE: VIA vt8231 (rev 10) IDE UDMA100 controller on pci0000:00:11.1
>     ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:pio, hdb:pio
>     ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:pio, hdd:pio
> Marking TSC unstable due to: possible TSC halt in C2.
> Time: acpi_pm clocksource has been installed.
> hda: PQI IDE DiskOnModule, ATA DISK drive
> hda: IRQ probe failed (0xfff2)

This message would indicate broken IRQ routing, however it is no
longer present in the log for the kernel 2.6.23-rc1-git4 ([3]).

Interesting that the kernel 2.6.22-git17 (log [2]) doesn't use via82cxxx
IDE host driver while the kernel 2.6.23-rc1-git4 (log [3]) does...?

> Clocksource tsc unstable (delta = 84358771493 ns)
> 
> So i went back to 2.6.22-git17.
> This morning i saw a fresh git4 and compiled/installed that.
> This kernel actually booted! (once)
> I had a netconsole running to catch the lucky event [3]
> 
> After about 2 minutes of working however, the whole machine froze.
> No message at the console, not able to toggle numlock, no magic
> sysrq key features: solid frozen.
> After the power cycle i was not able to boot the same kernel
> ever again. It was just like a timer had run out and it wouldn't 
> work anymore. 
> 
> I know my hardware is "ancient" and the flash thing is probably
> not current. My firewall however is solar powerpowered (10 watt 

Neat. :)

> power consumption) and it would be fun if i could run the latest/
> greatest kernels on it.

With the buggy commit number obtained from git-bisect it should be
fixed quite quickly.

> Config files and hdparm info on the DOM in the same directory as
> dmesg output.
> 
> Any comments appriciated.
> 
> Danny
> 
> [1] http://www.memorydepot.com/ssd_diskonmodule.asp
> [2] http://www.dth.net/kernel/via_output_2.6.22_git17
> [3] http://www.dth.net/kernel/via_output_2.6.23-rc1-git4

Thanks,
Bart
