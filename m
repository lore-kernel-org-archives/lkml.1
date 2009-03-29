Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZC2T36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZC2T36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 15:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbZC2T3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 15:29:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:33757 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbZC2T3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 15:29:47 -0400
Message-ID: <49CFCBAE.8040700@kernel.org>
Date: Sun, 29 Mar 2009 12:27:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Prakash Punnoor <prakash@punnoor.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903291115.54351.prakash@punnoor.de> <86802c440903290232g293b72e5oa05c20121bbc16d9@mail.gmail.com> <200903291450.14466.prakash@punnoor.de>
In-Reply-To: <200903291450.14466.prakash@punnoor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prakash Punnoor wrote:
> On Sonntag 29 März 2009 11:32:56 Yinghai Lu wrote:
>> On Sun, Mar 29, 2009 at 2:15 AM, Prakash Punnoor <prakash@punnoor.de> wrote:
>>> On Sonntag 29 März 2009 03:33:03 Yinghai Lu wrote:
>>>> please try follwing patch over pci/linux-next
>>>>
>>>> Thanks
>>>>
>>>> YH
>>>>
>>>> [PATCH] pci: don't enable too much HT MSI mapping -v6
>>> Works fine now, thanks!
>>>
>>> pci 0000:00:00.0: Found disabled HT MSI Mapping
>>> pci 0000:00:00.0: Enabling HT MSI Mapping
>>> pci 0000:00:00.0: Found enabled HT MSI Mapping
>>> pci 0000:00:05.0: Boot video device
>>> pci 0000:00:09.0: Found disabled HT MSI Mapping
>>> pci 0000:00:0e.0: Enabling HT MSI Mapping
>>> pci 0000:00:09.0: Found disabled HT MSI Mapping
>>> pci 0000:00:0f.0: Enabling HT MSI Mapping
>>> pci 0000:00:09.0: Found disabled HT MSI Mapping
>>> pci 0000:00:10.0: Enabling HT MSI Mapping
>>> pci 0000:00:09.0: Found disabled HT MSI Mapping
>>> pci 0000:00:10.1: Enabling HT MSI Mapping
>> can you put you pcie network card in the pcie slot belong to c51?
>> we should find 00:03.0 the pcie bridge...
>>
> 
> 
> Above is when inserted in PCIe 1x slot, now in my PCIe 16x slot
> (I don't have other options):
> 
> pci 0000:00:00.0: Found disabled HT MSI Mapping
> pci 0000:00:00.0: Enabling HT MSI Mapping
> pci 0000:00:00.0: Found enabled HT MSI Mapping
> pci 0000:00:05.0: Boot video device
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:0e.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:0f.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:10.0: Enabling HT MSI Mapping
> pci 0000:00:09.0: Found disabled HT MSI Mapping
> pci 0000:00:10.1: Enabling HT MSI Mapping
> 
> 
> 
> 00:04.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx- 
>         Latency: 0, Cache Line Size: 32 bytes                                                                
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0                                         
>         I/O behind bridge: 0000a000-0000afff                                                                 
>         Memory behind bridge: fdc00000-fdcfffff                                                              
>         Prefetchable memory behind bridge: 00000000fdd00000-00000000fddfffff                                 
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-       
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-                                        
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-                                          
>         Capabilities: [40] Subsystem: nVidia Corporation Device 0000                                         
>         Capabilities: [48] Power Management version 2                                                        
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)                   
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-                                                  
>         Capabilities: [50] MSI: Mask- 64bit+ Count=1/2 Enable+                                               
>                 Address: 00000000fee0300c  Data: 4149                                                        
>         Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-                                        
>                 Mapping Address Base: 00000000fee00000                                                       
>         Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00                                            
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us                       
>                         ExtTag- RBE- FLReset-                                                                
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-                           
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+                                         
>                         MaxPayload 128 bytes, MaxReadReq 512 bytes                                           
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-                          
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us           
>                         ClockPM- Surprise- LLActRep+ BwNot-                                                  
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+                              
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-                                       
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-           
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-                            
>                         Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-                                  
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-                      
>                         Control: AttnInd Off, PwrInd On, Power- Interlock-                                   
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-                         
>                         Changed: MRL- PresDet+ LinkState+                                                    
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-                      
>                 RootCap: CRSVisible-                                                                         
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-                                              
>         Capabilities: [100] Virtual Channel <?>                                                              
>         Kernel driver in use: pcieport-driver                                                                
> 00: de 10 fb 02 07 04 10 00 a1 00 04 06 08 00 01 00                                                          
> 10: 00 00 00 00 00 00 00 00 00 01 01 00 a1 a1 00 20                                                          
> 20: c0 fd c0 fd d1 fd d1 fd 00 00 00 00 00 00 00 00                                                          
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 00 04 00                                                          
> 40: 0d 48 00 00 de 10 00 00 01 50 02 f8 00 00 00 00                                                          
> 50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 49 41 00 00                                                          
> 60: 08 80 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 00                                                          
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                          
> 80: 10 00 41 01 c0 04 00 00 10 28 00 00 01 3d 11 00                                                          
> 90: 40 00 11 30 00 00 00 00 c0 01 48 01 00 00 00 00                                                          
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                          
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                          
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                          
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                          
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                          
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                          
> 
> 


ok, looks good.

Jesse, please apply the -v6, in addition to -v5.

YH

