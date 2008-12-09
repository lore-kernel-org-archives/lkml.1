Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYLISnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYLISnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYLISnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:43:03 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44582 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754026AbYLISnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:43:00 -0500
Date: Tue, 9 Dec 2008 13:43:00 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>,
       Ian Jackson <Ian.Jackson@eu.citrix.com>
Subject: Re: Oops in UHCI when encountering "host controller process error"
In-Reply-To: <493EB7EF.7040309@goop.org>
Message-ID: <Pine.LNX.4.44L0.0812091341210.2178-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008, Jeremy Fitzhardinge wrote:

> Yep, there's something very odd going on in there.  By contrast, does 
> this look OK?  The allocations are fine, but I'm wondering if the 
> skeleton QH stuff is all correct; it seems to work OK in this state.
> 
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4000 handle=7e212000
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4080 handle=7e212080
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4100 handle=7e212100
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4180 handle=7e212180
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4200 handle=7e212200
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4280 handle=7e212280
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4300 handle=7e212300
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4380 handle=7e212380
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4400 handle=7e212400
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4480 handle=7e212480
> uhci_alloc_qh: uhci=ffff88002e5de3d0 qh=ffff88002e5f4500 handle=7e212500
> Root-hub state: reset   FSBR: 0
> HC status
>   usbcmd    =     0000   Maxp32 
>   usbstat   =     0020   HCHalted 
>   usbint    =     0000
>   usbfrnum  =   (0)000
>   flbaseadd = 7ffd5000
>   sof       =       40
>   stat1     =     0080  
>   stat2     =     0080  
> Most recent frame: 0 (0)   Last ISO frame: 0 (0)
> Periodic load table
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
> Total: 0, #INT: 0, #ISO: 0
> Frame List
> Skeleton QHs
> - skel_unlink_qh
>     [ffff88002e5f4000] Skel QH link (00000001) element (00000001)
>       queue is empty
> - skel_iso_qh
>     [ffff88002e5f4080] Skel QH link (00000001) element (00000001)
>       queue is empty
> - skel_int128_qh
>     [ffff88002e5f4100] Skel QH link (7e212482) element (00000001)
>       queue is empty
> - skel_int64_qh
>     [ffff88002e5f4180] Skel QH link (7e212482) element (00000001)
>       queue is empty
> - skel_int32_qh
>     [ffff88002e5f4200] Skel QH link (7e212482) element (00000001)
>       queue is empty
> - skel_int16_qh
>     [ffff88002e5f4280] Skel QH link (7e212482) element (00000001)
>       queue is empty
> - skel_int8_qh
>     [ffff88002e5f4300] Skel QH link (7e212482) element (00000001)
>       queue is empty
> - skel_int4_qh
>     [ffff88002e5f4380] Skel QH link (7e212482) element (00000001)
>       queue is empty
> - skel_int2_qh
>     [ffff88002e5f4400] Skel QH link (7e212482) element (00000001)
>       queue is empty
> - skel_async_qh
>     [ffff88002e5f4480] Skel QH link (00000001) element (7e215000)
>       queue is empty
> [ffff88002e5f3000] link (00000001) e0 Length=0 MaxLen=7ff DT0 EndPt=0 Dev=7f, PID=69(IN) (buf=00000000)
> - skel_term_qh
>     [ffff88002e5f4500] Skel QH link (7e212502) element (7e215000)
>       queue is empty

Yes, that looks normal for a controller with no activity.

Alan Stern

