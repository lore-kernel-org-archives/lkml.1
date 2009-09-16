Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbZIPPD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbZIPPD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759187AbZIPPDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:03:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:16740 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759211AbZIPPDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=NVkLugz9ljjq8lcVn1Kwh43XdU/jWjCZjWyuTDkVcY+uwRjDOcdqRh8LLLYpddyIst
         KFL+4gBe82AagYDbR1sQMyxyVVJ15D9Gg+NHesvtOkct7h37kD2MsIhM1jGzRwXW+iF/
         JtWcZpiADCRV7Z+6BJc07zfyF0HVHYK4Xh1kw=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
       linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
Date: Wed, 16 Sep 2009 17:03:17 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
References: <Pine.LNX.4.44L0.0909160939230.8236-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909160939230.8236-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909161703.17557.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch 16 September 2009, you wrote:
> On Wed, 16 Sep 2009, Volker Armin Hemmann wrote:
> > emm, the mouse is attached through a powered 4port usb 2.0 hub. That is
> > the only way to get it working. If I attach it directly (without loading
> > ohci) it does not work (well, only tried with both Transaction Translator
> > options off), and if I load ohci before I connect it, it is very very
> > jerky. So jerky in fact, that I considered douzends of lockups a day a
> > better alternative.
> 
> That is a separate issue and it is a serious bug.  If anything, the
> behavior with OHCI should be better than with EHCI.  This is worth
> pursuing farther.  A usbmon log combined with the dmesg log would help.
> There's no need to include all the boot-up messages in the dmesg log;
> you can clear the log buffer before plugging in the mouse.
> 
> In fact, we can probably forget about the EHCI issue.  If it works okay
> with the newer TT scheduler, that should be good enough.
> 
> Alan Stern
> 


I removed the mouse, cleared dmesg, loaded ohci_ inserted mouse in one of the 
ports, moved it, lots of jerks. It was good for a couple of seconds, then it 
hangs&is jerky, than was ok for a while.
 Sometimes it is good for several minutes before becoming jerky - and there is 
nothing I know of to make it appear. It just happens and goes away. Randomly 
it seems. 

