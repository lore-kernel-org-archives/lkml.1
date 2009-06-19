Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbZFSVR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbZFSVR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZFSVRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:17:49 -0400
Received: from alva.zappa.cx ([213.88.132.89]:45337 "EHLO alva.zappa.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbZFSVRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:17:48 -0400
X-Greylist: delayed 3346 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2009 17:17:48 EDT
Message-ID: <4A3BF368.9090103@zappa.cx>
Date: Fri, 19 Jun 2009 22:22:00 +0200
From: Andreas Sundstrom <sunkan@zappa.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.30 kernel panic when closing lid
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi..

My laptop has started crashing when I close the lid. This does not
happen with 2.6.29.4 which I was using before 2.6.30, I configured my
2.6.30 kernel with the 2.6.29.4 as the base and then did "make
oldconfig" and then most of the questions I got I used the default setting.

I have tried to catch the full output with a USB serial console, but
it's not able to send the full output before it dies it seems. Sometimes
it gets further than other times.

Here is one oops/panic:
[   31.295898] kernel tried to execute NX-protected page - exploit
attempt? (uid: 0)
[   31.296575] BUG: unable to handle kernel paging request at
ffff88013a891630
[   31.297233] IP: [<ffffffff814f6940>] fair_sched_class+0x0/0xc0
[   31.297594] PGD 202063 PUD b067 PMD 800000013a8001e3
[   31.298567] Oops: 0011 [#1] SMP
[   31.298569] last sysfs file:
/sys/devices/pci0000:00/0000:00:1c.1/0000:10:00.0/firmware/0000:10:00.0/loading
[   31.298572] CPU 1
[   31.298574] Modules linked in: iscsi_tcp libiscsi_tcp libiscsi
scsi_transport_iscsi sbp2 btusb sdhci_pci sdhci bluetooth psmouse
ricoh_mmc ohci1394 mmc_core ieee1394 pl2303
[   31.298585] Pid: 0, comm: swapper Not tainted 2.6.30 #9 HP Compaq
6910p (GB949ET#AK8)
[   31.298587] RIP: c2c0:[<ffffffff814f6940>]  [<ffffffff814f6940>]
fair_sched_class+0x0/0xc0
[   31.298592] RSP: ffffffff8102e891:ffff88013b9a1b20  EFLAGS:
ffff88013b8c4a80
[   31.298594] RAX: ffffffff81030f1a RBX: ffffffff810b047b RCX:
ffffffff8123d135
[   31.298597] RDX: ffff88013b976580 RSI: 0000000000000001 RDI:
ffff88013b8c4a80
[   31.298599] RBP: ffffffff810303a2 R08: ffff88013b9a1ae0 R09:
ffff88002804c2c0
[   31.298601] R10: ffff88013b9765b8 R11: ffff88002804c328 R12:
ffff88013b9a1ab0
[   31.298603] R13: 0000000000000001 R14: 0000000000000001 R15:
ffff88002804c328
[   31.298606] FS:  000000[   31.319076] bad: scheduling from the idle
thread!
[   31.319[   31.320577] Call Trace:
[   31.321325] bad: scheduling from the idle thread!
[   31.322044] Pid: 0, comm: swapper Tainted: [   31.322805] Call Trace:
[   31.323568] bad: scheduling from the idle thread!
[   31.324318] Pid: 0, comm: swapper Tainted: G      D    2.6.30 #9
[   31.325028] Call Trace:

I did a few runs and the full output from that is here:
http://pastebin.com/fe18c31c

fair_sched_class seems to be mentioned every time from what I've seen.

I also tried removing "button" support from ACPI and that seems to
eliminate the problem, so I have a workaround.
Compiling "button" as a module does not seem to eliminate the problem
though even with the module blacklisted (and not loaded then of course).

This is on a HP Compaq 6910p as you might have seen in the oops/panic
output.
I don't know how to proceed on troubleshooting/debugging this.

Let me know if there is anything I can do to help find the issue.

P.S. I'm currently not subscribed so please feel free to CC me on any
posts regarding
this.

/Andreas Sundstrom
