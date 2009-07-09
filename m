Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbZGIOr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbZGIOr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761082AbZGIOrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:47:06 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:49508 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761586AbZGIOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:47:03 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Thu, 9 Jul 2009 09:46:56 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907091019010.5823-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0907091019010.5823-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907090946.59055.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu July 9 2009, Alan Stern wrote:
> On Wed, 8 Jul 2009, Michael S. Zick wrote:
> 
> > > > > > For more information enable CONFIG_USB_DEBUG and CONFIG_DEBUG_FS, then 
> > > > > > see what's sitting in the usb/uhci/* files in debugfs.
> > > > > > 
> > > > 
> > > > Anything in particular to look for/at?
> > > 
> > > Just post the contents of those files.
> > >
> > Done:
> > 
> > root@cb01:/sys/kernel/debug/uhci# cat *
> > Root-hub state: suspended   FSBR: 0
> > HC status
> >   usbcmd    =     0048   Maxp32 CF EGSM
> >   usbstat   =     0020   HCHalted
> >   usbint    =     0002
> >   usbfrnum  =   (1)4a8
> >   flbaseadd = 19c7f000
> >   sof       =       40
> >   stat1     =     0480   OverCurrent
> >   stat2     =     0480   OverCurrent
> > Most recent frame: 52a (298)   Last ISO frame: 52a (298)
> > Periodic load table
> >         0       0       0       0       0       0       0       0
> >         0       0       0       0       0       0       0       0
> >         0       0       0       0       0       0       0       0
> >         0       0       0       0       0       0       0       0
> > Total: 0, #INT: 0, #ISO: 0
> > Root-hub state: suspended   FSBR: 0
> > HC status
> >   usbcmd    =     0048   Maxp32 CF EGSM
> >   usbstat   =     0020   HCHalted
> >   usbint    =     0002
> >   usbfrnum  =   (1)4a0
> >   flbaseadd = 19c63000
> >   sof       =       40
> >   stat1     =     0480   OverCurrent
> >   stat2     =     0480   OverCurrent
> > Most recent frame: 528 (296)   Last ISO frame: 528 (296)
> > Periodic load table
> >         0       0       0       0       0       0       0       0
> >         0       0       0       0       0       0       0       0
> >         0       0       0       0       0       0       0       0
> >         0       0       0       0       0       0       0       0
> > Total: 0, #INT: 0, #ISO: 0
> > Root-hub state: running   FSBR: 0
> > HC status
> >   usbcmd    =     00c1   Maxp64 CF RS
> >   usbstat   =     0000
> >   usbint    =     000f
> >   usbfrnum  =   (0)c1c
> >   flbaseadd = 19c9c000
> >   sof       =       40
> >   stat1     =     0495   OverCurrent Enabled Connected
> >   stat2     =     0495   OverCurrent Enabled Connected
> > Most recent frame: 56aee (750)   Last ISO frame: 56aee (750)
> > Periodic load table
> >         0       0       0       0       0       0       0       0
> >         0       0       0       0       0       0       0       0
> >         17      0       0       0       0       0       0       0
> >         0       0       0       0       0       0       0       0
> > Total: 17, #INT: 1, #ISO: 0
> > 
> > And, at no extra cost:
> > 
> > root@cb01:/sys/kernel/debug/ehci/0000:00:10.4# cat *
> > size = 256
> > bus pci, device 0000:00:10.4
> > EHCI Host Controller
> > EHCI 1.00, hcd state 4
> > ownership 01000001 linux
> > SMI sts/enable 0xe00f0000
> > structural params 0x00103206
> > capability params 0x00006872
> > status 100f Halt FLR PCD ERR INT
> > command 010008 (park)=0 ithresh=1 period=256 HALT
> > intrenable 37 IAA FATAL PCD ERR INT
> > uframe 14db
> > port 1 status 701000 POWER sig=se0
> > port 2 status 701000 POWER sig=se0
> > port 3 status 701000 POWER sig=se0
> > port 4 status 701000 POWER sig=se0
> > port 5 status 703802 POWER OWNER sig=j CSC
> > port 6 status 703802 POWER OWNER sig=j CSC
> > irq normal 0 err 0 reclaim 0 (lost 20)
> > complete 0 unlink 20
> 
> Those files all look perfectly normal.  You made these copies at a time 
> when everything was working, right?  It will be more interesting to see 
> them at a time when something isn't working.
>

First data point posted only - that was: "with patched driver" vs "no driver" -
Note what problems are outside of this investigation.

In case you missed it - this is the CX700 integrated chipset in a NetBook.
No all USB devices are removable in the sense of being physically impossible.

The documentation for the CX700 has been released from NDA and is available
at the VIA Linux portal - just in case you don't already have your copy.

More testing today - including trying some of the many kernel options available
for dealing with funky irq, bios, and acpi implementations.

On the subject of irq's:

root@cb01:~# biosdecode
# biosdecode 2.9
SMBIOS 2.4 present.
        Structure Table Length: 1556 bytes
        Structure Table Address: 0x000DC010
        Number Of Structures: 47
        Maximum Structure Size: 119 bytes
BIOS32 Service Directory present.
        Revision: 0
        Calling Interface Address: 0x000FDD64
ACPI 1.0 present.
        OEM Identifier: PTLTD
        RSD Table 32-bit Address: 0x1BEE5663
PNP BIOS 1.0 present.
        Event Notification: Not Supported
        Real Mode 16-bit Code Address: E923:768E
        Real Mode 16-bit Data Address: 0040:0000
        16-bit Protected Mode Code Address: 0x00015FCF
        16-bit Protected Mode Data Address: 0x00000400
PCI Interrupt Routing 1.0 present.
        Router ID: 00:11.0
        Exclusive IRQs: None
        Compatible Router: 1106:8324
        Slot Entry 1: ID 00:00, on-board
        Slot Entry 2: ID 00:11, on-board
        Slot Entry 3: ID 00:10, on-board
        Slot Entry 4: ID 00:0f, on-board
        Slot Entry 5: ID 04:09, slot number 9
        Slot Entry 6: ID 00:01, on-board
        Slot Entry 7: ID 01:00, on-board
        Slot Entry 8: ID 00:13, on-board
        Slot Entry 9: ID 02:01, on-board
        Slot Entry 10: ID 00:13, on-board
        Slot Entry 11: ID 03:03, slot number 49
        Slot Entry 12: ID 03:04, slot number 50
        Slot Entry 13: ID 03:05, slot number 51
        Slot Entry 14: ID 03:06, slot number 52
        Slot Entry 15: ID 03:07, slot number 53

Whatever a VIA 8324 router happens to be - - -

All four of the different brands of "Nano-book reference design"
machines have the same, or very similar, BIOS (all the VIA demo
board BIOS).  That interrupt table is the same in all machines.
Only one of the manufacturer's even bothered to change the serial
number of the machine (1234567890) - they are that "similar".

Mike
 
> Alan Stern
> 
> 
> 


