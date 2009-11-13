Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbZKMGIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbZKMGIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 01:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZKMGIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 01:08:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45047 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZKMGIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 01:08:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AFCF7D8.1090207@jp.fujitsu.com>
Date: Fri, 13 Nov 2009 15:08:24 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 2/2] pci: pciehp update the slot bridge res to get big
 range for pcie devices - v10
References: <4ADEB601.8020200@kernel.org>	<4AE52B68.3070501@jp.fujitsu.com>	<4AE53883.3070709@kernel.org>	<4AE5545E.1020900@jp.fujitsu.com>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org>
In-Reply-To: <4AF936DB.1030309@kernel.org>
Content-Type: multipart/mixed;
 boundary="------------080309020805020209090403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080309020805020209090403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Yinghai Lu wrote:
> Kenji Kaneshige wrote:
>> Can I ask which is the latest version?
>>
>> I think -v10 is the latest. But I could not find -v10 for patch 1/2.
> 
> please use
> 
> http://patchwork.kernel.org/patch/57814/  1/2 -v9
> http://patchwork.kernel.org/patch/58294/  2/2 -v10
> 

Regardless of PCIe hotplug, some of PCIe devices (not on hotplug
slots) doesn't work with your patches by the following error.

Copyright (c) 2007-2009 Intel Corporation.
igb 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
igb 0000:07:00.0: setting latency timer to 64
igb 0000:07:00.0: PCI INT A disabled
igb: probe of 0000:07:00.0 failed with error -5
igb 0000:07:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
igb 0000:07:00.1: setting latency timer to 64
igb 0000:07:00.1: PCI INT B disabled
igb: probe of 0000:07:00.1 failed with error -5
igb 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
igb 0000:08:00.0: setting latency timer to 64
igb 0000:08:00.0: PCI INT A disabled
igb: probe of 0000:08:00.0 failed with error -5
igb 0000:08:00.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
igb 0000:08:00.1: setting latency timer to 64
igb 0000:08:00.1: PCI INT B disabled
igb: probe of 0000:08:00.1 failed with error -5

I'm using Jesse's latest linux-next.
I'm attaching the /proc/iomem outputs. The iomem-default.txt is
/proc/iomem output without your patches. The iomem-yinghai.txt
is /proc/iomem output with your patches.

Thanks,
Kenji Kaneshige


--------------080309020805020209090403
Content-Type: text/plain;
 name="iomem-default.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iomem-default.txt"

00000000-0009efff : System RAM
0009f000-0009ffff : ACPI Non-volatile Storage
00100000-79190fff : System RAM
  01000000-0141dbe2 : Kernel code
  0141dbe3-0183639f : Kernel data
  01acb000-027006f7 : Kernel bss
79191000-791c0fff : reserved
791c1000-79207fff : System RAM
79208000-79214fff : ACPI Tables
79215000-79321fff : System RAM
79322000-79322fff : reserved
79323000-7934afff : System RAM
7934b000-7934bfff : ACPI Tables
7934c000-793dffff : System RAM
793e0000-793e1fff : ACPI Tables
793e2000-79401fff : System RAM
79402000-79404fff : ACPI Tables
79405000-79450fff : System RAM
79451000-79451fff : ACPI Tables
79452000-79452fff : ACPI Non-volatile Storage
79453000-799e6fff : System RAM
799e7000-799e9fff : reserved
799ea000-799eefff : System RAM
799ef000-799f1fff : reserved
799f2000-79a30fff : System RAM
79a31000-79a34fff : reserved
79a35000-79a3cfff : System RAM
79a3d000-79a5ffff : reserved
79a60000-79aa1fff : System RAM
79aa2000-7a2b2fff : ACPI Non-volatile Storage
7a2b3000-7a302fff : System RAM
7a303000-7a303fff : reserved
7a304000-7a31dfff : System RAM
7a31e000-7a31efff : ACPI Tables
7a31f000-7a320fff : ACPI Non-volatile Storage
7a321000-7a3a4fff : System RAM
7a3a5000-7a3a7fff : reserved
7a3a8000-7a3a8fff : ACPI Tables
7a3a9000-7a3b4fff : System RAM
7a3b5000-7a3d4fff : reserved
7a3d5000-7a43dfff : System RAM
7a43e000-7a443fff : reserved
7a444000-7a4a1fff : System RAM
7a4a2000-7a4a5fff : reserved
7a4a6000-7a4f3fff : System RAM
7a4f4000-7a4fbfff : reserved
7a4fc000-7a514fff : System RAM
7a515000-7a515fff : ACPI Tables
7a516000-7a553fff : System RAM
7a554000-7a557fff : reserved
7a558000-7a9a9fff : System RAM
7a9aa000-7a9aafff : reserved
7a9ab000-7a9e3fff : System RAM
7a9e4000-7a9e7fff : reserved
7a9e8000-7aad4fff : System RAM
7aad5000-7aad5fff : reserved
7aad6000-7af3efff : System RAM
7af3f000-7af3ffff : reserved
7af40000-7af44fff : System RAM
7af45000-7af45fff : reserved
7af46000-7effffff : System RAM
7f000000-7fffffff : RAM buffer
80000000-8fffffff : PCI MMCONFIG 0 [00-ff]
  80000000-8fffffff : reserved
