Return-Path: <linux-kernel-owner+w=401wt.eu-S934358AbXJPPyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358AbXJPPyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933395AbXJPPyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:54:25 -0400
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:33618 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932419AbXJPPyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:54:24 -0400
X-Greylist: delayed 1700 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2007 11:54:24 EDT
Message-ID: <4714D785.3000402@vlnb.net>
Date: Tue, 16 Oct 2007 19:23:49 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Francois Romieu <romieu@fr.zoreil.com>
Subject: r8169 & TX offload
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've recently bought Realtek RTL8169S-32 chip based Gigabit Ethernet card:

# lspci -vv
Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit 
Ethernet (rev 10)
         Subsystem: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit 
Ethernet
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (8000ns min, 16000ns max), Cache Line Size 20
         Interrupt: pin A routed to IRQ 10
         Region 0: I/O ports at c400 [size=256]
         Region 1: Memory at fe9fec00 (32-bit, non-prefetchable) [size=256]
         Expansion ROM at fe9c0000 [disabled] [size=128K]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

I've noticed that all TX offload features (tx-checksumming, 
scatter-gather and TSO) are disabled by default and should be manually 
enabled by ethtool. I wonder, is there any particular reason for that? 
Why they are not enabled by default as it was done for e1000 or tg3? Are 
there any hidden drawbacks in enabling them?

Those offload options are definitely work. They give in my setup (32-bit 
66MHz PCI, Xeon 1.7GHz CPU, open-iscsi) CPU offload from 75% to 45% and 
data write throughput improvement from 55MB/s to 59MB/s.

Regards,
Vlad
