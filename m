Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZGESjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZGESjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 14:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbZGESjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 14:39:08 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:45368 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbZGESjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 14:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SXF7kYyS5N462O4CkY5ZMU9BVQuyEoXopVT7jNm9csK8Dj6SJk8ZS5Tdg9xzS76Zur
         ABBj3SFbYeAJY+QG6rxgb3dcDt2MHrc1EE/lZ9R76ALpUL/FHryobVst34i8DenWrMMk
         j6FQLKh7uXIZi4l73mq+9uyZKgG8s8SSd7NyE=
Message-ID: <4A50F399.7000003@gmail.com>
Date: Sun, 05 Jul 2009 12:40:25 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Lars Kunert <lkunert@mpi-sb.mpg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel:Disabling IRQ #23
References: <4A50A187.9080304@mpi-sb.mpg.de>
In-Reply-To: <4A50A187.9080304@mpi-sb.mpg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2009 06:50 AM, Lars Kunert wrote:
> Hi,
> yesterday evening I lost the ssh connection to my server,
> the last message was:
>
>> Message from syslogd@guest-195 at Jul  4 23:29:08 ...
>> kernel:Disabling IRQ #23
>
> I could not renew the connection. After a reboot I found the following
> messages in /var/log/messages (attached below)
>
> The server contains 10 harddisks
> - 2 SAS drives connected as SAS drives
> - 6 SATA drives connected via SAS, and
> - 2 SATA drives connected via SATA
>
> Do these messages point to a single harddisk as the source of the problem?

Something generated spurious IRQs on that IRQ line and caused the 
interrupt to be disabled. From that point, anything on that IRQ line 
won't function properly. Likely a driver bug in either the USB or ATA 
driver.

You'll likely want to try a newer kernel..

>
>
>> distribution
> Fedora 10 server
>
>> uname -a
> Linux guest-195.mpi-sb.mpg.de 2.6.27.24-170.2.68.fc10.x86_64 #1 SMP Wed
> May 20 22:47:23 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux
>
>> cat /var/log/messages
> # at this point I lost the ssh connection to the server
> Jul  4 23:29:08 guest-195 kernel: irq 23: nobody cared (try booting with
> the "irqpoll" option)
> Jul  4 23:29:08 guest-195 kernel: Pid: 0, comm: swapper Tainted:
> P          2.6.27.21-170.2.56.fc10.x86_64 #1
> Jul  4 23:29:08 guest-195 kernel:
> Jul  4 23:29:08 guest-195 kernel: Call Trace:
> Jul  4 23:29:08 guest-195 kernel:<IRQ>   [<ffffffff81083523>]
> __report_bad_irq+0x38/0x7c
> Jul  4 23:29:08 guest-195 kernel: [<ffffffff8108376f>]
> note_interrupt+0x208/0x26d
> Jul  4 23:29:08 guest-195 kernel: [<ffffffff81083e9c>]
> handle_fasteoi_irq+0xbb/0xeb
> Jul  4 23:29:08 guest-195 kernel: [<ffffffff810130ce>] do_IRQ+0xf7/0x169
> Jul  4 23:29:08 guest-195 kernel: [<ffffffff81010963>]
> ret_from_intr+0x0/0x2e
> Jul  4 23:29:08 guest-195 kernel:<EOI>   [<ffffffff810173a9>] ?
> mwait_idle+0x3e/0x4f
> Jul  4 23:29:08 guest-195 kernel: [<ffffffff810173a0>] ?
> mwait_idle+0x35/0x4f
> Jul  4 23:29:08 guest-195 kernel: [<ffffffff8100f2a7>] ? cpu_idle+0xb2/0x10b
> Jul  4 23:29:08 guest-195 kernel: [<ffffffff8132e04b>] ?
> start_secondary+0x16e/0x173
> Jul  4 23:29:08 guest-195 kernel:
> Jul  4 23:29:08 guest-195 kernel: handlers:
> Jul  4 23:29:08 guest-195 kernel: [<ffffffff812256e5>]
> (ata_sff_interrupt+0x0/0xc2)
> Jul  4 23:29:08 guest-195 kernel: [<ffffffff8123c306>]
> (usb_hcd_irq+0x0/0xb3)
> Jul  4 23:29:08 guest-195 kernel: Disabling IRQ #23
> Jul  4 23:29:39 guest-195 kernel: ata3.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x6 frozen
> Jul  4 23:29:39 guest-195 kernel: ata3.00: cmd
> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> Jul  4 23:29:39 guest-195 kernel:         cdb 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00
> Jul  4 23:29:39 guest-195 kernel:         res
> 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> Jul  4 23:29:39 guest-195 kernel: ata3.00: status: { DRDY }
> Jul  4 23:29:39 guest-195 kernel: ata3: soft resetting link
> Jul  4 23:29:44 guest-195 kernel: ata3.01: qc timeout (cmd 0x27)
> Jul  4 23:29:44 guest-195 kernel: ata3.01: failed to read native max
> address (err_mask=0x4)
> Jul  4 23:29:44 guest-195 kernel: ata3.01: HPA support seems broken,
> skipping HPA handling
> Jul  4 23:29:44 guest-195 kernel: ata3.01: revalidation failed (errno=-5)
> Jul  4 23:29:44 guest-195 kernel: ata3: soft resetting link
> Jul  4 23:29:44 guest-195 kernel: ata3.00: configured for UDMA/100
> Jul  4 23:29:44 guest-195 kernel: ata3.01: configured for UDMA/133
> Jul  4 23:29:44 guest-195 kernel: ata3: EH complete
>
> # the log continues with the following message, repeated every 30 seconds...
>
> Jul  4 23:30:14 guest-195 kernel: ata3.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x6 frozen
> Jul  4 23:30:14 guest-195 kernel: ata3.00: cmd
> a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> Jul  4 23:30:14 guest-195 kernel:         cdb 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00
> Jul  4 23:30:14 guest-195 kernel:         res
> 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
> Jul  4 23:30:14 guest-195 kernel: ata3.00: status: { DRDY }
> Jul  4 23:30:14 guest-195 kernel: ata3: soft resetting link
> Jul  4 23:30:14 guest-195 kernel: ata3.00: configured for UDMA/100
> Jul  4 23:30:14 guest-195 kernel: ata3.01: configured for UDMA/133
> Jul  4 23:30:14 guest-195 kernel: ata3: EH complete
>
>

