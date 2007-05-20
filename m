Return-Path: <linux-kernel-owner+w=401wt.eu-S1758843AbXETWIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843AbXETWIv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 18:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756831AbXETWIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 18:08:44 -0400
Received: from paris.bmts.com ([216.183.128.227]:36752 "EHLO paris.bmts.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776AbXETWIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 18:08:43 -0400
X-Greylist: delayed 3709 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 May 2007 18:08:43 EDT
Date: Sun, 20 May 2007 17:05:06 -0400
From: Mike Houston <mikeserv@bmts.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shemminger@linux-foundation.org
Subject: Re: Linux 2.6.22-rc2
Message-Id: <20070520170506.814a38d9.mikeserv@bmts.com>
In-Reply-To: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-brucetelecom.com-MailScanner-Information: Please contact Bruce Telecom 519.368.2000 for more information
X-brucetelecom.com-MailScanner: Found to be clean
X-brucetelecom.com-MailScanner-From: mikeserv@bmts.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 22:17:14 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:


> Stephen Hemminger (7):
>       [TCP] slow start: Make comments and code logic clearer.
>       *** sky2: remove Gigabyte 88e8056 restriction ***
>       sky2: PHY register settings
>       sky2: keep track of receive alloc failures
>       sky2: MIB counter overflow handling
>       sky2: remove dual port workaround
>       sky2: memory barriers change
>

I tested this and it's still horribly broken for me with Gigabyte
88E8056 onboard LAN. Same symptom as before, it works for several
seconds and then dies.

Relevant portion of logs:

May 20 15:57:48 cramit kernel: sky2 0000:04:00.0: v1.14 addr
0xf8000000 irq 16 Yukon-EC Ultra (0xb4) rev 2
May 20 15:57:48 cramit kernel: sky2 eth0: addr 00:16:e6:da:f3:b5

May 20 15:57:48 cramit kernel: sky2 eth0: enabling interface
May 20 15:57:48 cramit kernel: sky2 eth0: ram buffer 0K
May 20 15:57:48 cramit kernel: ACPI: PCI Interrupt 0000:00:1b.0[A] ->
GSI 22 (level, low) -> IRQ 18
May 20 15:57:48 cramit kernel: PCI: Setting latency timer of device
0000:00:1b.0 to 64
May 20 15:57:50 cramit kernel: sky2 eth0: Link is up at 100 Mbps,
full duplex, flow control both

Attempt to ftp a file to another box on LAN and about 1.5
megabytes into the transfer:

May 20 16:01:43 cramit kernel: sky2 eth0: hw error interrupt status
0x8
May 20 16:01:43 cramit kernel: sky2 eth0: MAC parity error
May 20 16:01:43 cramit kernel: sky2 0000:04:00.0: error interrupt
status=0x80000000
May 20 16:01:43 cramit kernel: sky2 eth0: hw error interrupt status
0x8
May 20 16:01:43 cramit kernel: sky2 eth0: MAC parity error

Transfer stalls and that's all she wrote.

If interested in seeing kernel config:
http://www.mikeserv.org/files/config-2.6.22-rc2

Oh well, back to trusty rtl8139 based PCI card for now.

Thanks for working on this stuff,

Mike Houston