[ 4641.872236] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[ 4641.872244] ohci_hcd: block sizes: ed 80 td 96                    
[ 4641.872295]   alloc irq_desc for 16 on node -1                    
[ 4641.872300]   alloc kstat_irqs on node -1                         
[ 4641.872313] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[ 4641.873309] ohci_hcd 0000:00:12.0: OHCI Host Controller                      
[ 4641.873523] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus 
number 3
[ 4641.873550] ohci_hcd 0000:00:12.0: enabled AMD ISO transfers quirk              
[ 4641.873576] ohci_hcd 0000:00:12.0: created debug files                          
[ 4641.873581] ohci_hcd 0000:00:12.0: supports USB remote wakeup                   
[ 4641.873612] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfddfe000                    
[ 4641.931511] ohci_hcd 0000:00:12.0: OHCI controller state                        
[ 4641.931523] ohci_hcd 0000:00:12.0: OHCI 1.0, NO legacy support registers        
[ 4641.931533] ohci_hcd 0000:00:12.0: control 0x283 RWC HCFS=operational 
CBSR=3    
[ 4641.931540] ohci_hcd 0000:00:12.0: cmdstatus 0x00000 SOC=0                      
[ 4641.931548] ohci_hcd 0000:00:12.0: intrstatus 0x00000004 SF                     
[ 4641.931555] ohci_hcd 0000:00:12.0: intrenable 0x8000001a MIE UE RD WDH          
[ 4641.931567] ohci_hcd 0000:00:12.0: hcca frame #0005                             
[ 4641.931575] ohci_hcd 0000:00:12.0: roothub.a 02001203 POTPGT=2 NOCP NPS 
NDP=3(3)
[ 4641.931582] ohci_hcd 0000:00:12.0: roothub.b 00000000 PPCM=0000 DR=0000         
[ 4641.931589] ohci_hcd 0000:00:12.0: roothub.status 00008000 DRWE                 
[ 4641.931597] ohci_hcd 0000:00:12.0: roothub.portstatus [0] 0x00000100 PPS        
[ 4641.931604] ohci_hcd 0000:00:12.0: roothub.portstatus [1] 0x00000100 PPS        
[ 4641.931611] ohci_hcd 0000:00:12.0: roothub.portstatus [2] 0x00000100 PPS        
[ 4641.931639] usb usb3: default language 0x0409                                   
[ 4641.931653] usb usb3: udev 1, busnum 3, minor = 256                             
[ 4641.931658] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001       
[ 4641.931663] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1  
[ 4641.931668] usb usb3: Product: OHCI Host Controller                             
[ 4641.931672] usb usb3: Manufacturer: Linux 2.6.31r4 ohci_hcd                     
[ 4641.931676] usb usb3: SerialNumber: 0000:00:12.0                                
[ 4641.931795] usb usb3: uevent                                                    
[ 4641.931944] usb usb3: usb_probe_device                                          
[ 4641.931950] usb usb3: configuration #1 chosen from 1 choice                     
[ 4641.931967] usb usb3: adding 3-0:1.0 (config #1, interface 0)                   
[ 4641.932002] usb 3-0:1.0: uevent                                                 
[ 4641.932076] hub 3-0:1.0: usb_probe_interface                                    
[ 4641.932081] hub 3-0:1.0: usb_probe_interface - got id                           
[ 4641.932087] hub 3-0:1.0: USB hub found                                          
[ 4641.932105] hub 3-0:1.0: 3 ports detected                                       
[ 4641.932109] hub 3-0:1.0: standalone hub                                         
[ 4641.932113] hub 3-0:1.0: no power switching (usb 1.0)                           
[ 4641.932118] hub 3-0:1.0: no over-current protection                             
[ 4641.932122] hub 3-0:1.0: power on to power good time: 4ms                       
[ 4641.932133] hub 3-0:1.0: local power source is good                             
[ 4641.932138] hub 3-0:1.0: trying to enable port power on non-switchable hub      
[ 4641.932239] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 
16   
[ 4641.932290] ohci_hcd 0000:00:12.1: OHCI Host Controller                         
[ 4641.932428] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus 
number 4
[ 4641.932451] ohci_hcd 0000:00:12.1: enabled AMD ISO transfers quirk              
[ 4641.932476] ohci_hcd 0000:00:12.1: created debug files                          
[ 4641.932482] ohci_hcd 0000:00:12.1: supports USB remote wakeup                   
[ 4641.932497] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfddfd000                    
[ 4641.988180] ohci_hcd 0000:00:12.1: OHCI controller state                        
[ 4641.988190] ohci_hcd 0000:00:12.1: OHCI 1.0, NO legacy support registers        
[ 4641.988200] ohci_hcd 0000:00:12.1: control 0x283 RWC HCFS=operational 
CBSR=3    
[ 4641.988208] ohci_hcd 0000:00:12.1: cmdstatus 0x00000 SOC=0                      
[ 4641.988215] ohci_hcd 0000:00:12.1: intrstatus 0x00000004 SF                     
[ 4641.988223] ohci_hcd 0000:00:12.1: intrenable 0x8000001a MIE UE RD WDH          
[ 4641.988235] ohci_hcd 0000:00:12.1: hcca frame #0005                             
[ 4641.988243] ohci_hcd 0000:00:12.1: roothub.a 02001203 POTPGT=2 NOCP NPS 
NDP=3(3)
[ 4641.988250] ohci_hcd 0000:00:12.1: roothub.b 00000000 PPCM=0000 DR=0000         
[ 4641.988256] ohci_hcd 0000:00:12.1: roothub.status 00008000 DRWE                 
[ 4641.988264] ohci_hcd 0000:00:12.1: roothub.portstatus [0] 0x00000100 PPS        
[ 4641.988271] ohci_hcd 0000:00:12.1: roothub.portstatus [1] 0x00000100 PPS        
[ 4641.988278] ohci_hcd 0000:00:12.1: roothub.portstatus [2] 0x00000100 PPS        
[ 4641.988304] usb usb4: default language 0x0409                                   
[ 4641.988317] usb usb4: udev 1, busnum 4, minor = 384                             
[ 4641.988322] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001       
[ 4641.988327] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1  
[ 4641.988332] usb usb4: Product: OHCI Host Controller                             
[ 4641.988336] usb usb4: Manufacturer: Linux 2.6.31r4 ohci_hcd                     
[ 4641.988340] usb usb4: SerialNumber: 0000:00:12.1                                
[ 4641.988445] usb usb4: uevent                                                    
[ 4641.989624] usb usb4: usb_probe_device                                          
[ 4641.989631] usb usb4: configuration #1 chosen from 1 choice                     
[ 4641.989648] usb usb4: adding 4-0:1.0 (config #1, interface 0)                   
[ 4641.989685] usb 4-0:1.0: uevent                                                 
[ 4641.989770] hub 4-0:1.0: usb_probe_interface                                    
[ 4641.989775] hub 4-0:1.0: usb_probe_interface - got id                           
[ 4641.989780] hub 4-0:1.0: USB hub found                                          
[ 4641.989797] hub 4-0:1.0: 3 ports detected                                       
[ 4641.989801] hub 4-0:1.0: standalone hub                                         
[ 4641.989805] hub 4-0:1.0: no power switching (usb 1.0)                           
[ 4641.989809] hub 4-0:1.0: no over-current protection                             
[ 4641.989814] hub 4-0:1.0: power on to power good time: 4ms                       
[ 4641.989824] hub 4-0:1.0: local power source is good                             
[ 4641.989830] hub 4-0:1.0: trying to enable port power on non-switchable hub      
[ 4641.989929] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 
18   
[ 4641.989975] ohci_hcd 0000:00:13.0: OHCI Host Controller                         
[ 4641.990115] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus 
number 5
[ 4641.990137] ohci_hcd 0000:00:13.0: enabled AMD ISO transfers quirk              
[ 4641.990165] ohci_hcd 0000:00:13.0: created debug files                          
[ 4641.990170] ohci_hcd 0000:00:13.0: supports USB remote wakeup                   
[ 4641.990202] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfddfc000                    
[ 4642.030839] hub 3-0:1.0: state 7 ports 3 chg 0000 evt 0000                      
[ 4642.048175] ohci_hcd 0000:00:13.0: OHCI controller state                        
[ 4642.048184] ohci_hcd 0000:00:13.0: OHCI 1.0, NO legacy support registers        
[ 4642.048193] ohci_hcd 0000:00:13.0: control 0x283 RWC HCFS=operational 
CBSR=3    
[ 4642.048200] ohci_hcd 0000:00:13.0: cmdstatus 0x00000 SOC=0                      
[ 4642.048207] ohci_hcd 0000:00:13.0: intrstatus 0x00000004 SF                     
[ 4642.048214] ohci_hcd 0000:00:13.0: intrenable 0x8000001a MIE UE RD WDH          
[ 4642.048227] ohci_hcd 0000:00:13.0: hcca frame #0005                             
[ 4642.048234] ohci_hcd 0000:00:13.0: roothub.a 02001203 POTPGT=2 NOCP NPS 
NDP=3(3)
[ 4642.048241] ohci_hcd 0000:00:13.0: roothub.b 00000000 PPCM=0000 DR=0000         
[ 4642.048247] ohci_hcd 0000:00:13.0: roothub.status 00008000 DRWE                 
[ 4642.048255] ohci_hcd 0000:00:13.0: roothub.portstatus [0] 0x00000100 PPS        
[ 4642.048262] ohci_hcd 0000:00:13.0: roothub.portstatus [1] 0x00000100 PPS        
[ 4642.048269] ohci_hcd 0000:00:13.0: roothub.portstatus [2] 0x00000100 PPS        
[ 4642.048293] usb usb5: default language 0x0409                                   
[ 4642.048306] usb usb5: udev 1, busnum 5, minor = 512                             
[ 4642.048310] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001       
[ 4642.048315] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1  
[ 4642.048320] usb usb5: Product: OHCI Host Controller                             
[ 4642.048324] usb usb5: Manufacturer: Linux 2.6.31r4 ohci_hcd                     
[ 4642.048328] usb usb5: SerialNumber: 0000:00:13.0                                
[ 4642.048428] usb usb5: uevent                                                    
[ 4642.048551] usb usb5: usb_probe_device                                          
[ 4642.048556] usb usb5: configuration #1 chosen from 1 choice                     
[ 4642.048571] usb usb5: adding 5-0:1.0 (config #1, interface 0)                   
[ 4642.048605] usb 5-0:1.0: uevent                                                 
[ 4642.048674] hub 5-0:1.0: usb_probe_interface                                    
[ 4642.048679] hub 5-0:1.0: usb_probe_interface - got id                           
[ 4642.048684] hub 5-0:1.0: USB hub found                                          
[ 4642.048701] hub 5-0:1.0: 3 ports detected                                       
[ 4642.048704] hub 5-0:1.0: standalone hub                                         
[ 4642.048708] hub 5-0:1.0: no power switching (usb 1.0)                           
[ 4642.048712] hub 5-0:1.0: no over-current protection                             
[ 4642.048717] hub 5-0:1.0: power on to power good time: 4ms                       
[ 4642.048727] hub 5-0:1.0: local power source is good                             
[ 4642.048731] hub 5-0:1.0: trying to enable port power on non-switchable hub      
[ 4642.048827] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 
18   
[ 4642.048864] ohci_hcd 0000:00:13.1: OHCI Host Controller                         
[ 4642.048997] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus 
number 6
[ 4642.049016] ohci_hcd 0000:00:13.1: enabled AMD ISO transfers quirk              
[ 4642.049041] ohci_hcd 0000:00:13.1: created debug files                          
[ 4642.049046] ohci_hcd 0000:00:13.1: supports USB remote wakeup                   
[ 4642.049060] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfddf7000                    
[ 4642.090842] hub 4-0:1.0: state 7 ports 3 chg 0000 evt 0000                      
[ 4642.104844] ohci_hcd 0000:00:13.1: OHCI controller state                        
[ 4642.104853] ohci_hcd 0000:00:13.1: OHCI 1.0, NO legacy support registers        
[ 4642.104862] ohci_hcd 0000:00:13.1: control 0x283 RWC HCFS=operational 
CBSR=3    
[ 4642.104869] ohci_hcd 0000:00:13.1: cmdstatus 0x00000 SOC=0                      
[ 4642.104876] ohci_hcd 0000:00:13.1: intrstatus 0x00000004 SF                     
[ 4642.104883] ohci_hcd 0000:00:13.1: intrenable 0x8000001a MIE UE RD WDH          
[ 4642.104895] ohci_hcd 0000:00:13.1: hcca frame #0005                             
[ 4642.104902] ohci_hcd 0000:00:13.1: roothub.a 02001203 POTPGT=2 NOCP NPS 
NDP=3(3)
[ 4642.104909] ohci_hcd 0000:00:13.1: roothub.b 00000000 PPCM=0000 DR=0000         
[ 4642.104915] ohci_hcd 0000:00:13.1: roothub.status 00008000 DRWE                 
[ 4642.104923] ohci_hcd 0000:00:13.1: roothub.portstatus [0] 0x00000100 PPS        
[ 4642.104930] ohci_hcd 0000:00:13.1: roothub.portstatus [1] 0x00000100 PPS        
[ 4642.104937] ohci_hcd 0000:00:13.1: roothub.portstatus [2] 0x00000100 PPS        
[ 4642.104960] usb usb6: default language 0x0409                                   
[ 4642.104973] usb usb6: udev 1, busnum 6, minor = 640                             
[ 4642.104977] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001       
[ 4642.104982] usb usb6: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1  
[ 4642.104987] usb usb6: Product: OHCI Host Controller                             
[ 4642.104991] usb usb6: Manufacturer: Linux 2.6.31r4 ohci_hcd                     
[ 4642.104995] usb usb6: SerialNumber: 0000:00:13.1                                
[ 4642.105095] usb usb6: uevent                                                    
[ 4642.106222] usb usb6: usb_probe_device                                          
[ 4642.106229] usb usb6: configuration #1 chosen from 1 choice                     
[ 4642.106245] usb usb6: adding 6-0:1.0 (config #1, interface 0)                   
[ 4642.106278] usb 6-0:1.0: uevent                                                 
[ 4642.106361] hub 6-0:1.0: usb_probe_interface                                    
[ 4642.106365] hub 6-0:1.0: usb_probe_interface - got id                           
[ 4642.106370] hub 6-0:1.0: USB hub found                                          
[ 4642.106386] hub 6-0:1.0: 3 ports detected                                       
[ 4642.106389] hub 6-0:1.0: standalone hub                                         
[ 4642.106393] hub 6-0:1.0: no power switching (usb 1.0)                           
[ 4642.106397] hub 6-0:1.0: no over-current protection                             
[ 4642.106401] hub 6-0:1.0: power on to power good time: 4ms                       
[ 4642.106411] hub 6-0:1.0: local power source is good                             
[ 4642.106416] hub 6-0:1.0: trying to enable port power on non-switchable hub      
[ 4642.106511] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 
18   
[ 4642.106551] ohci_hcd 0000:00:14.5: OHCI Host Controller                         
[ 4642.106690] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus 
number 7
[ 4642.106710] ohci_hcd 0000:00:14.5: enabled AMD ISO transfers quirk              
[ 4642.106737] ohci_hcd 0000:00:14.5: created debug files                          
[ 4642.106741] ohci_hcd 0000:00:14.5: supports USB remote wakeup                   
[ 4642.106756] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfddf5000                    
[ 4642.147506] hub 5-0:1.0: state 7 ports 3 chg 0000 evt 0000                      
[ 4642.164847] ohci_hcd 0000:00:14.5: OHCI controller state                        
[ 4642.164856] ohci_hcd 0000:00:14.5: OHCI 1.0, NO legacy support registers        
[ 4642.164865] ohci_hcd 0000:00:14.5: control 0x283 RWC HCFS=operational 
CBSR=3    
[ 4642.164872] ohci_hcd 0000:00:14.5: cmdstatus 0x00000 SOC=0                      
[ 4642.164879] ohci_hcd 0000:00:14.5: intrstatus 0x00000004 SF                     
[ 4642.164886] ohci_hcd 0000:00:14.5: intrenable 0x8000001a MIE UE RD WDH          
[ 4642.164898] ohci_hcd 0000:00:14.5: hcca frame #0005                             
[ 4642.164905] ohci_hcd 0000:00:14.5: roothub.a 02001202 POTPGT=2 NOCP NPS 
NDP=2(2)
[ 4642.164912] ohci_hcd 0000:00:14.5: roothub.b 00000000 PPCM=0000 DR=0000         
[ 4642.164918] ohci_hcd 0000:00:14.5: roothub.status 00008000 DRWE                 
[ 4642.164926] ohci_hcd 0000:00:14.5: roothub.portstatus [0] 0x00000100 PPS        
[ 4642.164933] ohci_hcd 0000:00:14.5: roothub.portstatus [1] 0x00000100 PPS        
[ 4642.164956] usb usb7: default language 0x0409                                   
[ 4642.164970] usb usb7: udev 1, busnum 7, minor = 768                             
[ 4642.164974] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001       
[ 4642.164979] usb usb7: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1  
[ 4642.164984] usb usb7: Product: OHCI Host Controller                             
[ 4642.164988] usb usb7: Manufacturer: Linux 2.6.31r4 ohci_hcd                     
[ 4642.164992] usb usb7: SerialNumber: 0000:00:14.5                                
[ 4642.165094] usb usb7: uevent                                                    
[ 4642.166223] usb usb7: usb_probe_device                                          
[ 4642.166230] usb usb7: configuration #1 chosen from 1 choice                     
[ 4642.166246] usb usb7: adding 7-0:1.0 (config #1, interface 0)                   
[ 4642.166283] usb 7-0:1.0: uevent                                                 
[ 4642.166369] hub 7-0:1.0: usb_probe_interface                                    
[ 4642.166373] hub 7-0:1.0: usb_probe_interface - got id                           
[ 4642.166378] hub 7-0:1.0: USB hub found                                          
[ 4642.166394] hub 7-0:1.0: 2 ports detected                                       
[ 4642.166398] hub 7-0:1.0: standalone hub                                         
[ 4642.166402] hub 7-0:1.0: no power switching (usb 1.0)                           
[ 4642.166406] hub 7-0:1.0: no over-current protection                             
[ 4642.166410] hub 7-0:1.0: power on to power good time: 4ms                       
[ 4642.166420] hub 7-0:1.0: local power source is good                             
[ 4642.166425] hub 7-0:1.0: trying to enable port power on non-switchable hub      
[ 4642.207505] hub 6-0:1.0: state 7 ports 3 chg 0000 evt 0000                      
[ 4642.267500] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000                      
[ 4643.097483] ohci_hcd 0000:00:12.0: auto-stop root hub                           
[ 4643.097504] ohci_hcd 0000:00:12.1: auto-stop root hub                           
[ 4643.097521] ohci_hcd 0000:00:13.0: auto-stop root hub                           
[ 4643.347483] ohci_hcd 0000:00:13.1: auto-stop root hub                           
[ 4643.347501] ohci_hcd 0000:00:14.5: auto-stop root hub                           
[ 4644.317487] hub 3-0:1.0: hub_suspend                                            
[ 4644.317500] usb usb3: bus auto-suspend                                          
[ 4644.317506] ohci_hcd 0000:00:12.0: suspend root hub                             
[ 4644.317516] hub 4-0:1.0: hub_suspend                                            
[ 4644.317521] usb usb4: bus auto-suspend                                          
[ 4644.317526] ohci_hcd 0000:00:12.1: suspend root hub                             
[ 4644.317534] hub 5-0:1.0: hub_suspend                                            
[ 4644.317539] usb usb5: bus auto-suspend                                          
[ 4644.317544] ohci_hcd 0000:00:13.0: suspend root hub                             
[ 4644.317552] hub 6-0:1.0: hub_suspend                                            
[ 4644.317557] usb usb6: bus auto-suspend                                          
[ 4644.317562] ohci_hcd 0000:00:13.1: suspend root hub                             
[ 4644.317569] hub 7-0:1.0: hub_suspend                                            
[ 4644.317574] usb usb7: bus auto-suspend                                          
[ 4644.317579] ohci_hcd 0000:00:14.5: suspend root hub                             
[ 4648.692184] usb usb2: usb resume                                                
[ 4648.692193] ehci_hcd 0000:00:13.2: resume root hub                              
[ 4648.717486] hub 2-0:1.0: hub_resume                                             
[ 4648.717514] ehci_hcd 0000:00:13.2: GetStatus port 3 status 001403 POWER 
sig=k CSC CONNECT
[ 4648.717521] hub 2-0:1.0: port 3: status 0501 change 0001                                 
[ 4648.820828] hub 2-0:1.0: state 7 ports 6 chg 0008 evt 0000                               
[ 4648.820846] hub 2-0:1.0: port 3, status 0501, change 0000, 480 Mb/s                      
[ 4648.820871] ehci_hcd 0000:00:13.2: port 3 low speed --> companion                        
[ 4648.820930] usb usb5: usb resume                                                         
[ 4648.830402] ohci_hcd 0000:00:13.0: wakeup root hub                                       
[ 4648.874163] ehci_hcd 0000:00:13.2: GetStatus port 3 status 001002 POWER 
sig=se0 CSC      
[ 4648.874190] hub 2-0:1.0: unable to enumerate USB device on port 3                        
[ 4648.874202] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008                               
[ 4648.895393] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008                               
[ 4648.895410] ehci_hcd 0000:00:13.2: GetStatus port 3 status 001003 POWER 
sig=se0 CSC CONNECT
[ 4648.895424] hub 2-0:1.0: port 3, status 0501, change 0001, 480 Mb/s                        
[ 4648.900403] hub 5-0:1.0: hub_resume
[ 4648.900428] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [2] = 
0x00010100 CSC PPS
[ 4648.924159] ehci_hcd 0000:00:13.2: GetStatus port 3 status 001403 POWER 
sig=k CSC CONNECT
[ 4649.044158] hub 2-0:1.0: debounce: port 3: total 125ms stable 100ms status 
0x501
[ 4649.044175] ehci_hcd 0000:00:13.2: port 3 low speed --> companion
[ 4649.097491] ehci_hcd 0000:00:13.2: GetStatus port 3 status 003002 POWER 
OWNER sig=se0 CSC
[ 4649.097524] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0008
[ 4649.097534] hub 5-0:1.0: state 7 ports 3 chg 0000 evt 0008
[ 4649.097545] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [2] = 
0x00010301 CSC LSDA PPS CCS
[ 4649.097554] hub 5-0:1.0: port 3, status 0301, change 0001, 1.5 Mb/s
[ 4649.217491] hub 5-0:1.0: debounce: port 3: total 100ms stable 100ms status 
0x301
[ 4649.240849] ohci_hcd 0000:00:13.0: port[2] reset timeout, stat 00000311
[ 4649.294156] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [2] = 
0x00100303 PRSC LSDA PPS PES CCS
[ 4649.347499] usb 5-3: new low speed USB device using ohci_hcd and address 2
[ 4649.370848] ohci_hcd 0000:00:13.0: port[2] reset timeout, stat 00000313
[ 4649.424156] ohci_hcd 0000:00:13.0: GetStatus roothub.portstatus [2] = 
0x00100303 PRSC LSDA PPS PES CCS
[ 4649.501243] usb 5-3: skipped 1 descriptor after interface
[ 4649.501251] usb 5-3: skipped 1 descriptor after interface
[ 4649.503247] usb 5-3: default language 0x0409
[ 4649.508251] usb 5-3: udev 2, busnum 5, minor = 513
[ 4649.508258] usb 5-3: New USB device found, idVendor=046d, idProduct=c518
[ 4649.508263] usb 5-3: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[ 4649.508268] usb 5-3: Product: USB Receiver
[ 4649.508272] usb 5-3: Manufacturer: Logitech
[ 4649.508390] usb 5-3: uevent
[ 4649.509935] usb 5-3: usb_probe_device
[ 4649.509942] usb 5-3: configuration #1 chosen from 1 choice
[ 4649.519242] usb 5-3: adding 5-3:1.0 (config #1, interface 0)
[ 4649.519302] usb 5-3:1.0: uevent
[ 4649.519422] usbhid 5-3:1.0: usb_probe_interface
[ 4649.519428] usbhid 5-3:1.0: usb_probe_interface - got id
[ 4649.526229] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:13.0/usb5/5-3/5-3:1.0/input/input5
[ 4649.526542] generic-usb 0003:046D:C518.0003: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB Receiver] on usb-0000:00:13.0-3/input0
[ 4649.526582] usb 5-3: adding 5-3:1.1 (config #1, interface 1)
[ 4649.526626] usb 5-3:1.1: uevent
[ 4649.527441] usbhid 5-3:1.1: usb_probe_interface
[ 4649.527448] usbhid 5-3:1.1: usb_probe_interface - got id
[ 4649.531694] usb 5-3:1.0: uevent
[ 4649.531865] usb 5-3: uevent
[ 4649.532064] usb 5-3:1.0: uevent
[ 4649.532234] usb 5-3: uevent
[ 4649.533871] usb 5-3:1.0: uevent
[ 4649.534280] usb 5-3:1.0: uevent
[ 4649.537474] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:13.0/usb5/5-3/5-3:1.1/input/input6
[ 4649.537553] drivers/usb/core/file.c: looking for a minor, starting at 96
[ 4649.537671] generic-usb 0003:046D:C518.0004: input,hiddev96,hidraw1: USB 
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:13.0-3/input1
[ 4649.537731] hub 5-0:1.0: state 7 ports 3 chg 0000 evt 0008
[ 4649.543613] usb 5-3:1.1: uevent
[ 4649.543769] usb 5-3: uevent
[ 4649.546227] usb 5-3:1.1: uevent
[ 4651.317487] hub 2-0:1.0: hub_suspend
[ 4651.317501] usb usb2: bus auto-suspend
[ 4651.317507] ehci_hcd 0000:00:13.2: suspend root hub

lsusb -v

Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:                                            
  bLength                18                                   
  bDescriptorType         1                                   
  bcdUSB               1.10                                   
  bDeviceClass            9 Hub                               
  bDeviceSubClass         0 Unused                            
  bDeviceProtocol         0 Full speed (or root) hub          
  bMaxPacketSize0        64                                   
  idVendor           0x1d6b Linux Foundation                  
  idProduct          0x0001 1.1 root hub                      
  bcdDevice            2.06                                   
  iManufacturer           3 Linux 2.6.31r4 ohci_hcd           
  iProduct                2 OHCI Host Controller              
  iSerial                 1 0000:00:14.5                      
  bNumConfigurations      1                                   
  Configuration Descriptor:                                   
    bLength                 9                                 
    bDescriptorType         2                                 
    wTotalLength           25                                 
    bNumInterfaces          1                                 
    bConfigurationValue     1                                 
    iConfiguration          0                                 
    bmAttributes         0xe0                                 
      Self Powered                                            
      Remote Wakeup                                           
    MaxPower                0mA                               
    Interface Descriptor:                                     
      bLength                 9                               
      bDescriptorType         4                               
      bInterfaceNumber        0                               
      bAlternateSetting       0                               
      bNumEndpoints           1                               
      bInterfaceClass         9 Hub                           
      bInterfaceSubClass      0 Unused                        
      bInterfaceProtocol      0 Full speed (or root) hub      
      iInterface              0                               
      Endpoint Descriptor:                                    
        bLength                 7                             
        bDescriptorType         5                             
        bEndpointAddress     0x81  EP 1 IN                    
        bmAttributes            3                             
          Transfer Type            Interrupt                  
          Synch Type               None                       
          Usage Type               Data                       
        wMaxPacketSize     0x0002  1x 2 bytes                 
        bInterval             255                             
Hub Descriptor:                                               
  bLength               9                                     
  bDescriptorType      41                                     
  nNbrPorts             2                                     
  wHubCharacteristic 0x0012                                   
    No power switching (usb 1.0)                              
    No overcurrent protection                                 
  bPwrOn2PwrGood        2 * 2 milli seconds                   
  bHubContrCurrent      0 milli Ampere                        
  DeviceRemovable    0x00                                     
  PortPwrCtrlMask    0xff                                     
 Hub Port Status:                                             
   Port 1: 0000.0100 power                                    
   Port 2: 0000.0100 power                                    
Device Status:     0x0003                                     
  Self Powered                                                
  Remote Wakeup Enabled                                       

Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:                                            
  bLength                18                                   
  bDescriptorType         1                                   
  bcdUSB               1.10                                   
  bDeviceClass            9 Hub                               
  bDeviceSubClass         0 Unused                            
  bDeviceProtocol         0 Full speed (or root) hub          
  bMaxPacketSize0        64                                   
  idVendor           0x1d6b Linux Foundation                  
  idProduct          0x0001 1.1 root hub                      
  bcdDevice            2.06                                   
  iManufacturer           3 Linux 2.6.31r4 ohci_hcd           
  iProduct                2 OHCI Host Controller              
  iSerial                 1 0000:00:13.1                      
  bNumConfigurations      1                                   
  Configuration Descriptor:                                   
    bLength                 9                                 
    bDescriptorType         2                                 
    wTotalLength           25                                 
    bNumInterfaces          1                                 
    bConfigurationValue     1                                 
    iConfiguration          0                                 
    bmAttributes         0xe0                                 
      Self Powered                                            
      Remote Wakeup                                           
    MaxPower                0mA                               
    Interface Descriptor:                                     
      bLength                 9                               
      bDescriptorType         4                               
      bInterfaceNumber        0                               
      bAlternateSetting       0                               
      bNumEndpoints           1                               
      bInterfaceClass         9 Hub                           
      bInterfaceSubClass      0 Unused                        
      bInterfaceProtocol      0 Full speed (or root) hub      
      iInterface              0                               
      Endpoint Descriptor:                                    
        bLength                 7                             
        bDescriptorType         5                             
        bEndpointAddress     0x81  EP 1 IN                    
        bmAttributes            3                             
          Transfer Type            Interrupt                  
          Synch Type               None                       
          Usage Type               Data                       
        wMaxPacketSize     0x0002  1x 2 bytes                 
        bInterval             255                             
Hub Descriptor:                                               
  bLength               9                                     
  bDescriptorType      41                                     
  nNbrPorts             3                                     
  wHubCharacteristic 0x0012                                   
    No power switching (usb 1.0)                              
    No overcurrent protection                                 
  bPwrOn2PwrGood        2 * 2 milli seconds                   
  bHubContrCurrent      0 milli Ampere                        
  DeviceRemovable    0x00                                     
  PortPwrCtrlMask    0xff                                     
 Hub Port Status:                                             
   Port 1: 0000.0100 power                                    
   Port 2: 0000.0100 power                                    
   Port 3: 0000.0100 power                                    
Device Status:     0x0003                                     
  Self Powered                                                
  Remote Wakeup Enabled                                       

Bus 005 Device 002: ID 046d:c518 Logitech, Inc. MX610 Laser Cordless Mouse
Device Descriptor:                                                        
  bLength                18                                               
  bDescriptorType         1                                               
  bcdUSB               2.00                                               
  bDeviceClass            0 (Defined at Interface level)                  
  bDeviceSubClass         0                                               
  bDeviceProtocol         0                                               
  bMaxPacketSize0         8                                               
  idVendor           0x046d Logitech, Inc.                                
  idProduct          0xc518 MX610 Laser Cordless Mouse                    
  bcdDevice           42.03                                               
  iManufacturer           1 Logitech                                      
  iProduct                2 USB Receiver                                  
  iSerial                 0                                               
  bNumConfigurations      1                                               
  Configuration Descriptor:                                               
    bLength                 9                                             
    bDescriptorType         2                                             
    wTotalLength           59                                             
    bNumInterfaces          2                                             
    bConfigurationValue     1                                             
    iConfiguration          4 RR42.03_B0039                               
    bmAttributes         0xa0                                             
      (Bus Powered)                                                       
      Remote Wakeup                                                       
    MaxPower               98mA                                           
    Interface Descriptor:                                                 
      bLength                 9                                           
      bDescriptorType         4                                           
      bInterfaceNumber        0                                           
      bAlternateSetting       0                                           
      bNumEndpoints           1                                           
      bInterfaceClass         3 Human Interface Device                    
      bInterfaceSubClass      1 Boot Interface Subclass                   
      bInterfaceProtocol      2 Mouse                                     
      iInterface              0                                           
      ** UNRECOGNIZED:  09 21 11 01 00 01 22 43 00                        
      Endpoint Descriptor:                                                
        bLength                 7                                         
        bDescriptorType         5                                         
        bEndpointAddress     0x81  EP 1 IN                                
        bmAttributes            3                                         
          Transfer Type            Interrupt                              
          Synch Type               None                                   
          Usage Type               Data                                   
        wMaxPacketSize     0x0008  1x 8 bytes                             
        bInterval              10                                         
    Interface Descriptor:                                                 
      bLength                 9                                           
      bDescriptorType         4                                           
      bInterfaceNumber        1                                           
      bAlternateSetting       0                                           
      bNumEndpoints           1                                           
      bInterfaceClass         3 Human Interface Device                    
      bInterfaceSubClass      0 No Subclass                               
      bInterfaceProtocol      0 None                                      
      iInterface              0                                           
      ** UNRECOGNIZED:  09 21 11 01 00 01 22 4f 00                        
      Endpoint Descriptor:                                                
        bLength                 7                                         
        bDescriptorType         5                                         
        bEndpointAddress     0x82  EP 2 IN                                
        bmAttributes            3                                         
          Transfer Type            Interrupt                              
          Synch Type               None                                   
          Usage Type               Data                                   
        wMaxPacketSize     0x0008  1x 8 bytes                             
        bInterval              10                                         
Device Status:     0x0000                                                 
  (Bus Powered)                                                           

Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:                                            
  bLength                18                                   
  bDescriptorType         1                                   
  bcdUSB               1.10                                   
  bDeviceClass            9 Hub                               
  bDeviceSubClass         0 Unused                            
  bDeviceProtocol         0 Full speed (or root) hub          
  bMaxPacketSize0        64                                   
  idVendor           0x1d6b Linux Foundation                  
  idProduct          0x0001 1.1 root hub                      
  bcdDevice            2.06                                   
  iManufacturer           3 Linux 2.6.31r4 ohci_hcd           
  iProduct                2 OHCI Host Controller              
  iSerial                 1 0000:00:13.0                      
  bNumConfigurations      1                                   
  Configuration Descriptor:                                   
    bLength                 9                                 
    bDescriptorType         2                                 
    wTotalLength           25                                 
    bNumInterfaces          1                                 
    bConfigurationValue     1                                 
    iConfiguration          0                                 
    bmAttributes         0xe0                                 
      Self Powered                                            
      Remote Wakeup                                           
    MaxPower                0mA                               
    Interface Descriptor:                                     
      bLength                 9                               
      bDescriptorType         4                               
      bInterfaceNumber        0                               
      bAlternateSetting       0                               
      bNumEndpoints           1                               
      bInterfaceClass         9 Hub                           
      bInterfaceSubClass      0 Unused                        
      bInterfaceProtocol      0 Full speed (or root) hub      
      iInterface              0                               
      Endpoint Descriptor:                                    
        bLength                 7                             
        bDescriptorType         5                             
        bEndpointAddress     0x81  EP 1 IN                    
        bmAttributes            3                             
          Transfer Type            Interrupt                  
          Synch Type               None                       
          Usage Type               Data                       
        wMaxPacketSize     0x0002  1x 2 bytes                 
        bInterval             255                             
Hub Descriptor:                                               
  bLength               9                                     
  bDescriptorType      41                                     
  nNbrPorts             3                                     
  wHubCharacteristic 0x0012                                   
    No power switching (usb 1.0)                              
    No overcurrent protection                                 
  bPwrOn2PwrGood        2 * 2 milli seconds                   
  bHubContrCurrent      0 milli Ampere                        
  DeviceRemovable    0x00                                     
  PortPwrCtrlMask    0xff                                     
 Hub Port Status:                                             
   Port 1: 0000.0100 power                                    
   Port 2: 0000.0100 power                                    
   Port 3: 0000.0303 lowspeed power enable connect            
Device Status:     0x0003                                     
  Self Powered                                                
  Remote Wakeup Enabled                                       

Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:                                            
  bLength                18                                   
  bDescriptorType         1                                   
  bcdUSB               1.10                                   
  bDeviceClass            9 Hub                               
  bDeviceSubClass         0 Unused                            
  bDeviceProtocol         0 Full speed (or root) hub          
  bMaxPacketSize0        64                                   
  idVendor           0x1d6b Linux Foundation                  
  idProduct          0x0001 1.1 root hub                      
  bcdDevice            2.06                                   
  iManufacturer           3 Linux 2.6.31r4 ohci_hcd           
  iProduct                2 OHCI Host Controller              
  iSerial                 1 0000:00:12.1                      
  bNumConfigurations      1                                   
  Configuration Descriptor:                                   
    bLength                 9                                 
    bDescriptorType         2                                 
    wTotalLength           25                                 
    bNumInterfaces          1                                 
    bConfigurationValue     1                                 
    iConfiguration          0                                 
    bmAttributes         0xe0                                 
      Self Powered                                            
      Remote Wakeup                                           
    MaxPower                0mA                               
    Interface Descriptor:                                     
      bLength                 9                               
      bDescriptorType         4                               
      bInterfaceNumber        0                               
      bAlternateSetting       0                               
      bNumEndpoints           1                               
      bInterfaceClass         9 Hub                           
      bInterfaceSubClass      0 Unused                        
      bInterfaceProtocol      0 Full speed (or root) hub      
      iInterface              0                               
      Endpoint Descriptor:                                    
        bLength                 7                             
        bDescriptorType         5                             
        bEndpointAddress     0x81  EP 1 IN                    
        bmAttributes            3                             
          Transfer Type            Interrupt                  
          Synch Type               None                       
          Usage Type               Data                       
        wMaxPacketSize     0x0002  1x 2 bytes                 
        bInterval             255                             
Hub Descriptor:                                               
  bLength               9                                     
  bDescriptorType      41                                     
  nNbrPorts             3                                     
  wHubCharacteristic 0x0012                                   
    No power switching (usb 1.0)                              
    No overcurrent protection                                 
  bPwrOn2PwrGood        2 * 2 milli seconds                   
  bHubContrCurrent      0 milli Ampere                        
  DeviceRemovable    0x00                                     
  PortPwrCtrlMask    0xff                                     
 Hub Port Status:                                             
   Port 1: 0000.0100 power                                    
   Port 2: 0000.0100 power                                    
   Port 3: 0000.0100 power                                    
Device Status:     0x0003                                     
  Self Powered                                                
  Remote Wakeup Enabled                                       

Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Device Descriptor:                                            
  bLength                18                                   
  bDescriptorType         1                                   
  bcdUSB               1.10                                   
  bDeviceClass            9 Hub                               
  bDeviceSubClass         0 Unused                            
  bDeviceProtocol         0 Full speed (or root) hub          
  bMaxPacketSize0        64                                   
  idVendor           0x1d6b Linux Foundation                  
  idProduct          0x0001 1.1 root hub                      
  bcdDevice            2.06                                   
  iManufacturer           3 Linux 2.6.31r4 ohci_hcd           
  iProduct                2 OHCI Host Controller              
  iSerial                 1 0000:00:12.0                      
  bNumConfigurations      1                                   
  Configuration Descriptor:                                   
    bLength                 9                                 
    bDescriptorType         2                                 
    wTotalLength           25                                 
    bNumInterfaces          1                                 
    bConfigurationValue     1                                 
    iConfiguration          0                                 
    bmAttributes         0xe0                                 
      Self Powered                                            
      Remote Wakeup                                           
    MaxPower                0mA                               
    Interface Descriptor:                                     
      bLength                 9                               
      bDescriptorType         4                               
      bInterfaceNumber        0                               
      bAlternateSetting       0                               
      bNumEndpoints           1                               
      bInterfaceClass         9 Hub                           
      bInterfaceSubClass      0 Unused                        
      bInterfaceProtocol      0 Full speed (or root) hub      
      iInterface              0                               
      Endpoint Descriptor:                                    
        bLength                 7                             
        bDescriptorType         5                             
        bEndpointAddress     0x81  EP 1 IN                    
        bmAttributes            3                             
          Transfer Type            Interrupt                  
          Synch Type               None                       
          Usage Type               Data                       
        wMaxPacketSize     0x0002  1x 2 bytes                 
        bInterval             255                             
Hub Descriptor:                                               
  bLength               9                                     
  bDescriptorType      41                                     
  nNbrPorts             3                                     
  wHubCharacteristic 0x0012                                   
    No power switching (usb 1.0)                              
    No overcurrent protection                                 
  bPwrOn2PwrGood        2 * 2 milli seconds                   
  bHubContrCurrent      0 milli Ampere                        
  DeviceRemovable    0x00                                     
  PortPwrCtrlMask    0xff                                     
 Hub Port Status:                                             
   Port 1: 0000.0100 power                                    
   Port 2: 0000.0100 power                                    
   Port 3: 0000.0100 power                                    
Device Status:     0x0003                                     
  Self Powered                                                
  Remote Wakeup Enabled                                       

Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:                                            
  bLength                18                                   
  bDescriptorType         1                                   
  bcdUSB               2.00                                   
  bDeviceClass            9 Hub                               
  bDeviceSubClass         0 Unused                            
  bDeviceProtocol         0 Full speed (or root) hub          
  bMaxPacketSize0        64                                   
  idVendor           0x1d6b Linux Foundation                  
  idProduct          0x0002 2.0 root hub                      
  bcdDevice            2.06                                   
  iManufacturer           3 Linux 2.6.31r4 ehci_hcd           
  iProduct                2 EHCI Host Controller              
  iSerial                 1 0000:00:13.2                      
  bNumConfigurations      1                                   
  Configuration Descriptor:                                   
    bLength                 9                                 
    bDescriptorType         2                                 
    wTotalLength           25                                 
    bNumInterfaces          1                                 
    bConfigurationValue     1                                 
    iConfiguration          0                                 
    bmAttributes         0xe0                                 
      Self Powered                                            
      Remote Wakeup                                           
    MaxPower                0mA                               
    Interface Descriptor:                                     
      bLength                 9                               
      bDescriptorType         4                               
      bInterfaceNumber        0                               
      bAlternateSetting       0                               
      bNumEndpoints           1                               
      bInterfaceClass         9 Hub                           
      bInterfaceSubClass      0 Unused                        
      bInterfaceProtocol      0 Full speed (or root) hub      
      iInterface              0                               
      Endpoint Descriptor:                                    
        bLength                 7                             
        bDescriptorType         5                             
        bEndpointAddress     0x81  EP 1 IN                    
        bmAttributes            3                             
          Transfer Type            Interrupt                  
          Synch Type               None                       
          Usage Type               Data                       
        wMaxPacketSize     0x0004  1x 4 bytes                 
        bInterval              12                             
Hub Descriptor:                                               
  bLength               9                                     
  bDescriptorType      41                                     
  nNbrPorts             6                                     
  wHubCharacteristic 0x000a                                   
    No power switching (usb 1.0)                              
    Per-port overcurrent protection                           
  bPwrOn2PwrGood       10 * 2 milli seconds                   
  bHubContrCurrent      0 milli Ampere                        
  DeviceRemovable    0x00                                     
  PortPwrCtrlMask    0xff                                     
 Hub Port Status:                                             
   Port 1: 0000.0100 power                                    
   Port 2: 0000.0100 power                                    
   Port 3: 0000.0100 power                                    
   Port 4: 0000.0100 power                                    
   Port 5: 0000.0100 power                                    
   Port 6: 0000.0100 power                                    
Device Status:     0x0003                                     
  Self Powered                                                
  Remote Wakeup Enabled                                       

Bus 001 Device 002: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Device Descriptor:                                                     
  bLength                18                                            
  bDescriptorType         1                                            
  bcdUSB               2.00                                            
  bDeviceClass            9 Hub                                        
  bDeviceSubClass         0 Unused                                     
  bDeviceProtocol         1 Single TT                                  
  bMaxPacketSize0        64                                            
  idVendor           0x05e3 Genesys Logic, Inc.                        
  idProduct          0x0608 USB-2.0 4-Port HUB                         
  bcdDevice            7.02                                            
  iManufacturer           0                                            
  iProduct                1 USB2.0 Hub                                 
  iSerial                 0                                            
  bNumConfigurations      1                                            
  Configuration Descriptor:                                            
    bLength                 9                                          
    bDescriptorType         2                                          
    wTotalLength           25                                          
    bNumInterfaces          1                                          
    bConfigurationValue     1                                          
    iConfiguration          0                                          
    bmAttributes         0xe0                                          
      Self Powered                                                     
      Remote Wakeup                                                    
    MaxPower              100mA                                        
    Interface Descriptor:                                              
      bLength                 9                                        
      bDescriptorType         4                                        
      bInterfaceNumber        0                                        
      bAlternateSetting       0                                        
      bNumEndpoints           1                                        
      bInterfaceClass         9 Hub                                    
      bInterfaceSubClass      0 Unused                                 
      bInterfaceProtocol      0 Full speed (or root) hub               
      iInterface              0                                        
      Endpoint Descriptor:                                             
        bLength                 7                                      
        bDescriptorType         5                                      
        bEndpointAddress     0x81  EP 1 IN                             
        bmAttributes            3                                      
          Transfer Type            Interrupt                           
          Synch Type               None                                
          Usage Type               Data                                
        wMaxPacketSize     0x0001  1x 1 bytes                          
        bInterval              12                                      
Hub Descriptor:                                                        
  bLength               9                                              
  bDescriptorType      41                                              
  nNbrPorts             4                                              
  wHubCharacteristic 0x00e9                                            
    Per-port power switching                                           
    Per-port overcurrent protection                                    
    TT think time 32 FS bits                                           
    Port indicators                                                    
  bPwrOn2PwrGood       50 * 2 milli seconds                            
  bHubContrCurrent    100 milli Ampere                                 
  DeviceRemovable    0x00                                              
  PortPwrCtrlMask    0xff                                              
 Hub Port Status:                                                      
   Port 1: 0000.0100 power                                             
   Port 2: 0000.0100 power                                             
   Port 3: 0000.0100 power                                             
   Port 4: 0000.0100 power                                             
Device Qualifier (for other device speed):                             
  bLength                10                                            
  bDescriptorType         6                                            
  bcdUSB               2.00                                            
  bDeviceClass            9 Hub                                        
  bDeviceSubClass         0 Unused                                     
  bDeviceProtocol         0 Full speed (or root) hub                   
  bMaxPacketSize0        64                                            
  bNumConfigurations      1                                            
Device Status:     0x0001                                              
  Self Powered                                                         

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:                                            
  bLength                18                                   
  bDescriptorType         1                                   
  bcdUSB               2.00                                   
  bDeviceClass            9 Hub                               
  bDeviceSubClass         0 Unused                            
  bDeviceProtocol         0 Full speed (or root) hub          
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.31r4 ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:12.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0503 highspeed power enable connect
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled


about usbmon - what do you want? There 

ls -lh /sys/kernel/debug/usb/usbmon
insgesamt 0
-rw------- 1 root root 0 16. Sep 2009  0s
-rw------- 1 root root 0 16. Sep 2009  0u
-rw------- 1 root root 0 16. Sep 15:38 1s
-rw------- 1 root root 0 16. Sep 15:38 1t
-rw------- 1 root root 0 16. Sep 15:38 1u
-rw------- 1 root root 0 16. Sep 15:38 2s
-rw------- 1 root root 0 16. Sep 15:38 2t
-rw------- 1 root root 0 16. Sep 15:38 2u
-rw------- 1 root root 0 16. Sep 16:55 3s
-rw------- 1 root root 0 16. Sep 16:55 3t
-rw------- 1 root root 0 16. Sep 16:55 3u
-rw------- 1 root root 0 16. Sep 16:55 4s
-rw------- 1 root root 0 16. Sep 16:55 4t
-rw------- 1 root root 0 16. Sep 16:55 4u
-rw------- 1 root root 0 16. Sep 16:55 5s
-rw------- 1 root root 0 16. Sep 16:55 5t
-rw------- 1 root root 0 16. Sep 16:55 5u
-rw------- 1 root root 0 16. Sep 16:55 6s
-rw------- 1 root root 0 16. Sep 16:55 6t
-rw------- 1 root root 0 16. Sep 16:55 6u
-rw------- 1 root root 0 16. Sep 16:55 7s
-rw------- 1 root root 0 16. Sep 16:55 7t
-rw------- 1 root root 0 16. Sep 16:55 7u

these files. 5 is related to the mouse?

Glück Auf,
Volker
