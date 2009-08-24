Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZHXQRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZHXQRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZHXQRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:17:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:50253 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZHXQRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:17:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wk0gmF0pCPb1ZOA9fPROHqtfuzcRkvov+5gBVfSVeQTAVfnDaXmIosUHzbsxjU/X+z
         7KamBTWR7QGfPWuQyPAY7gkh7k9kfLxBycXZLOC4TcdY/aPh0MO5WuJsXuefnnVLaBLv
         bcCJ8QCmQbVxQoOGgjJr2iSMR5wz6BriM0qbM=
Subject: Re: ACPI locks hardware devices when it doesn't detect vista
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Mairo <rety@poczta.onet.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
In-Reply-To: <1250985766.28634.3.camel@maxim-laptop>
References: <1250945310.14167.150.camel@maxim-laptop>
	 <200908222341.06300.rjw@sisk.pl>  <1250978550.6402.14.camel@maxim-laptop>
	 <1250980612.6402.17.camel@maxim-laptop>
	 <1250985766.28634.3.camel@maxim-laptop>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 19:17:16 +0300
Message-Id: <1251130636.12927.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-23 at 03:02 +0300, Maxim Levitsky wrote:
> On Sun, 2009-08-23 at 01:36 +0300, Maxim Levitsky wrote:
> > On Sun, 2009-08-23 at 01:02 +0300, Maxim Levitsky wrote:
> > > On Sat, 2009-08-22 at 23:41 +0200, Rafael J. Wysocki wrote:
> > > > On Saturday 22 August 2009, Maxim Levitsky wrote:
> > > > > Hi,
> > > > > 
> > > > > <joke>
> > > > > This should be brought to a Microsoft antitrust case...
> > > > > </joke>
> > > > > 
> > > > > 
> > > > > Today many notebooks ship with a embedded infrared receiver.
> > > > > In Vista there is new subsystem that decodes these signals.
> > > > > (of course it works only with Microsoft Certificated Remotes (TM)...)
> > > > > 
> > > > > The receiver is usually presented to system as a pnp device 
> > > > > (using acpi tables)
> > > > > 
> > > > > It turns out that some bioses actually use the OSI, ACPI feature of the
> > > > > operation system to detect if running inside Vista. If not they disable
> > > > > the infrared receiver.
> > > 
> > > Just one note. At least I am now sure that OSI("Windows 2006") does
> > > return true by default.
> > > 
> > > I have tried booting here with acpi_osi="!Windows 2006", and actually
> > > the CIR PNP device disappeared. I guess that _STA that returns zero
> > > causes that.
> > > 
> > > On his laptop, ENE0100 device doesn't disappear, but still someone
> > > writes zero to LPCB.IOR2 (we checked and found out that it was zero)
> > > 
> Just to make it clear:
> on Mairo's laptop, booting without any special parameters, doesn't
> remove the device from pnp list, but its I/O range is blocked.
> Booting with acpi_osi="!Windows 2006" actually removes it from pnp list,
> exactly, like on my system (I don't have completely confirmation of
> that, but according to dmesg, my driver never gets loaded)
> 
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> > > Maybe its zero by default, but some 'magic' driver in windows sets it
> > > up, but this is a PCI config register on LPC bridge, (0x88) and I am
> > > almost sure that nobody except bios knows about it.
> > > 
> > > Windows IR driver doesn't touch it for sure.
> > > 
> > > So, it could be that _STA is once called before the _SB._INI ?
> > 
> > We have just tested, and it turns out that on boot, the device is
> > unlocked. So it must ACPI
> > 
> > I have put a printk very early in kernel initialization, and it proved
> > that CIR io range is accessible, before acpi initialization.
> > 
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
Any update on that?

I have tried to 'reproduce' same issue on my system by editing my acpi
tables, but couldn't
(I am sure that I did everything correctly, and to be even more sure, I
have inverted the test for windows vista in _STA, and IR device did
lock)


Mairo, could you somehow compile latest kernel  from git from

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

you just need to exectute 

git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

Then remove the setpci workaround, boot that kernel, and see if acpi still locks the IR device
OK?


Best regards,
	Maxim Levitsky


