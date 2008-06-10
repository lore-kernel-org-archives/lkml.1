Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYFJXO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYFJXO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYFJXOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:14:48 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:43760 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751309AbYFJXOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:14:48 -0400
Message-ID: <484F0AF7.6060008@lwfinger.net>
Date: Tue, 10 Jun 2008 18:15:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>, Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>]
 :b43:b43_dma_mapping_error+0x16/0x155
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com>	 <200806101637.11473.mb@bu3sch.de>	 <19f34abd0806100742v176f50e8se463d2e70df44332@mail.gmail.com>	 <200806101650.27180.mb@bu3sch.de> <a44ae5cd0806101509x5e2d5c19y10101ea0e72f8cba@mail.gmail.com>
In-Reply-To: <a44ae5cd0806101509x5e2d5c19y10101ea0e72f8cba@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> I got a slightly different BUG with this patch applied:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<f89e3d41>] :b43:b43_dma_mapping_error+0x16/0x97
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:08.0/0000:01:06.0/ssb0:0/firmware/ssb0:0/loading
> Modules linked in: sbs sbshc wmi battery iptable_filter ip_tables
> x_tables ac sbp2 rtc arc4 ecb crypto_blkcipher cryptomgr crypto_algapi
> b43 mac80211 cfg80211 led_class snd_intel8x0 snd_ac97_codec ac97_bus
> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
> snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore
> snd_page_alloc i2c_nforce2 i2c_core button ohci1394 3c59x ieee1394
> forcedeth ehci_hcd ohci_hcd usbcore thermal processor fan thermal_sys

Miles,

If you have time, please cd to the kernel root directory and run the 
command 'objdump -d -l drivers/net/wireless/b43/dma.o > dmadump'. You 
may have to install the objdump package. In the file dmadump, find the 
line that contains b43_dma_mapping_error. On my system it is 
0000000000000085 <b43_dma_mapping_error>: Note, I use x86_64 and yours 
will likely be different.

Note the address (0x85 in my case), add the offset (0x16) and find the 
line with the error. You can use KCalc in hexadecimal mode if you are 
not comfortable with doing addition in base 16. Please report the 
source line and instruction that failed.

Larry

