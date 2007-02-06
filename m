Return-Path: <linux-kernel-owner+w=401wt.eu-S965464AbXBFCoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965464AbXBFCoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 21:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965468AbXBFCoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 21:44:37 -0500
Received: from mf2.realtek.com.tw ([60.248.182.6]:4445 "EHLO
	mf2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965464AbXBFCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 21:44:36 -0500
Message-ID: <45C7EB8A.1090700@realtek.com.tw>
Date: Tue, 06 Feb 2007 10:44:26 +0800
From: =?Big5?B?s1yr7bnF?= <edward_hsu@realtek.com.tw>
User-Agent: Mozilla Thunderbird 1.0.2 (Windows/20050317)
X-Accept-Language: zh-tw, en-us, en, zh
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org, hiwu@realtek.com.tw
Subject: Re: [PATCH 2.6.19.2] r8169: support RTL8169SC/8110SC
References: <45C2F390.4070805@realtek.com.tw> <20070203003952.GA22823@electric-eye.fr.zoreil.com> <45C6A8EC.5090201@realtek.com.tw> <20070206003130.GA18236@electric-eye.fr.zoreil.com>
In-Reply-To: <20070206003130.GA18236@electric-eye.fr.zoreil.com>
X-MIMETrack: Itemize by SMTP Server on msx/Realtek(Release 6.5.3|September 14, 2004) at
 2007/02/06 =?Bog5?B?pFekyCAxMDo0NDoyNg==?=,
	Serialize by Router on msx/Realtek(Release 6.5.3|September 14, 2004) at
 2007/02/06 =?Bog5?B?pFekyCAxMDo0NDoyOA==?=,
	Serialize complete at 2007/02/06 =?Bog5?B?pFekyCAxMDo0NDoyOA==?=
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=Big5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Francois:

Thanks for your reply. I gave my idea about your questions with the the
key word "ANS_2".

If you have further questions, please raise them.

Best Regards,
Edward 2007/02/06

Francois Romieu ´£¨ì:

>³\«í¹Å <edward_hsu@realtek.com.tw> :
>[...]
>  
>
>>>>static struct pci_device_id rtl8169_pci_tbl[] = {
>>>>- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8129), 0, 0, RTL_CFG_0 },
>>>>- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8136), 0, 0, RTL_CFG_2 },
>>>>- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8167), 0, 0, RTL_CFG_0 },
>>>>- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8168), 0, 0, RTL_CFG_2 },
>>>>- { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8169), 0, 0, RTL_CFG_0 },
>>>>- { PCI_DEVICE(PCI_VENDOR_ID_DLINK, 0x4300), 0, 0, RTL_CFG_0 },
>>>>- { PCI_DEVICE(0x1259, 0xc107), 0, 0, RTL_CFG_0 },
>>>>- { PCI_DEVICE(0x16ec, 0x0116), 0, 0, RTL_CFG_0 },
>>>>- { PCI_VENDOR_ID_LINKSYS, 0x1032,
>>>>- PCI_ANY_ID, 0x0024, 0, 0, RTL_CFG_0 },
>>>>+ { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8169), },
>>>>+ { PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8167), },
>>>>  
>>>>
>>>>        
>>>>
>>>The current driver is intended to handle the whole set of PCI IDs
>>>which would be removed by the patch. Thoug some combination of
>>>chipset and motherboard do not work as expected, the gigabit
>>>chipsets have been reported to work.
>>>
>>>Please elaborate if there is a good reason to remove any ID.
>>>
>>>
>>>      
>>>
>>ANS:
>>I have explained my point about this in last question. This driver is 
>>developed for Realtek PCI gigabit ethernet controllers. Although some 
>>vendors may use Realtek solutions with their own PCI DIDs and VIDs, they 
>>should customize this driver and maintained the customized driver on 
>>their own.
>>    
>>
>
>Vendors will change the PCI ID because they like to see their name in
>the nifty hardware GUI under Windows. The brave ones will mess with the
>VPD (before or after they vandalize the ACPI tables, at their option).
>Eventually they will copy an outdated version of your driver on their site
>with the updated ID. Given the tight margin on these kind of mass-volume
>product, I would not expect vendors to do more for their customers who
>use Linux.
>  
>
ANS_2:
So, do you think that it is a good idea to keep other vendos's PID and
DID in the part?