> > 
> > > Best regards,
> > > 	Maxim Levitsky
> > > 
> > > > 
> > > > Oh well.
> > > > 
> > > > That should've been Cced to linux-acpi (now added).  I'm looking forward to
> > > > seeng a comment from Len. 
> > > Sorry....
> > > > 
> > > > > On my system this it is still tolerable:
> > > > > 
> > > > >             Device (MIR)
> > > > >             {
> > > > >                 Name (_HID, EisaId ("ENE0100"))
> > > > >                 Method (_STA, 0, NotSerialized)
> > > > >                 {
> > > > >                     If (LGreaterEqual (OSYS, 0x07D6))
> > > > >                     {
> > > > >                         If (LOr (And (OTHR, 0x02), And (OTHR, 0x40)))
> > > > >                         {
> > > > >                             Return (0x00)
> > > > >                         }
> > > > >                         Else
> > > > >                         {
> > > > >                             Return (0x0F)
> > > > >                         }
> > > > >                     }
> > > > >                     Else
> > > > >                     {
> > > > >                         Return (0x00)
> > > > >                     }
> > > > >                 }
> > > > > 
> > > > > But not so, on Mairo's system:
> > > > > 
> > > > >             Device (MIR)
> > > > >             {
> > > > >                 Name (_HID, EisaId ("ENE0100"))
> > > > >                 Method (_STA, 0, NotSerialized)
> > > > >                 {
> > > > >                     If (LAnd (MCIR, LEqual (OSYS, 0x07D6)))
> > > > >                     {
> > > > >                         Return (0x0F)
> > > > >                     }
> > > > >                     Else
> > > > >                     {
> > > > >                         Store (Zero, ^^LPCB.IOR2)
> > > > >                         Return (Zero)
> > > > >                     }
> > > > >                 }
> > > > > 
> > > > > 	.......
> > > > > 
> > > > >     Method (_WAK, 1, NotSerialized)
> > > > >     {
> > > > >     .......
> > > > >         If (Not (LAnd (MCIR, LEqual (OSYS, 0x07D6))))
> > > > >         {
> > > > >             Store (Zero, \_SB.PCI0.LPCB.IOR2)
> > > > >         }
> > > > > 
> > > > > 
> > > > > .....
> > > > > 
> > > > >     Scope (_SB)
> > > > >     {
> > > > >         Method (_INI, 0, NotSerialized)
> > > > >         {
> > > > >             If (DTSE)
> > > > >             {
> > > > >                 TRAP (0x47)
> > > > >             }
> > > > > 
> > > > >             Store (0x07D0, OSYS)
> > > > >             If (CondRefOf (_OSI, Local0))
> > > > >             {
> > > > >                 If (_OSI ("Linux"))
> > > > >                 {
> > > > >                     Store (One, LINX)
> > > > >                     Store (Zero, ECDY)
> > > > >                 }
> > > > > 
> > > > >                 If (_OSI ("Windows 2001"))
> > > > >                 {
> > > > >                     Store (0x07D1, OSYS)
> > > > >                 }
> > > > > 
> > > > >                 If (_OSI ("Windows 2001 SP1"))
> > > > >                 {
> > > > >                     Store (0x07D1, OSYS)
> > > > >                 }
> > > > > 
> > > > >                 If (_OSI ("Windows 2001 SP2"))
> > > > >                 {
> > > > >                     Store (0x07D2, OSYS)
> > > > >                 }
> > > > > 
> > > > >                 If (_OSI ("Windows 2006"))
> > > > >                 {
> > > > >                     Store (0x07D6, OSYS)
> > > > >                 }
> > > > > 
> > > > >                 If (LEqual (TPMV, One))
> > > > >                 {
> > > > >                     If (LLessEqual (OSYS, 0x07D2))
> > > > >                     {
> > > > >                         TRAP (0x49)
> > > > >                     }
> > > > >                 }
> > > > >             }
> > > > > 
> > > > >             If (LAnd (MPEN, LEqual (OSYS, 0x07D1)))
> > > > >             {
> > > > >                 TRAP (0x3D)
> > > > >             }
> > > > > 
> > > > >             TRAP (0x2B)
> > > > >         }
> > > > >     }
> > > > > 
> > > > > We have tried to boot the system with acpi_osi="Windows 2006", but it
> > > > > didn't help (kernel log confirmed that this parameter was set)
> > > > > 
> > > > > The only explanation I think of is ether his laptop is whitelisted on
> > > > > osi=Linux, or that _SB._INI is called by linux _after_ MIR._STA
> > > > > or that acpi_osi isn't yet in charge when _SB._INI is called.
> > > > > 
> > > > > 
> > > > > The kernel in question is quite recent kernel, (2.6.30.5 from debian
> > > > > unstable).
> > > > > 
> > > > > 
> > > > > The only way I managed to 'enable' this device is to 
> > > > > do 'sudo setpci -s 00:1f.0 0x88.W=0x701'
> > > > > 
> > > > > Or in other words undo the damage done by these ACPI commands.
> > > > > 
> > > > > Mairo, can you boot the system with acpi=off, and then poke the cir IO
> > > > > range (0x700-0x703) ?
> > > > 
> > > > Best,
> > > > Rafael
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> 

