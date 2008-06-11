Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbYFKB56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbYFKB56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 21:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754963AbYFKB5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 21:57:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:19340 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYFKB5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 21:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WciovclywMyeRfGPqTmMWod+nUdm35yV5+uepPU7S3gvr3hZ3WaCj+LHIrnZge4VGz
         ffyEIOZdbpzYwxQ4KVNH0asNbzqnwO1IqS5qreAxe0zc3J5AzA+p1AiLsUqX+pjTaEZq
         9rJtNa99w2ngdc/SSAq252Fji7i2Ym07ndJOw=
Message-ID: <a44ae5cd0806101857q54074c83w2eb470682b58a6cc@mail.gmail.com>
Date: Tue, 10 Jun 2008 21:57:46 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: BUG: NULL pointer dereference at 00000000 -- IP: [<f8e783d5>] :b43:b43_dma_mapping_error+0x16/0x155
Cc: "Michael Buesch" <mb@bu3sch.de>, "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <484F0AF7.6060008@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0806100709rf4602f2x587631852502c0b5@mail.gmail.com>
	 <200806101637.11473.mb@bu3sch.de>
	 <19f34abd0806100742v176f50e8se463d2e70df44332@mail.gmail.com>
	 <200806101650.27180.mb@bu3sch.de>
	 <a44ae5cd0806101509x5e2d5c19y10101ea0e72f8cba@mail.gmail.com>
	 <484F0AF7.6060008@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 7:15 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Miles Lane wrote:
>>
>> I got a slightly different BUG with this patch applied:
>>
>> BUG: unable to handle kernel NULL pointer dereference at 00000000
>> IP: [<f89e3d41>] :b43:b43_dma_mapping_error+0x16/0x97
>> *pde = 00000000
>> Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
>> last sysfs file:
>>
>> /sys/devices/pci0000:00/0000:00:08.0/0000:01:06.0/ssb0:0/firmware/ssb0:0/loading
>> Modules linked in: sbs sbshc wmi battery iptable_filter ip_tables
>> x_tables ac sbp2 rtc arc4 ecb crypto_blkcipher cryptomgr crypto_algapi
>> b43 mac80211 cfg80211 led_class snd_intel8x0 snd_ac97_codec ac97_bus
>> snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
>> snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore
>> snd_page_alloc i2c_nforce2 i2c_core button ohci1394 3c59x ieee1394
>> forcedeth ehci_hcd ohci_hcd usbcore thermal processor fan thermal_sys
>
> Miles,
>
> If you have time, please cd to the kernel root directory and run the command
> 'objdump -d -l drivers/net/wireless/b43/dma.o > dmadump'. You may have to
> install the objdump package. In the file dmadump, find the line that
> contains b43_dma_mapping_error. On my system it is 0000000000000085
> <b43_dma_mapping_error>: Note, I use x86_64 and yours will likely be
> different.
>
> Note the address (0x85 in my case), add the offset (0x16) and find the line
> with the error. You can use KCalc in hexadecimal mode if you are not
> comfortable with doing addition in base 16. Please report the source line
> and instruction that failed.

For me, the line is:
"000000ab <b43_dma_mapping_error>:"
so, 0xab + 0x16 = 0xc1
and here's the dump giving some context around that line:
b43_dma_mapping_error():
      ab:	55                   	push   %ebp
      ac:	89 e5                	mov    %esp,%ebp
      ae:	57                   	push   %edi
      af:	89 d7                	mov    %edx,%edi
      b1:	56                   	push   %esi
      b2:	89 ce                	mov    %ecx,%esi
      b4:	53                   	push   %ebx
      b5:	83 ec 08             	sub    $0x8,%esp
      b8:	8a 55 08             	mov    0x8(%ebp),%dl
      bb:	88 55 ef             	mov    %dl,-0x11(%ebp)
      be:	8b 50 58             	mov    0x58(%eax),%edx
      c1:	8b 12                	mov    (%edx),%edx
      c3:	8b 52 08             	mov    0x8(%edx),%edx
      c6:	89 55 f0             	mov    %edx,-0x10(%ebp)
      c9:	8b 40 34             	mov    0x34(%eax),%eax
      cc:	83 f8 1e             	cmp    $0x1e,%eax
      cf:	74 07                	je     d8 <b43_dma_mapping_error+0x2d>
      d1:	83 f8 20             	cmp    $0x20,%eax
      d4:	75 5b                	jne    131 <b43_dma_mapping_error+0x86>
      d6:	eb 15                	jmp    ed <b43_dma_mapping_error+0x42>

I hope this helps.

      Miles