90000000-fbffffff : PCI Bus #00
  90000000-90ffffff : PCI Bus 0000:19
    90000000-90ffffff : 0000:19:00.0
      90000000-907fffff : efifb
  91000000-917fffff : PCI Bus 0000:03
    91000000-917fffff : PCI Bus 0000:04
      91000000-917fffff : PCI Bus 0000:0c
        91000000-917fffff : PCI Bus 0000:0d
          91000000-911fffff : PCI Bus 0000:11
          91000000-9103ffff : 0000:11:00.0
          91200000-913fffff : PCI Bus 0000:10
          91400000-915fffff : PCI Bus 0000:0f
          91400000-9141ffff : 0000:0f:00.0
          91420000-9143ffff : 0000:0f:00.1
          91600000-917fffff : PCI Bus 0000:0e
  c6000000-c68fffff : PCI Bus 0000:19
    c6000000-c67fffff : 0000:19:00.0
    c6800000-c6803fff : 0000:19:00.0
    c6810000-c681ffff : 0000:19:00.0
  c6a00000-c79fffff : PCI Bus 0000:03
    c6a00000-c79fffff : PCI Bus 0000:04
      c6a00000-c75fffff : PCI Bus 0000:0c
        c6a00000-c75fffff : PCI Bus 0000:0d
          c6a00000-c6cfffff : PCI Bus 0000:11
          c6c00000-c6c03fff : 0000:11:00.0
          c6c04000-c6c04fff : 0000:11:00.0
          c6e00000-c6ffffff : PCI Bus 0000:10
          c7000000-c72fffff : PCI Bus 0000:0f
          c7200000-c721ffff : 0000:0f:00.1
          c7200000-c721ffff : e1000e
          c7220000-c723ffff : 0000:0f:00.1
          c7220000-c723ffff : e1000e
          c7240000-c725ffff : 0000:0f:00.0
          c7240000-c725ffff : e1000e
          c7260000-c727ffff : 0000:0f:00.0
          c7260000-c727ffff : e1000e
          c7400000-c75fffff : PCI Bus 0000:0e
      c7600000-c79fffff : PCI Bus 0000:05
        c7600000-c79fffff : PCI Bus 0000:06
          c7600000-c76fffff : PCI Bus 0000:0a
          c7600000-c760ffff : 0000:0a:00.0
          c7600000-c760ffff : mpt
          c7610000-c7613fff : 0000:0a:00.0
          c7610000-c7613fff : mpt
          c7700000-c77fffff : PCI Bus 0000:09
          c7700000-c770ffff : 0000:09:00.0
          c7700000-c770ffff : mpt
          c7710000-c7713fff : 0000:09:00.0
          c7710000-c7713fff : mpt
          c7800000-c78fffff : PCI Bus 0000:08
          c7800000-c781ffff : 0000:08:00.1
          c7800000-c781ffff : igb
          c7820000-c783ffff : 0000:08:00.1
          c7820000-c783ffff : igb
          c7840000-c785ffff : 0000:08:00.0
          c7840000-c785ffff : igb
          c7860000-c787ffff : 0000:08:00.0
          c7860000-c787ffff : igb
          c7880000-c7883fff : 0000:08:00.1
          c7880000-c7883fff : igb
          c7884000-c7887fff : 0000:08:00.0
          c7884000-c7887fff : igb
          c78a0000-c78bffff : 0000:08:00.0
          c78c0000-c78dffff : 0000:08:00.1
          c78e0000-c78fffff : 0000:08:00.0
          c7900000-c79fffff : PCI Bus 0000:07
          c7900000-c791ffff : 0000:07:00.1
          c7900000-c791ffff : igb
          c7920000-c793ffff : 0000:07:00.1
          c7920000-c793ffff : igb
          c7940000-c795ffff : 0000:07:00.0
          c7940000-c795ffff : igb
          c7960000-c797ffff : 0000:07:00.0
          c7960000-c797ffff : igb
          c7980000-c7983fff : 0000:07:00.1
          c7980000-c7983fff : igb
          c7984000-c7987fff : 0000:07:00.0
          c7984000-c7987fff : igb
          c79a0000-c79bffff : 0000:07:00.0
          c79c0000-c79dffff : 0000:07:00.1
          c79e0000-c79fffff : 0000:07:00.0
  c7a00000-c7a1ffff : 0000:00:19.0
    c7a00000-c7a1ffff : e1000e
  c7a20000-c7a23fff : 0000:00:16.0
    c7a20000-c7a23fff : ioatdma
  c7a24000-c7a27fff : 0000:00:16.1
    c7a24000-c7a27fff : ioatdma
  c7a28000-c7a2bfff : 0000:00:16.2
    c7a28000-c7a2bfff : ioatdma
  c7a2c000-c7a2ffff : 0000:00:16.3
    c7a2c000-c7a2ffff : ioatdma
  c7a30000-c7a33fff : 0000:00:16.4
    c7a30000-c7a33fff : ioatdma
  c7a34000-c7a37fff : 0000:00:16.5
    c7a34000-c7a37fff : ioatdma
  c7a38000-c7a3bfff : 0000:00:16.6
    c7a38000-c7a3bfff : ioatdma
  c7a3c000-c7a3ffff : 0000:00:16.7
    c7a3c000-c7a3ffff : ioatdma
  c7a40000-c7a40fff : 0000:00:1f.6
  c7a41000-c7a41fff : 0000:00:19.0
    c7a41000-c7a41fff : e1000e
  c7a42000-c7a42fff : 0000:00:13.0
  c7a43000-c7a433ff : 0000:00:1d.7
    c7a43000-c7a433ff : ehci_hcd
  c7a43400-c7a437ff : 0000:00:1a.7
    c7a43400-c7a437ff : ehci_hcd
  c7a43800-c7a438ff : 0000:00:1f.3
