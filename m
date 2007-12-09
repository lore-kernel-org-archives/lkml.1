Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXLIXfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXLIXfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 18:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbXLIXew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 18:34:52 -0500
Received: from mail.mikeserv.com ([64.15.129.103]:43924 "EHLO
	hd-t3204cl.privatedns.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXLIXev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 18:34:51 -0500
X-Greylist: delayed 1012 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 18:34:50 EST
X-ClientAddr: 69.159.228.171
Date: Sun, 9 Dec 2007 18:15:15 -0500
From: Mike Houston <mike@mikeserv.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Elvis Pranskevichus <el@prans.net>, Mike Houston <mikeserv@bmts.com>,
       Adrian Bunk <bunk@stusta.de>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <ambx1@neo.rr.com>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Message-Id: <20071209181515.a62878c0.mike@mikeserv.com>
In-Reply-To: <20071209234215.748ed407@hyperion.delvare>
References: <20071204215154.7f26285e.mikeserv@bmts.com>
	<20071209000554.GF20441@stusta.de>
	<20071208212234.e00b74cd.mikeserv@bmts.com>
	<20071209105028.06ed52a6@hyperion.delvare>
	<E1J1TRp-0000ZF-6J@asgard.prans.org>
	<20071209234215.748ed407@hyperion.delvare>
Organization: Mike's Computer Service
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.10.14; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-mikeserv-MailScanner-Information: Please contact the ISP for more information
X-mikeserv-MailScanner: Found to be clean
X-MailScanner-From: mike@mikeserv.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 23:42:15 +0100
Jean Delvare <khali@linux-fr.org> wrote:
> In the meantime, I guess that booting with pnpacpi=off should fix
> your problem. But it might break something else; I'm not sure what
> the PNP ACPI driver is good for in the first place.

Ahh, thanks guys. Yes, that did indeed work around the problem. My
sensors work again, and I don't appear to have any ill effects. At
least my devices are all working, and resource assignments (irq, io)
look ok.

I'll put an append in my lilo.conf for pnpacpi=off for now.

/proc/ioports with pnpacpi=off:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0290-0297 : it87
  0290-0297 : it87
03c0-03df : vga+
0400-047f : 0000:00:1f.0
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0428-042f : ACPI GPE0_BLK
0480-04bf : 0000:00:1f.0
0500-051f : 0000:00:1f.3
  0500-051f : i801_smbus
0cf8-0cff : PCI conf1
7000-7fff : PCI Bus #02
8000-8fff : PCI Bus #04
9000-9fff : PCI Bus #03
a000-afff : PCI Bus #01
  a000-a07f : 0000:01:00.0
b000-bfff : PCI Bus #05
  b000-b0ff : 0000:05:02.0
    b000-b0ff : 8139too
c000-c01f : 0000:00:1a.1
c400-c41f : 0000:00:1d.0
c800-c81f : 0000:00:1d.1
cc00-cc1f : 0000:00:1d.2
d000-d01f : 0000:00:1a.0
d400-d407 : 0000:00:1f.2
d800-d803 : 0000:00:1f.2
dc00-dc07 : 0000:00:1f.2
e000-e003 : 0000:00:1f.2
e400-e41f : 0000:00:1f.2

Mike Houston