>If your hardware changes significantly, it may make sense to use a new,
>different driver. Otherwise, as long as the changes are minor, a single
>in-kernel driver which works out of the box for most users/vendors offers
>the best coverage. It should not be neglected.
>
>So far, I have only seen minor differences between r8101-1.001.00,
>r8168-8.001.00 and r8169-6.001.00. The mac init sequence is not pretty
>to unify but the drivers stay mostly the same. There even is a floating
>patch for MSI support which seems manageable within a single driver.
>
>Of course it depends a lot on the kind of changes that you envision for
>the driver(s).
>  
>

ANS_2:

Sure! You are right. RTL8110SC, RTL8111B and RTL8101E have modest
differences, now. However, RTL8101E is a PCI-E fast ethernet controller.
I don't think is a good idea to merge its Linux driver into r8168.c or
r8169.c. RTL8110SC is the final version of Realtek PCI gigabit ethernet
controller. Moreover, due to the increasing popularity of PCI-E, Realtek
is going to design several generations of PCI-E ethernet controllers to
satisfy customer requests. I have discussed this issue with my hardware
colleagues. They believe that both MAC register layout and tx/rx
descriptor layout will be changed a lot in new PCI-E ICs. Actually, they
already did. Therefore, the hardwares of RTL8111B(PCI-E gigabit
ethernet) and RTL8101E(PCI-E fast ethernet) will have frequent and
drastic changes. So, I think that it's a good moment to separate their
Linux drivers, and r8169.c can become stable.

>[...]
>  
>
>>>>RxMaxSize = 0xDA,
>>>>CPlusCmd = 0xE0,
>>>>IntrMitigate = 0xE2,
>>>>@@ -287,11 +291,10 @@ enum RTL8169_register_content {
>>>>RxOK = 0x01,
>>>>
>>>>/* RxStatusDesc */
>>>>- RxFOVF = (1 << 23),
>>>>- RxRWT = (1 << 22),
>>>>- RxRES = (1 << 21),
>>>>- RxRUNT = (1 << 20),
>>>>- RxCRC = (1 << 19),
>>>>+ RxRES = 0x00200000,
>>>>+ RxCRC = 0x00080000,
>>>>+ RxRUNT = 0x00100000,
>>>>+ RxRWT = 0x00400000,
>>>>  
>>>>
>>>>        
>>>>
>>>This part removes RxFOVF. Please elaborate if there is a reason
>>>to do so.
>>>
>>>
>>>      
>>>
>>ANS:
>>According to the spec of RTL8110SC, bit 23 and bit 24 are reserved in 
>>the 1st double word of rx status descriptor. Therefore, I delete it.
>>    
>>
>
>  
>

ANS_2:
I have the specs of RTL8110S/SB/SC. According those specs, the two bits are reserved. Since I didn't create this driver, I don't know who wrote it. I think they are not used.

>The bits are fine for the old Gigabit 8169 though, aren't they ?
>
>[...]
>  
>
>>>Two points here:
>>>1. the driver uniformly uses u{8/16/32} types. Please follow the current
>>> style and avoid to add uint{8/16/32}_t things.
>>>2. does this new field bring something that struct net_device.dev_addr
>>> does not ?
>>>
>>>
>>>
>>>      
>>>
>>ANS:
>>I reference the source code of e1000.c, which is currently existing in 
>>Linux kernel. I think it uses u{8/16/32} and the new field.
>>    
>>
>
>The e1000 driver has an interesting history. It is strongly suggested
>to ponder several drivers to figure some good practices. Please see for
>instance tg3.c, b44.c, sky2.c or any recent driver in drivers/net.
>
>  
>

ANS_2:
Thanks for your suggestion. I will see those drivers that you suggest. And revise my driver.