fec00000-fec00fff : IOAPIC 0
fee00000-fee00fff : Local APIC
100000000-47fffffff : System RAM
fc000000000-fc07fffffff : PCI Bus #00

--------------080309020805020209090403
Content-Type: text/plain;
 name="iomem-yinghai.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iomem-yinghai.txt"

00000000-0009efff : System RAM
0009f000-0009ffff : ACPI Non-volatile Storage
00100000-79190fff : System RAM
  01000000-0141e142 : Kernel code
  0141e143-0183639f : Kernel data
  01acb000-027006f7 : Kernel bss
79191000-791c0fff : reserved
791c1000-79207fff : System RAM
79208000-79214fff : ACPI Tables
79215000-79321fff : System RAM
79322000-79322fff : reserved
79323000-7934afff : System RAM
7934b000-7934bfff : ACPI Tables
7934c000-793dffff : System RAM
793e0000-793e1fff : ACPI Tables
793e2000-79401fff : System RAM
79402000-79404fff : ACPI Tables
79405000-79450fff : System RAM
79451000-79451fff : ACPI Tables
79452000-79452fff : ACPI Non-volatile Storage
79453000-799e6fff : System RAM
799e7000-799e9fff : reserved
799ea000-799eefff : System RAM
799ef000-799f1fff : reserved
799f2000-79a30fff : System RAM
79a31000-79a34fff : reserved
79a35000-79a3cfff : System RAM
79a3d000-79a5ffff : reserved
79a60000-79aa1fff : System RAM
79aa2000-7a2b2fff : ACPI Non-volatile Storage
7a2b3000-7a302fff : System RAM
7a303000-7a303fff : reserved
7a304000-7a31dfff : System RAM
7a31e000-7a31efff : ACPI Tables
7a31f000-7a320fff : ACPI Non-volatile Storage
7a321000-7a3a4fff : System RAM
7a3a5000-7a3a7fff : reserved
7a3a8000-7a3a8fff : ACPI Tables
7a3a9000-7a3b4fff : System RAM
7a3b5000-7a3d4fff : reserved
7a3d5000-7a43dfff : System RAM
7a43e000-7a443fff : reserved
7a444000-7a4a1fff : System RAM
7a4a2000-7a4a5fff : reserved
7a4a6000-7a4f3fff : System RAM
7a4f4000-7a4fbfff : reserved
7a4fc000-7a514fff : System RAM
7a515000-7a515fff : ACPI Tables
7a516000-7a553fff : System RAM
7a554000-7a557fff : reserved
7a558000-7a9a9fff : System RAM
7a9aa000-7a9aafff : reserved
7a9ab000-7a9e3fff : System RAM
7a9e4000-7a9e7fff : reserved
7a9e8000-7aad4fff : System RAM
7aad5000-7aad5fff : reserved
7aad6000-7af3efff : System RAM
7af3f000-7af3ffff : reserved
7af40000-7af44fff : System RAM
7af45000-7af45fff : reserved
7af46000-7effffff : System RAM
7f000000-7fffffff : RAM buffer
80000000-8fffffff : PCI MMCONFIG 0 [00-ff]
  80000000-8fffffff : reserved
