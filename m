Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZGENFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZGENFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 09:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZGENFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 09:05:30 -0400
Received: from hera.mpi-sb.mpg.de ([139.19.1.49]:36392 "EHLO
	hera.mpi-sb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZGENF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 09:05:29 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jul 2009 09:05:29 EDT
Message-ID: <4A50A187.9080304@mpi-sb.mpg.de>
Date: Sun, 05 Jul 2009 14:50:15 +0200
From: Lars Kunert <lkunert@mpi-sb.mpg.de>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051117)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel:Disabling IRQ #23
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
yesterday evening I lost the ssh connection to my server,
the last message was:

> Message from syslogd@guest-195 at Jul  4 23:29:08 ...
> kernel:Disabling IRQ #23

I could not renew the connection. After a reboot I found the following
messages in /var/log/messages (attached below)

The server contains 10 harddisks
- 2 SAS drives connected as SAS drives
- 6 SATA drives connected via SAS, and
- 2 SATA drives connected via SATA

Do these messages point to a single harddisk as the source of the problem?


> distribution
Fedora 10 server

> uname -a
Linux guest-195.mpi-sb.mpg.de 2.6.27.24-170.2.68.fc10.x86_64 #1 SMP Wed
May 20 22:47:23 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux

> cat /var/log/messages
# at this point I lost the ssh connection to the server
Jul  4 23:29:08 guest-195 kernel: irq 23: nobody cared (try booting with
the "irqpoll" option)
Jul  4 23:29:08 guest-195 kernel: Pid: 0, comm: swapper Tainted:
P          2.6.27.21-170.2.56.fc10.x86_64 #1
Jul  4 23:29:08 guest-195 kernel:
Jul  4 23:29:08 guest-195 kernel: Call Trace:
Jul  4 23:29:08 guest-195 kernel: <IRQ>  [<ffffffff81083523>]
__report_bad_irq+0x38/0x7c
Jul  4 23:29:08 guest-195 kernel: [<ffffffff8108376f>]
note_interrupt+0x208/0x26d
Jul  4 23:29:08 guest-195 kernel: [<ffffffff81083e9c>]
handle_fasteoi_irq+0xbb/0xeb
Jul  4 23:29:08 guest-195 kernel: [<ffffffff810130ce>] do_IRQ+0xf7/0x169
Jul  4 23:29:08 guest-195 kernel: [<ffffffff81010963>]
ret_from_intr+0x0/0x2e
Jul  4 23:29:08 guest-195 kernel: <EOI>  [<ffffffff810173a9>] ?
mwait_idle+0x3e/0x4f
Jul  4 23:29:08 guest-195 kernel: [<ffffffff810173a0>] ?
mwait_idle+0x35/0x4f
Jul  4 23:29:08 guest-195 kernel: [<ffffffff8100f2a7>] ? cpu_idle+0xb2/0x10b
Jul  4 23:29:08 guest-195 kernel: [<ffffffff8132e04b>] ?
start_secondary+0x16e/0x173
Jul  4 23:29:08 guest-195 kernel:
Jul  4 23:29:08 guest-195 kernel: handlers:
Jul  4 23:29:08 guest-195 kernel: [<ffffffff812256e5>]
(ata_sff_interrupt+0x0/0xc2)
Jul  4 23:29:08 guest-195 kernel: [<ffffffff8123c306>]
(usb_hcd_irq+0x0/0xb3)
Jul  4 23:29:08 guest-195 kernel: Disabling IRQ #23
Jul  4 23:29:39 guest-195 kernel: ata3.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x6 frozen
Jul  4 23:29:39 guest-195 kernel: ata3.00: cmd
a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Jul  4 23:29:39 guest-195 kernel:         cdb 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00
Jul  4 23:29:39 guest-195 kernel:         res
40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
Jul  4 23:29:39 guest-195 kernel: ata3.00: status: { DRDY }
Jul  4 23:29:39 guest-195 kernel: ata3: soft resetting link
Jul  4 23:29:44 guest-195 kernel: ata3.01: qc timeout (cmd 0x27)
Jul  4 23:29:44 guest-195 kernel: ata3.01: failed to read native max
address (err_mask=0x4)
Jul  4 23:29:44 guest-195 kernel: ata3.01: HPA support seems broken,
skipping HPA handling
Jul  4 23:29:44 guest-195 kernel: ata3.01: revalidation failed (errno=-5)
Jul  4 23:29:44 guest-195 kernel: ata3: soft resetting link
Jul  4 23:29:44 guest-195 kernel: ata3.00: configured for UDMA/100
Jul  4 23:29:44 guest-195 kernel: ata3.01: configured for UDMA/133
Jul  4 23:29:44 guest-195 kernel: ata3: EH complete

# the log continues with the following message, repeated every 30 seconds...

Jul  4 23:30:14 guest-195 kernel: ata3.00: exception Emask 0x0 SAct 0x0
SErr 0x0 action 0x6 frozen
Jul  4 23:30:14 guest-195 kernel: ata3.00: cmd
a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
Jul  4 23:30:14 guest-195 kernel:         cdb 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00
Jul  4 23:30:14 guest-195 kernel:         res
40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
Jul  4 23:30:14 guest-195 kernel: ata3.00: status: { DRDY }
Jul  4 23:30:14 guest-195 kernel: ata3: soft resetting link
Jul  4 23:30:14 guest-195 kernel: ata3.00: configured for UDMA/100
Jul  4 23:30:14 guest-195 kernel: ata3.01: configured for UDMA/133
Jul  4 23:30:14 guest-195 kernel: ata3: EH complete


