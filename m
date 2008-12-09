Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYLISZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYLISZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYLISYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:24:51 -0500
Received: from gw.goop.org ([64.81.55.164]:44256 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706AbYLISYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:24:50 -0500
Message-ID: <493EB7EF.7040309@goop.org>
Date: Tue, 09 Dec 2008 10:24:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       Ian Jackson <Ian.Jackson@eu.citrix.com>
Subject: Re: Oops in UHCI when encountering "host controller process error"
References: <Pine.LNX.4.44L0.0812082105170.30007-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0812082105170.30007-100000@netrider.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> The hardware starts running right at the end of uhci_start(), in the
> call to start_rh().  However according to those debugging lines you
> added to uhci_alloc_qh(), the DMA pool allocations are all messed up.  
> Those initial allocations all occur within uhci_start(), in the
>
> 	for (i = 0; i < UHCI_NUM_SKELQH; ++i)
>
> loop.  It sure looks like the DMA pool memory management needs 
> attention.
>
>   

Yep, there's something very odd going on in there.  By contrast, does 
this look OK?  The allocations are fine, but I'm wondering if the 
skeleton QH stuff is all correct; it seems to work OK in this state.

uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4000 handle=7e212000
uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4080 handle=7e212080
uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4100 handle=7e212100
uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4180 handle=7e212180
uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4200 handle=7e212200
uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4280 handle=7e212280
uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4300 handle=7e212300
uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4380 handle=7e212380
uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4400 handle=7e212400
uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4480 handle=7e212480
uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4500 handle=7e212500
Root-hub state: reset   FSBR: 0
HC status
  usbcmd    =     0000   Maxp32 
  usbstat   =     0020   HCHalted 
  usbint    =     0000
  usbfrnum  =   (0)000
  flbaseadd = 7ffd5000
  sof       =       40
  stat1     =     0080  
  stat2     =     0080  
Most recent frame: 0 (0)   Last ISO frame: 0 (0)
Periodic load table
        0       0       0       0       0       0       0       0
        0       0       0       0       0       0       0       0
        0       0       0       0       0       0       0       0
        0       0       0       0       0       0       0       0
Total: 0, #INT: 0, #ISO: 0
Frame List
Skeleton QHs
- skel_unlink_qh
    [ffff88002e5f4000] Skel QH link (00000001) element (00000001)
      queue is empty
- skel_iso_qh
    [ffff88002e5f4080] Skel QH link (00000001) element (00000001)
      queue is empty
- skel_int128_qh
    [ffff88002e5f4100] Skel QH link (7e212482) element (00000001)
      queue is empty
- skel_int64_qh
    [ffff88002e5f4180] Skel QH link (7e212482) element (00000001)
      queue is empty
- skel_int32_qh
    [ffff88002e5f4200] Skel QH link (7e212482) element (00000001)
      queue is empty
- skel_int16_qh
    [ffff88002e5f4280] Skel QH link (7e212482) element (00000001)
      queue is empty
- skel_int8_qh
    [ffff88002e5f4300] Skel QH link (7e212482) element (00000001)
      queue is empty
- skel_int4_qh
    [ffff88002e5f4380] Skel QH link (7e212482) element (00000001)
      queue is empty
- skel_int2_qh
    [ffff88002e5f4400] Skel QH link (7e212482) element (00000001)
      queue is empty
- skel_async_qh
    [ffff88002e5f4480] Skel QH link (00000001) element (7e215000)
      queue is empty
[ffff88002e5f3000] link (00000001) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=7f, PID=69(IN) (buf=00000000)
- skel_term_qh
    [ffff88002e5f4500] Skel QH link (7e212502) element (7e215000)
      queue is empty


Thanks,
    J