90000000-fbffffff : PCI Bus #00
  90000000-90ffffff : PCI Bus 0000:19
    90000000-90ffffff : 0000:19:00.0
      90000000-907fffff : efifb
  91000000-917fffff : PCI Bus 0000:03
    91000000-917fffff : PCI Bus 0000:04
      91000000-917fffff : PCI Bus 0000:0c
        91000000-917fffff : PCI Bus 0000:0d
          91000000-911fffff : PCI Bus 0000:11
          91000000-9103ffff : 0000:11:00.0
          91200000-913fffff : PCI Bus 0000:10
          91400000-915fffff : PCI Bus 0000:0f
          91400000-9141ffff : 0000:0f:00.0
          91420000-9143ffff : 0000:0f:00.1
          91600000-917fffff : PCI Bus 0000:0e
  c6000000-c68fffff : PCI Bus 0000:19
    c6000000-c67fffff : 0000:19:00.0
    c6800000-c6803fff : 0000:19:00.0
    c6810000-c681ffff : 0000:19:00.0
  c6a00000-c79fffff : PCI Bus 0000:03
    c6a00000-c79fffff : PCI Bus 0000:04
      c6a00000-c75fffff : PCI Bus 0000:0c
        c6a00000-c75fffff : PCI Bus 0000:0d
          c6a00000-c6cfffff : PCI Bus 0000:11
          c6c00000-c6c03fff : 0000:11:00.0
          c6c00000-c6c03fff : lpfc
          c6c04000-c6c04fff : 0000:11:00.0
          c6c04000-c6c04fff : lpfc
          c6e00000-c6ffffff : PCI Bus 0000:10
          c7000000-c72fffff : PCI Bus 0000:0f
          c7200000-c721ffff : 0000:0f:00.1
          c7200000-c721ffff : e1000e
          c7220000-c723ffff : 0000:0f:00.1
          c7220000-c723ffff : e1000e
          c7240000-c725ffff : 0000:0f:00.0
          c7240000-c725ffff : e1000e
          c7260000-c727ffff : 0000:0f:00.0
          c7260000-c727ffff : e1000e
          c7400000-c75fffff : PCI Bus 0000:0e
      c7600000-c79fffff : PCI Bus 0000:05
        c7600000-c79fffff : PCI Bus 0000:06
          c7600000-c76fffff : PCI Bus 0000:0a
          c7600000-c760ffff : 0000:0a:00.0
          c7600000-c760ffff : mpt
          c7610000-c7613fff : 0000:0a:00.0
          c7610000-c7613fff : mpt
          c7700000-c77fffff : PCI Bus 0000:09
          c7700000-c770ffff : 0000:09:00.0
          c7700000-c770ffff : mpt
          c7710000-c7713fff : 0000:09:00.0
          c7710000-c7713fff : mpt
          c7800000-c79fffff : PCI Bus 0000:09
          c7800000-c79fffff : 0000:09:00.0
  c7a00000-c7a1ffff : 0000:00:19.0
    c7a00000-c7a1ffff : e1000e
  c7a20000-c7a23fff : 0000:00:16.0
    c7a20000-c7a23fff : ioatdma
  c7a24000-c7a27fff : 0000:00:16.1
    c7a24000-c7a27fff : ioatdma
  c7a28000-c7a2bfff : 0000:00:16.2
    c7a28000-c7a2bfff : ioatdma
  c7a2c000-c7a2ffff : 0000:00:16.3
    c7a2c000-c7a2ffff : ioatdma
  c7a30000-c7a33fff : 0000:00:16.4
    c7a30000-c7a33fff : ioatdma
  c7a34000-c7a37fff : 0000:00:16.5
    c7a34000-c7a37fff : ioatdma
  c7a38000-c7a3bfff : 0000:00:16.6
    c7a38000-c7a3bfff : ioatdma
  c7a3c000-c7a3ffff : 0000:00:16.7
    c7a3c000-c7a3ffff : ioatdma
  c7a40000-c7a40fff : 0000:00:1f.6
  c7a41000-c7a41fff : 0000:00:19.0
    c7a41000-c7a41fff : e1000e
  c7a42000-c7a42fff : 0000:00:13.0
  c7a43000-c7a433ff : 0000:00:1d.7
    c7a43000-c7a433ff : ehci_hcd
  c7a43400-c7a437ff : 0000:00:1a.7
    c7a43400-c7a437ff : ehci_hcd
  c7a43800-c7a438ff : 0000:00:1f.3
fec00000-fec00fff : IOAPIC 0
fee00000-fee00fff : Local APIC
100000000-47fffffff : System RAM
fc000000000-fc07fffffff : PCI Bus #00

--------------080309020805020209090403--

