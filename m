Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbZKKQUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbZKKQUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 11:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757588AbZKKQUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 11:20:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:6245 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600AbZKKQUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 11:20:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l+XKfr8ibvpJLiCmdvzaDBeWq3AuLTh3MllAqGirOxsg4E6wUlG0qqil/AelyEP2oA
         vLO4vkzRR5hY4VVqSns42ycIXSKqEgJPjCq0xcB9VZo30Sgw/ze/yaRYFWD15Z62AGpE
         wemSIjbjk/hrkevA8ikFpk2A3QteK9X4Y4zYg=
Date: Thu, 12 Nov 2009 00:20:52 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Anton D. Kachalov" <mouse@mayc.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
Message-ID: <20091111162052.GD2448@hack>
References: <4AFACC03.7080209@mayc.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFACC03.7080209@mayc.ru>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 05:36:51PM +0300, Anton D. Kachalov wrote:
> Hello everyone!
>
> I've found strange behavior of reading /dev/mem:
>
> for i in 0 1 2; do
>  echo $i
>  dd if=/dev/mem of=/dev/null skip=$((6+$i)) bs=$((0x20000000)) count=1
> done
>
> On some systems with Supermicro X8DTU I've got several messages during  
> first 512Mb starting from 0xc000_0000:
>
>   "BUG: soft lockup - CPU#xx stuck for 61s!"
>
> On other systems with the sameboard I've stuck without any errors at  
> last 10Mb before 0x1_0000_0000. Local APIC access?


What is the full backtrace? And which version of kernel are you
running?


