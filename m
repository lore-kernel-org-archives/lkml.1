Return-Path: <linux-kernel-owner+w=401wt.eu-S1761103AbZGIOUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761103AbZGIOUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760742AbZGIOUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:20:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52060 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760601AbZGIOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:20:29 -0400
Date: Thu, 9 Jul 2009 10:20:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907081856.12191.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907091019010.5823-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009, Michael S. Zick wrote:

> > > > > For more information enable CONFIG_USB_DEBUG and CONFIG_DEBUG_FS, then 
> > > > > see what's sitting in the usb/uhci/* files in debugfs.
> > > > > 
> > > 
> > > Anything in particular to look for/at?
> > 
> > Just post the contents of those files.
> >
> Done:
> 
> root@cb01:/sys/kernel/debug/uhci# cat *
> Root-hub state: suspended   FSBR: 0
> HC status
>   usbcmd    =     0048   Maxp32 CF EGSM
>   usbstat   =     0020   HCHalted
>   usbint    =     0002
>   usbfrnum  =   (1)4a8
>   flbaseadd = 19c7f000
>   sof       =       40
>   stat1     =     0480   OverCurrent
>   stat2     =     0480   OverCurrent
> Most recent frame: 52a (298)   Last ISO frame: 52a (298)
> Periodic load table
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
> Total: 0, #INT: 0, #ISO: 0
> Root-hub state: suspended   FSBR: 0
> HC status
>   usbcmd    =     0048   Maxp32 CF EGSM
>   usbstat   =     0020   HCHalted
>   usbint    =     0002
>   usbfrnum  =   (1)4a0
>   flbaseadd = 19c63000
>   sof       =       40
>   stat1     =     0480   OverCurrent
>   stat2     =     0480   OverCurrent
> Most recent frame: 528 (296)   Last ISO frame: 528 (296)
> Periodic load table
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
> Total: 0, #INT: 0, #ISO: 0
> Root-hub state: running   FSBR: 0
> HC status
>   usbcmd    =     00c1   Maxp64 CF RS
>   usbstat   =     0000
>   usbint    =     000f
>   usbfrnum  =   (0)c1c
>   flbaseadd = 19c9c000
>   sof       =       40
>   stat1     =     0495   OverCurrent Enabled Connected
>   stat2     =     0495   OverCurrent Enabled Connected
> Most recent frame: 56aee (750)   Last ISO frame: 56aee (750)
> Periodic load table
>         0       0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
>         17      0       0       0       0       0       0       0
>         0       0       0       0       0       0       0       0
> Total: 17, #INT: 1, #ISO: 0
> 
> And, at no extra cost:
> 
> root@cb01:/sys/kernel/debug/ehci/0000:00:10.4# cat *
> size = 256
> bus pci, device 0000:00:10.4
> EHCI Host Controller
> EHCI 1.00, hcd state 4
> ownership 01000001 linux
> SMI sts/enable 0xe00f0000
> structural params 0x00103206
> capability params 0x00006872
> status 100f Halt FLR PCD ERR INT
> command 010008 (park)=0 ithresh=1 period=256 HALT
> intrenable 37 IAA FATAL PCD ERR INT
> uframe 14db
> port 1 status 701000 POWER sig=se0
> port 2 status 701000 POWER sig=se0
> port 3 status 701000 POWER sig=se0
> port 4 status 701000 POWER sig=se0
> port 5 status 703802 POWER OWNER sig=j CSC
> port 6 status 703802 POWER OWNER sig=j CSC
> irq normal 0 err 0 reclaim 0 (lost 20)
> complete 0 unlink 20

Those files all look perfectly normal.  You made these copies at a time 
when everything was working, right?  It will be more interesting to see 
them at a time when something isn't working.

Alan Stern

