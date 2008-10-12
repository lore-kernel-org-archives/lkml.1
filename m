Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbYJLTWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbYJLTWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 15:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYJLTWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 15:22:45 -0400
Received: from [83.228.35.12] ([83.228.35.12]:55716 "EHLO fs.ru.acad.bg"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYJLTWo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:22:44 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2008 15:22:44 EDT
From: Plamen Petrov <pvp-lsts@fs.ru.acad.bg>
To: linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org
Cc: Ivan Vecera <ivecera@redhat.com>,
       Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>
Subject: [NET][r8169 regression] Linux
  =?utf-8?Q?=22v2.6.27-2721-gfd04808=22?= panics on boot - reverting commit
  7bf6bf4803df1adc927f585168d2135fb019c698 fixes it
Date: Sun, 12 Oct 2008 22:17:37 +0300
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Message-ID: <courier.48F24D51.00004EAC@fs.ru.acad.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello! 

The latest stable snapshot of Linus' tree panics during boot for me.
"git describe" says "v2.6.27-2721-gfd04808".
I was only able to take a picture of the panic with my phone camera,
see [1] and [2] (sorry for the awful quality).
After looking around, I marked a few commits, and I think I got lucky -
reverted the first one, and my machine booted up normally.
The commit I reverted is : 

author  Ivan Vecera <ivecera@redhat.com>
Tue, 23 Sep 2008 22:46:29 +0000 (22:46 +0000)
committer  David S. Miller <davem@davemloft.net>
Wed, 8 Oct 2008 22:40:51 +0000 (15:40 -0700)
commit  7bf6bf4803df1adc927f585168d2135fb019c698
tree  1a679dc561738b620cffe0624dad4102d6ce34e0  tree | snapshot
parent  8d1b1fc9b97ad4de40c063ce3d213895c06fa116  commit | diff
r8169: read MAC address from EEPROM on init

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net> 

The r8169 kernel driver is used with this adapter: 

03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B 
PCI Express Gigabit Ethernet controller (rev 01)
        Subsystem: Giga-byte Technology Unknown device e000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 380
        Region 0: I/O ports at c000 [size=256]
        Region 2: Memory at f8000000 (64-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at f9100000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable+
                Address: 00000000fee0100c  Data: 4169
        Capabilities: [60] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 1024 bytes, PhantFunc 0, 
ExtTag+
                Device: Latency L0s <128ns, L1 unlimited
                Device: AtnBtn+ AtnInd+ PwrInd+
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [84] Vendor Specific Information
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [12c] Virtual Channel
        Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-00-00
        Capabilities: [154] Power Budgeting
00: ec 10 68 81 07 04 10 00 01 00 00 02 08 00 00 00
10: 01 c0 00 00 00 00 00 00 04 00 00 f8 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 00 e0
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00 

NOTE: the above output of "lspci -vvxx" is taken on a kernel
with the commit in question reverted, if it matters at all. 

If you need more info, want me to file a bug report or there is a
patch for me to try - I will be glad to help. 

Thanks, 

[1] http://carpo.iax.be/pic001.jpg
[2] http://carpo.iax.be/pic002.jpg 

Plamen Petrov, network & system administrator
Filial - Silistra
RU "Angel Kantchev"
http://fs.ru.acad.bg/
 --------------------------------
this message is UTF8 encoded 

_
___
_____
 ------------------------------------------
This message was sent by the mail server
at fs.ru.acad.bg using the web interface:
    https://fs.ru.acad.bg/s/m/webmail
E-mail postmaster@fs.ru.acad.bg with anything,
regarding the server itself