>
> On E5440 (Dell PowerEdge 1950) I've just got several:
> APIC error on CPU3: 00(80)
> APIC error on CPU3: 80(80)
> ...
> APIC error on CPU3: 80(80)
> That looks like wrong register access.
>
> [E5530] $ cat /proc/iomem
> 00000000-0000ffff : reserved
> 00010000-0009dbff : System RAM
> 0009dc00-0009ffff : reserved
> 000c0000-000cffff : pnp 00:0e
> 000e0000-000fffff : reserved
> 00100000-bf77ffff : System RAM
>  00200000-006a37de : Kernel code
>  006a37df-0091a57f : Kernel data
>  00a68000-00b7cbaf : Kernel bss
> bf78e000-bf78ffff : reserved
> bf790000-bf79dfff : ACPI Tables
> bf79e000-bf7cffff : ACPI Non-volatile Storage
> bf7d0000-bf7dffff : reserved
> bf7ec000-bfffffff : reserved
> e0000000-efffffff : PCI MMCONFIG 0
>  e0000000-efffffff : reserved
>    e0000000-efffffff : pnp 00:0d
> f9000000-f9ffffff : PCI Bus 0000:07
>  f9000000-f9ffffff : 0000:07:01.0
> faeda000-faeda0ff : 0000:00:1f.3
> faedc000-faedc3ff : 0000:00:1d.7
>  faedc000-faedc3ff : ehci_hcd
> faede000-faede3ff : 0000:00:1a.7
>  faede000-faede3ff : ehci_hcd
> faee0000-faee3fff : 0000:00:16.7
> faee4000-faee7fff : 0000:00:16.6
> faee8000-faeebfff : 0000:00:16.5
> faeec000-faeeffff : 0000:00:16.4
> faef0000-faef3fff : 0000:00:16.3
> faef4000-faef7fff : 0000:00:16.2
> faef8000-faefbfff : 0000:00:16.1
> faefc000-faefffff : 0000:00:16.0
> faf00000-faffffff : PCI Bus 0000:01
>  faf00000-faf1ffff : 0000:01:00.1
>  faf3c000-faf3ffff : 0000:01:00.1
>    faf3c000-faf3ffff : igb
>  faf40000-faf5ffff : 0000:01:00.1
>    faf40000-faf5ffff : igb
>  faf60000-faf7ffff : 0000:01:00.1
>    faf60000-faf7ffff : igb
>  faf80000-faf9ffff : 0000:01:00.0
>  fafbc000-fafbffff : 0000:01:00.0
>    fafbc000-fafbffff : igb
>  fafc0000-fafdffff : 0000:01:00.0
>    fafc0000-fafdffff : igb
>  fafe0000-faffffff : 0000:01:00.0
>    fafe0000-faffffff : igb
> fb000000-fbefffff : PCI Bus 0000:07
>  fb000000-fb7fffff : 0000:07:01.0
>  fbefc000-fbefffff : 0000:07:01.0
> fec00000-fec00fff : IOAPIC 0
>  fec00000-fec00fff : pnp 00:0c
> fed00000-fed003ff : HPET 0
> fed1c000-fed1ffff : pnp 00:01
>  fed1c000-fed1ffff : pnp 00:0a
> fed20000-fed3ffff : pnp 00:0a
> fed40000-fed8ffff : pnp 00:0a
> fee00000-fee00fff : Local APIC
>  fee00000-fee00fff : reserved
>    fee00000-fee00fff : pnp 00:0c
> ffc00000-ffffffff : reserved
> 100000000-13fffffff : System RAM
>
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
> [    0.000000]  BIOS-e820: 00000000bf78e000 - 00000000bf790000 type 9
> [    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
>
> [E5440] $ cat /proc/iomem
> 00000000-0009ffff : System RAM
>  00000000-00000000 : Crash kernel
> 000a0000-000bffff : Video RAM area
> 000c0000-000c7fff : Video ROM
> 000c9000-000c9fff : Adapter ROM
> 000ca000-000cfbff : Adapter ROM
> 000d0000-000d1dff : Adapter ROM
> 000d2000-000d71ff : Adapter ROM
> 000f0000-000fffff : System ROM
> 00100000-bfb4ffff : System RAM
>  00200000-003e1fbc : Kernel code
>  003e1fbd-004bafe7 : Kernel data
> bfb50000-bfb65fff : reserved
> bfb66000-bfb85bff : ACPI Tables
> bfb85c00-bfffffff : reserved
> d0000000-d7ffffff : PCI Bus #10
>  d0000000-d7ffffff : 0000:10:0d.0
> d8000000-d80fffff : PCI Bus #0c
>  d8000000-d80fffff : PCI Bus #0d
>    d80f0000-d80fffff : 0000:0d:0e.0
>      d80f0000-d80fffff : megasas: LSI Logic
> e0000000-efffffff : reserved
> f2000000-f7ffffff : PCI Bus #04
>  f4000000-f7ffffff : PCI Bus #05
>    f4000000-f7ffffff : PCI Bus #06
>      f4000000-f7ffffff : PCI Bus #07
>        f4000000-f5ffffff : 0000:07:00.0
>          f4000000-f5ffffff : bnx2
> f8000000-fbffffff : PCI Bus #02
>  f8000000-fbffffff : PCI Bus #03
>    f8000000-f9ffffff : 0000:03:00.0
>      f8000000-f9ffffff : bnx2
> fc100000-fc2fffff : PCI Bus #10
>  fc100000-fc11ffff : 0000:10:0d.0
>  fc2d0000-fc2dffff : 0000:10:0d.0
> fc300000-fc5fffff : PCI Bus #0c
>  fc400000-fc5fffff : PCI Bus #0d
>    fc400000-fc407fff : 0000:0d:0e.0
>    fc5c0000-fc5dffff : 0000:0d:0e.0
>      fc5c0000-fc5dffff : megasas: LSI Logic
> fc600000-fc8fffff : PCI Bus #01
>  fc7e0000-fc7effff : 0000:01:00.0
>  fc7fc000-fc7fffff : 0000:01:00.0
>  fc800000-fc8fffff : 0000:01:00.0
> fc900000-fc9003ff : 0000:00:1d.7
>  fc900000-fc9003ff : ehci_hcd
> fe000000-ffffffff : reserved
> 100000000-43fffffff : System RAM
>
> HP - ProLiant DL160G6 says:
> http://www.pixsup.com/uploads/7134cd3e33.png
>
> Rgds,
> Anton
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
