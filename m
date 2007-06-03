Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbXFCKbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbXFCKbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 06:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXFCKa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 06:30:58 -0400
Received: from web63607.mail.re1.yahoo.com ([69.147.97.77]:45626 "HELO
	web63607.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756337AbXFCKaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 06:30:55 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jun 2007 06:30:55 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=axfMFbt5rcJvFf/6Rw6M7RCD2BOmuo+yGWY5LgegKl6oADa3f29sVwXB3DLRzaKzKgfMPZ2MVUOfMB53LLQ8x14Y40EjCmeJWxdGjMyzyUR4pCM7nbYp24XcSavtQxP2jmJBLatN6t5wJIr29nrYnj8Ccpxnh+hNd3HarDh/n/M=;
X-YMail-OSG: mxrjZq0VM1l2JiHAZtgJ0p2Iv48HZnRctvPvS8luEPqjvrqczoM1RlCyXTKUZyYVt1tajNzQj_qe4f1ayZl30iOgPi9AtPXxGYAI
Date: Sun, 3 Jun 2007 03:24:12 -0700 (PDT)
From: Tear <tarrqt@yahoo.com>
Subject: Re: [RFC][PATCH] IO-APIC blacklist
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200706030016.54555.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1877047116-1180866252=:73709"
Content-Transfer-Encoding: 8bit
Message-ID: <58017.73709.qm@web63607.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1877047116-1180866252=:73709
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Len Brown <lenb@kernel.org> wrote:
> On Saturday 02 June 2007 19:53, Tear wrote:
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > On Sat, 2 Jun 2007, Tear wrote:
> 
> > > Now, I doubt it's the timer, and the UHCI irq thing sounds more likely to 
> > > be a problem anyway, since it's USB that's slow, so it would be 
> > > interesting to hear whether:
> > > 
> > > 	acpi=force pci=routeirq
> > > 
> > > is still slow (it should enable ACPI, but then force the interrupt routing 
> > > to use the PIRQ table anyway). 
> 
> I think you meant to suggest acpi=force plus "acpi=noirq", which will
> cause all of ACPI except its interrupt routing code to run.
> (similarly, "pci=noacpi" causes all of ACPI to run except its
>  interrupt code and PCI bus enumeration code)

acpi=force plus acpi=noirq changes the situation a little bit.
With acpi=force and acpi=noirq, the ports on the front panel
work at a "medium" speed, neither fast nor slow.

> pci=routeirq actually just goes and forces the interrupt routing
> for all PCI devices to be set up before driver probe time
> when it is normally done.  This is a workaround for PCI drivers
> that don't call pci_enable_device() to enable their IRQ.
> 
> In any case, it is possible that the assumption that IRQs
> are broken on this box may be invalid.  In the case of
> the PCI interrupts above 15 on this box -- they are
> all "hard coded" in the _PRT -- there is no run-time
> interrupt link to program, Linux will always use the
> same IRQ for each device and it has no choice in the matter
> in ACPI mode.  So the same is likely true in legacy mode.
> 
> > > Also, if you can figure out which USB ports are on the _other_ controller 
> > > (the one that gets irq 18 regardless of whether ACPI is on or off), it 
> > > would also be interesting to hear whether the camera is always fast (or 
> > > perhaps always slow) when connected to a part that is off that 
> > > controller..
> > 
> > Originally I have been using the USB ports on the front panel of
> > the computer. I had not tested the USB ports on the rear panel
> > of the computer. I have just tested the USB ports on the rear
> > panel of the computer with acpi=ht, and surprise, the camera is fast!
> 
> When we talk about "fast" and "slow" here, what are we talking about?
> What are the relative speeds?
> I see uhci only in dmesg, I guess there is no ehci on this box?

Yes, this is a relatively old system;
it has only uhci and no ehci. Please
see the following outputs for the speed
of the USB transfers. Before each mount,
I flushed the caches with "blockdev --flushbufs".

~~~~~ Slow: (acpi=ht, USB port on the *front* panel) ~~~~~

# time mount /dev/sda1 /media/usbdisk/

real    0m18.343s
user    0m0.000s
sys     0m0.008s

# time dd if=dsc00673.jpg of=/dev/null
4295+1 records in
4295+1 records out
2199226 bytes (2,2 MB) copied, 16.7524 seconds, 131 kB/s

real    0m16.757s
user    0m0.000s
sys     0m0.004s


~~~~~ Fast: (acpi=ht, USB port on the *rear* panel) ~~~~~

# time mount /dev/sda1 /media/usbdisk/

real    0m0.259s
user    0m0.004s
sys     0m0.012s

# time dd if=dsc00673.jpg of=/dev/null
4295+1 records in
4295+1 records out
2199226 bytes (2,2 MB) copied, 2.60062 seconds, 846 kB/s

real    0m2.606s
user    0m0.000s
sys     0m0.020s

~~~~~ Fast: (acpi=force, USB port on the *front* panel) ~~~~~

# time mount /dev/sda1 /media/usbdisk/

real    0m0.287s
user    0m0.000s
sys     0m0.008s

# time dd if=dsc00673.jpg of=/dev/null
4295+1 records in
4295+1 records out
2199226 bytes (2,2 MB) copied, 2.60754 seconds, 843 kB/s

real    0m2.612s
user    0m0.000s
sys     0m0.012s


> Also, can you associate the physical ports on back and front
> with the software drivers loaded by performing an operation
> on the port and observing which line in /proc/interrupts increments?

Sure. With acpi=ht, /proc/interrupts is as follows:

           CPU0
  0:     201306   IO-APIC-edge      timer
  1:       1457   IO-APIC-edge      i8042
  2:          0    XT-PIC-XT        cascade
  6:          5   IO-APIC-edge      floppy
  7:          0   IO-APIC-edge      parport0
  8:          1   IO-APIC-edge      rtc
 12:      19218   IO-APIC-edge      i8042
 14:      18704   IO-APIC-edge      ide0
 15:       6973   IO-APIC-edge      ide1
 16:      56862   IO-APIC-fasteoi   r128@pci:0000:01:00.0
 17:      20792   IO-APIC-fasteoi   Intel 82801BA-ICH2
 18:         74   IO-APIC-fasteoi   uhci_hcd:usb2, eth0
 19:         38   IO-APIC-fasteoi   uhci_hcd:usb1
NMI:          0
LOC:     201260
ERR:          0
MIS:          0

With acpi=force, /proc/interrupts is as follows:

           CPU0
  0:         71   IO-APIC-edge      timer
  1:       5772   IO-APIC-edge      i8042
  6:          5   IO-APIC-edge      floppy
  7:          0   IO-APIC-edge      parport0
  8:          1   IO-APIC-edge      rtc
  9:          1   IO-APIC-fasteoi   acpi
 12:      24882   IO-APIC-edge      i8042
 14:      15278   IO-APIC-edge      ide0
 15:      10141   IO-APIC-edge      ide1
 16:       1961   IO-APIC-fasteoi   uhci_hcd:usb1
 17:       1333   IO-APIC-fasteoi   uhci_hcd:usb2
 18:        609   IO-APIC-fasteoi   eth0
 19:          0   IO-APIC-fasteoi   Intel 82801BA-ICH2
 20:      83137   IO-APIC-fasteoi   r128@pci:0000:01:00.0
NMI:          0
LOC:     312469
ERR:          0
MIS:          0

With acpi=force, the following is observed:

Ports on the front panel increment the following line:
 17:       1763   IO-APIC-fasteoi   uhci_hcd:usb2

Whereas the ports on the rear panel increment the following line:
 16:       2477   IO-APIC-fasteoi   uhci_hcd:usb1

> do all of the USB interfaces tested have their own unshared
> IRQ in /proc/interrupts?

With acpi=ht, no. However, with acpi=force, yes.

> thanks,
> -Len
> 
> ps. there could still be some "ACPI magic" going on here.
> We've seen motherboards that enable parts of USB based
> on what OS they think they are running.  Try
> acpi=force acpi_os_name=Linux acpi_osi=
> and if that makes USB go slow, that is proof
> of where the magic lives.

acpi=force acpi_os_name=Linux acpi_osi= does not differ
from only acpi=force. Both of the USB controllers
are fast.

> Also, please capture the output from acpidump
> and attach it to a bug report here:
> http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
> If you don't have acpidump installed, you can get it
> from pmtools here:
> http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/

I do not know what I should write in the bug report.
For this reason, I am attaching the output of acpidump.

Thank you for your attention.

Regards,
- Tear




 
____________________________________________________________________________________
Never miss an email again!
Yahoo! Toolbar alerts you the instant new Mail arrives.
http://tools.search.yahoo.com/toolbar/features/mail/
--0-1877047116-1180866252=:73709
Content-Type: text/plain; name="acpidump.txt"
Content-Description: 2274583100-acpidump.txt
Content-Disposition: inline; filename="acpidump.txt"

DSDT @ 0xfffe3c22
  0000: 44 53 44 54 93 23 00 00 01 6e 44 45 4c 4c 00 00  DSDT.#...nDELL..
  0010: 64 74 5f 65 78 00 00 00 00 10 00 00 4d 53 46 54  dt_ex.......MSFT
  0020: 0d 00 00 01 14 07 44 42 49 4e 00 a3 10 4f 05 5c  ......DBIN...O.\
  0030: 00 5b 82 21 5c 2e 5f 53 42 5f 56 42 54 4e 08 5f  .[.!\._SB_VBTN._
  0040: 48 49 44 0c 41 d0 0c 0c 08 5f 50 52 57 12 06 02  HID.A...._PRW...
  0050: 0a 01 0a 04 5b 80 5c 53 53 54 53 01 0b 28 08 0a  ....[.\SSTS..(..
  0060: 01 5b 81 0c 5c 53 53 54 53 41 54 53 54 53 01 5b  .[..\SSTSATSTS.[
  0070: 80 5c 53 41 43 54 01 0b 2a 08 0a 01 5b 81 0e 5c  .\SACT..*...[..\
  0080: 53 41 43 54 41 00 02 54 50 4f 4c 01 10 28 5c 5f  SACTA..TPOL..(\_
  0090: 47 50 45 14 21 5f 4c 30 30 00 70 0a 00 54 50 4f  GPE.!_L00.p..TPO
  00a0: 4c 70 0a 01 54 53 54 53 86 5c 2e 5f 53 42 5f 56  Lp..TSTS.\._SB_V
  00b0: 42 54 4e 0a 02 08 4d 53 4f 53 0a 00 5b 01 4d 54  BTN...MSOS..[.MT
  00c0: 58 5f 01 14 38 43 4d 52 44 01 5b 23 53 4d 49 4d  X_..8CMRD.[#SMIM
  00d0: ff ff 70 68 60 7b 60 0a 7f 60 70 60 53 4d 49 44  ..ph`{`..`p`SMID
  00e0: 70 0a 84 53 4d 49 43 70 0a 85 53 4d 49 43 70 53  p..SMICp..SMICpS
  00f0: 4d 49 44 60 5b 27 53 4d 49 4d a4 60 14 36 43 4d  MID`['SMIM.`.6CM
  0100: 57 52 02 5b 23 53 4d 49 4d ff ff 70 68 60 7d 60  WR.[#SMIM..ph`}`
  0110: 0a 80 60 70 60 53 4d 49 44 70 0a 84 53 4d 49 43  ..`p`SMIDp..SMIC
  0120: 70 69 53 4d 49 44 70 0a 85 53 4d 49 43 5b 27 53  piSMIDp..SMIC['S
  0130: 4d 49 4d 14 11 47 43 4b 42 00 a4 7b 0a 20 43 4d  MIM..GCKB..{. CM
  0140: 52 44 0a 26 00 14 11 47 43 4d 53 00 a4 7b 0a 40  RD.&...GCMS..{.@
  0150: 43 4d 52 44 0a 6f 00 14 11 47 43 4f 4e 00 a4 7b  CMRD.o...GCON..{
  0160: 0a 04 43 4d 52 44 0a 55 00 14 11 47 43 55 43 00  ..CMRD.U...GCUC.
  0170: a4 7f 0a 01 43 4d 52 44 0a 22 00 14 11 47 43 53  ....CMRD."...GCS
  0180: 31 00 a4 7b 0a 03 43 4d 52 44 0a 25 00 14 11 47  1..{..CMRD.%...G
  0190: 43 53 32 00 a4 7b 0a 0c 43 4d 52 44 0a 25 00 14  CS2..{..CMRD.%..
  01a0: 11 47 43 46 44 00 a4 7b 0a 18 43 4d 52 44 0a 55  .GCFD..{..CMRD.U
  01b0: 00 14 11 47 43 50 50 00 a4 7b 0a 70 43 4d 52 44  ...GCPP..{.pCMRD
  01c0: 0a 23 00 14 4a 13 48 41 43 4b 00 70 43 4d 52 44  .#..J.HACK.pCMRD
  01d0: 0a 37 60 7b 60 0a df 60 43 4d 57 52 0a 37 60 a0  .7`{`..`CMWR.7`.
  01e0: 1e 93 4d 53 4f 53 0a 04 70 43 4d 52 44 0a 6f 60  ..MSOS..pCMRD.o`
  01f0: 7d 60 0a 04 60 43 4d 57 52 0a 6f 60 a4 01 a1 15  }`..`CMWR.o`....
  0200: 70 43 4d 52 44 0a 6f 60 7b 60 0a fb 60 43 4d 57  pCMRD.o`{`..`CMW
  0210: 52 0a 6f 60 72 87 5c 5f 4f 53 5f 0a 01 60 70 60  R.o`r.\_OS_..`p`
  0220: 61 08 42 55 46 30 11 02 60 08 42 55 46 31 11 02  a.BUF0..`.BUF1..
  0230: 60 08 4f 53 4e 54 0a 01 08 4f 53 39 38 0a 01 70  `.OSNT...OS98..p
  0240: 5c 5f 4f 53 5f 42 55 46 30 70 0d 4d 69 63 72 6f  \_OS_BUF0p.Micro
  0250: 73 6f 66 74 20 57 69 6e 64 6f 77 73 20 4e 54 00  soft Windows NT.
  0260: 42 55 46 31 a2 20 60 76 60 a0 12 93 83 88 42 55  BUF1. `v`.....BU
  0270: 46 30 60 00 83 88 42 55 46 31 60 00 a1 08 70 0a  F0`...BUF1`...p.
  0280: 00 4f 53 4e 54 a0 0e 4f 53 4e 54 70 0a 03 4d 53  .OSNT..OSNTp..MS
  0290: 4f 53 a4 01 a1 49 06 70 0d 4d 69 63 72 6f 73 6f  OS...I.p.Microso
  02a0: 66 74 20 57 69 6e 64 6f 77 73 00 42 55 46 31 a2  ft Windows.BUF1.
  02b0: 20 61 76 61 a0 12 93 83 88 42 55 46 30 61 00 83   ava.....BUF0a..
  02c0: 88 42 55 46 31 61 00 a1 08 70 0a 00 4f 53 39 38  .BUF1a...p..OS98
  02d0: a0 22 4f 53 39 38 70 43 4d 52 44 0a 37 60 7d 60  ."OS98pCMRD.7`}`
  02e0: 0a 20 60 43 4d 57 52 0a 37 60 70 0a 01 4d 53 4f  . `CMWR.7`p..MSO
  02f0: 53 a4 00 a1 0a 70 0a 02 4d 53 4f 53 a4 00 10 13  S....p..MSOS....
  0300: 5c 5f 50 52 5f 5b 83 0b 43 50 55 30 01 10 08 00  \_PR_[..CPU0....
  0310: 00 06 5b 80 53 50 4b 52 01 0b 8c 08 0a 04 5b 81  ..[.SPKR......[.
  0320: 15 53 50 4b 52 01 47 52 53 31 16 47 53 50 4b 01  .SPKR.GRS1.GSPK.
  0330: 47 52 53 32 09 5b 80 43 4d 53 5f 01 0a 70 0a 02  GRS2.[.CMS_..p..
  0340: 5b 81 10 43 4d 53 5f 01 43 4d 53 49 08 43 4d 53  [..CMS_.CMSI.CMS
  0350: 44 08 5b 80 53 4d 49 52 01 0a b2 0a 02 5b 81 10  D.[.SMIR.....[..
  0360: 53 4d 49 52 01 53 4d 49 43 08 53 4d 49 44 08 5b  SMIR.SMIC.SMID.[
  0370: 80 50 4d 31 52 01 0b 00 08 0a 04 5b 81 1a 50 4d  .PM1R......[..PM
  0380: 31 52 01 50 4d 53 31 08 50 4d 53 32 08 50 4d 45  1R.PMS1.PMS2.PME
  0390: 31 08 50 4d 45 32 08 5b 80 47 4c 42 43 01 0b 28  1.PME2.[.GLBC..(
  03a0: 08 0a 04 5b 81 1a 47 4c 42 43 01 54 48 52 50 08  ...[..GLBC.THRP.
  03b0: 47 4c 42 54 08 45 4f 53 5f 08 4c 49 44 50 08 5b  GLBT.EOS_.LIDP.[
  03c0: 80 50 58 59 30 01 0b 29 09 0a 01 5b 81 0f 50 58  .PXY0..)...[..PX
  03d0: 59 30 01 00 01 43 48 41 53 03 00 04 5b 80 53 49  Y0...CHAS...[.SI
  03e0: 4f 5f 01 0a 2e 0a 02 5b 81 10 53 49 4f 5f 01 53  O_.....[..SIO_.S
  03f0: 49 4f 49 08 53 49 4f 44 08 5b 80 50 4d 45 53 01  IOI.SIOD.[.PMES.
  0400: 0b 00 0c 0a 01 5b 81 0b 50 4d 45 53 01 47 53 54  .....[..PMES.GST
  0410: 53 08 5b 80 57 45 4e 58 01 0b 0a 0c 0a 06 5b 81  S.[.WENX......[.
  0420: 24 57 45 4e 58 01 57 45 4e 31 08 57 45 4e 32 08  $WENX.WEN1.WEN2.
  0430: 57 45 4e 33 08 57 45 4e 34 08 57 45 4e 35 08 57  WEN3.WEN4.WEN5.W
  0440: 45 4e 36 08 5b 80 57 53 54 58 01 0b 04 0c 0a 06  EN6.[.WSTX......
  0450: 5b 81 24 57 53 54 58 01 57 53 54 31 08 57 53 54  [.$WSTX.WST1.WST
  0460: 32 08 57 53 54 33 08 57 53 54 34 08 57 53 54 35  2.WST3.WST4.WST5
  0470: 08 57 53 54 36 08 5b 80 4c 45 44 58 01 0b 5d 0c  .WST6.[.LEDX..].
  0480: 0a 02 5b 81 10 4c 45 44 58 01 4c 45 44 31 08 4c  ..[..LEDX.LED1.L
  0490: 45 44 32 08 5b 01 53 4d 49 4d 01 14 34 53 4d 49  ED2.[.SMIM..4SMI
  04a0: 32 01 5b 23 53 4d 49 4d ff ff 70 68 53 4d 49 43  2.[#SMIM..phSMIC
  04b0: 70 53 4d 49 43 60 70 53 4d 49 44 60 79 60 0a 08  pSMIC`pSMID`y`..
  04c0: 60 72 53 4d 49 43 60 60 5b 27 53 4d 49 4d a4 60  `rSMIC``['SMIM.`
  04d0: 14 24 53 4d 49 34 01 72 68 0a 01 60 70 53 4d 49  .$SMI4.rh..`pSMI
  04e0: 32 68 62 70 53 4d 49 32 60 61 79 61 0a 10 61 72  2hbpSMI2`aya..ar
  04f0: 61 62 60 a4 60 14 0d 47 54 4d 52 00 a4 53 4d 49  ab`.`..GTMR..SMI
  0500: 34 0a 78 14 0d 47 54 4d 4c 00 a4 53 4d 49 34 0a  4.x..GTML..SMI4.
  0510: 74 14 0d 47 54 4d 48 00 a4 53 4d 49 34 0a 76 08  t..GTMH..SMI4.v.
  0520: 47 50 45 46 0a 00 08 53 53 54 58 0a 00 14 41 05  GPEF...SSTX...A.
  0530: 5c 2e 5f 47 50 45 5f 4c 30 33 00 a0 17 80 93 53  \._GPE_L03.....S
  0540: 53 54 58 0a 01 00 86 5c 2e 5f 53 42 5f 56 42 54  STX....\._SB_VBT
  0550: 4e 0a 02 5b 22 0a 14 7f 54 48 52 50 0a 08 54 48  N..["...THRP..TH
  0560: 52 50 7d 50 4d 45 32 0a 01 50 4d 45 32 86 5c 2f  RP}PME2..PME2.\/
  0570: 03 5f 53 42 5f 50 43 49 30 55 53 42 30 0a 02 14  ._SB_PCI0USB0...
  0580: 41 05 5c 2e 5f 47 50 45 5f 4c 30 34 00 a0 17 80  A.\._GPE_L04....
  0590: 93 53 53 54 58 0a 01 00 86 5c 2e 5f 53 42 5f 56  .SSTX....\._SB_V
  05a0: 42 54 4e 0a 02 5b 22 0a 14 7f 54 48 52 50 0a 10  BTN..["...THRP..
  05b0: 54 48 52 50 7d 50 4d 45 32 0a 01 50 4d 45 32 86  THRP}PME2..PME2.
  05c0: 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53 42 31 0a  \/._SB_PCI0USB1.
  05d0: 02 14 34 5c 2e 5f 47 50 45 5f 4c 30 42 00 7f 47  ..4\._GPE_L0B..G
  05e0: 4c 42 54 0a 08 47 4c 42 54 7d 50 4d 45 32 0a 01  LBT..GLBT}PME2..
  05f0: 50 4d 45 32 86 5c 2f 03 5f 53 42 5f 50 43 49 30  PME2.\/._SB_PCI0
  0600: 50 43 49 31 0a 02 14 45 06 5c 2e 5f 47 50 45 5f  PCI1...E.\._GPE_
  0610: 4c 30 38 00 70 57 45 4e 31 60 7b 60 0a e7 57 45  L08.pWEN1`{`..WE
  0620: 4e 31 70 57 53 54 31 60 7b 60 0a 18 57 53 54 31  N1pWST1`{`..WST1
  0630: 70 47 53 54 53 60 7b 60 0a 01 47 53 54 53 a0 17  pGSTS`{`..GSTS..
  0640: 80 93 53 53 54 58 0a 01 00 86 5c 2e 5f 53 42 5f  ..SSTX....\._SB_
  0650: 56 42 54 4e 0a 02 86 5c 2f 04 5f 53 42 5f 50 43  VBTN...\/._SB_PC
  0660: 49 30 49 53 41 5f 4b 42 44 5f 0a 02 14 40 07 5c  I0ISA_KBD_...@.\
  0670: 5f 50 54 53 01 a0 47 06 7d 93 68 0a 03 93 68 0a  _PTS..G.}.h...h.
  0680: 01 00 70 0a 55 53 49 4f 49 70 0a 07 53 49 4f 49  ..p.USIOIp..SIOI
  0690: 70 0a 07 53 49 4f 44 70 0a f0 53 49 4f 49 70 53  p..SIODp..SIOIpS
  06a0: 49 4f 44 60 7d 60 0a 60 53 49 4f 44 70 0a aa 53  IOD`}`.`SIODp..S
  06b0: 49 4f 49 70 57 53 54 31 60 7b 60 0a 18 57 53 54  IOIpWST1`{`..WST
  06c0: 31 70 47 53 54 53 60 7b 60 0a 01 47 53 54 53 70  1pGSTS`{`..GSTSp
  06d0: 57 45 4e 31 60 7d 60 0a 18 57 45 4e 31 14 43 04  WEN1`}`..WEN1.C.
  06e0: 5c 5f 57 41 4b 01 a0 38 7d 7b 50 4d 53 32 0a 01  \_WAK..8}{PMS2..
  06f0: 00 7d 7b 92 48 41 43 4b 7b 47 4c 42 54 0a 01 00  .}{.HACK{GLBT...
  0700: 00 7b 92 48 41 43 4b 7b 54 48 52 50 0a 08 00 00  .{.HACK{THRP....
  0710: 00 00 86 5c 2e 5f 53 42 5f 56 42 54 4e 0a 02 a4  ...\._SB_VBTN...
  0720: 00 10 35 5c 5f 53 49 5f 14 2e 5f 53 53 54 01 70  ..5\_SI_.._SST.p
  0730: 68 53 53 54 58 a0 10 93 68 0a 03 7b 4c 45 44 32  hSSTX...h..{LED2
  0740: 0a fd 4c 45 44 32 a0 10 93 68 0a 01 7d 4c 45 44  ..LED2...h..}LED
  0750: 32 0a 02 4c 45 44 32 10 17 5c 00 08 50 49 43 46  2..LED2..\..PICF
  0760: 0a 00 14 0c 5f 50 49 43 01 70 68 50 49 43 46 10  ...._PIC.phPICF.
  0770: 83 c2 01 5c 5f 53 42 5f 14 2b 5f 49 4e 49 00 a0  ...\_SB_.+_INI..
  0780: 24 5b 12 5f 4f 53 49 60 a0 1b 5c 5f 4f 53 49 0d  $[._OSI`..\_OSI.
  0790: 57 69 6e 64 6f 77 73 20 32 30 30 31 00 70 0a 04  Windows 2001.p..
  07a0: 4d 53 4f 53 5b 82 4c 0c 4d 45 4d 5f 08 5f 48 49  MSOS[.L.MEM_._HI
  07b0: 44 0c 41 d0 0c 01 08 5f 55 49 44 0a 01 14 44 0b  D.A...._UID...D.
  07c0: 5f 43 52 53 00 08 4d 45 4d 42 11 46 06 0a 62 86  _CRS..MEMB.F..b.
  07d0: 09 00 01 00 00 00 00 00 00 0a 00 86 09 00 01 00  ................
  07e0: 00 10 00 00 00 00 00 86 09 00 01 00 00 00 01 00  ................
  07f0: 00 00 00 86 09 00 00 00 00 0f 00 00 00 01 00 86  ................
  0800: 09 00 01 00 00 c0 fe 00 00 01 00 86 09 00 01 00  ................
  0810: 00 e0 fe 00 00 01 00 86 09 00 00 00 00 b0 ff 00  ................
  0820: 00 10 00 86 09 00 00 00 00 c0 ff 00 00 40 00 79  .............@.y
  0830: 00 8a 4d 45 4d 42 0a 08 4d 45 4d 52 8a 4d 45 4d  ..MEMB..MEMR.MEM
  0840: 42 0a 14 4d 45 4d 4c 8a 4d 45 4d 42 0a 20 4d 45  B..MEML.MEMB. ME
  0850: 4d 48 70 47 54 4d 52 4d 45 4d 52 70 47 54 4d 4c  MHpGTMRMEMRpGTML
  0860: 4d 45 4d 4c 70 47 54 4d 48 4d 45 4d 48 a4 4d 45  MEMLpGTMHMEMH.ME
  0870: 4d 42 5b 82 81 52 01 50 43 49 30 08 5f 48 49 44  MB[..R.PCI0._HID
  0880: 0c 41 d0 0a 03 08 5f 55 49 44 0a 04 08 5f 41 44  .A...._UID..._AD
  0890: 52 0a 00 08 5f 50 52 57 12 06 02 0a 0b 0a 05 14  R..._PRW........
  08a0: 09 5f 53 31 44 00 a4 0a 01 14 14 5f 53 33 44 00  ._S1D......_S3D.
  08b0: a0 08 48 41 43 4b a4 0a 03 a1 04 a4 0a 02 08 50  ..HACK.........P
  08c0: 49 43 30 12 43 09 09 12 0f 04 0c ff ff 01 00 0a  IC0.C...........
  08d0: 00 4c 4e 4b 41 0a 00 12 0f 04 0c ff ff 01 00 0a  .LNKA...........
  08e0: 01 4c 4e 4b 42 0a 00 12 0f 04 0c ff ff 1f 00 0a  .LNKB...........
  08f0: 02 4c 4e 4b 48 0a 00 12 0f 04 0c ff ff 1f 00 0a  .LNKH...........
  0900: 03 4c 4e 4b 44 0a 00 12 0f 04 0c ff ff 1f 00 0a  .LNKD...........
  0910: 01 4c 4e 4b 42 0a 00 12 0f 04 0c ff ff 1e 00 0a  .LNKB...........
  0920: 00 4c 4e 4b 41 0a 00 12 0f 04 0c ff ff 1e 00 0a  .LNKA...........
  0930: 01 4c 4e 4b 42 0a 00 12 0f 04 0c ff ff 1e 00 0a  .LNKB...........
  0940: 02 4c 4e 4b 43 0a 00 12 0f 04 0c ff ff 1e 00 0a  .LNKC...........
  0950: 03 4c 4e 4b 44 0a 00 08 41 50 49 30 12 41 08 09  .LNKD...API0.A..
  0960: 12 0d 04 0c ff ff 01 00 0a 00 0a 00 0a 10 12 0d  ................
  0970: 04 0c ff ff 01 00 0a 01 0a 00 0a 11 12 0d 04 0c  ................
  0980: ff ff 1f 00 0a 02 0a 00 0a 17 12 0d 04 0c ff ff  ................
  0990: 1f 00 0a 03 0a 00 0a 13 12 0d 04 0c ff ff 1f 00  ................
  09a0: 0a 01 0a 00 0a 11 12 0d 04 0c ff ff 1e 00 0a 00  ................
  09b0: 0a 00 0a 10 12 0d 04 0c ff ff 1e 00 0a 01 0a 00  ................
  09c0: 0a 11 12 0d 04 0c ff ff 1e 00 0a 02 0a 00 0a 12  ................
  09d0: 12 0d 04 0c ff ff 1e 00 0a 03 0a 00 0a 13 14 1b  ................
  09e0: 5f 50 52 54 00 70 41 50 49 30 60 a0 0c 92 50 49  _PRT.pAPI0`...PI
  09f0: 43 46 70 50 49 43 30 60 a4 60 5b 82 49 08 55 53  CFpPIC0`.`[.I.US
  0a00: 42 30 08 5f 41 44 52 0c 02 00 1f 00 08 5f 55 49  B0._ADR......_UI
  0a10: 44 0a 05 08 5f 50 52 57 12 06 02 0a 03 0a 03 5b  D..._PRW.......[
  0a20: 80 55 50 43 31 02 0a c1 0a 01 5b 81 0b 55 50 43  .UPC1.....[..UPC
  0a30: 31 01 4c 45 47 4b 08 14 24 5f 49 4e 49 00 a0 05  1.LEGK..$_INI...
  0a40: 48 41 43 4b a1 17 70 4c 45 47 4b 60 7b 60 0a 60  HACK..pLEGK`{`.`
  0a50: 60 7d 60 0a 20 60 70 60 4c 45 47 4b 14 14 5f 53  `}`. `p`LEGK.._S
  0a60: 54 41 00 a0 08 47 43 55 43 a4 0a 0f a1 04 a4 0a  TA...GCUC.......
  0a70: 00 14 09 5f 53 31 44 00 a4 0a 01 14 09 5f 53 33  ..._S1D......_S3
  0a80: 44 00 a4 0a 02 5b 82 49 08 55 53 42 31 08 5f 41  D....[.I.USB1._A
  0a90: 44 52 0c 04 00 1f 00 08 5f 55 49 44 0a 06 08 5f  DR......_UID..._
  0aa0: 50 52 57 12 06 02 0a 04 0a 03 5b 80 55 50 43 31  PRW.......[.UPC1
  0ab0: 02 0a c1 0a 01 5b 81 0b 55 50 43 31 01 4c 45 47  .....[..UPC1.LEG
  0ac0: 4b 08 14 24 5f 49 4e 49 00 a0 05 48 41 43 4b a1  K..$_INI...HACK.
  0ad0: 17 70 4c 45 47 4b 60 7b 60 0a 60 60 7d 60 0a 20  .pLEGK`{`.``}`. 
  0ae0: 60 70 60 4c 45 47 4b 14 14 5f 53 54 41 00 a0 08  `p`LEGK.._STA...
  0af0: 47 43 55 43 a4 0a 0f a1 04 a4 0a 00 14 09 5f 53  GCUC.........._S
  0b00: 31 44 00 a4 0a 01 14 09 5f 53 33 44 00 a4 0a 02  1D......_S3D....
  0b10: 5b 82 4d 27 50 43 49 31 14 09 5f 53 31 44 00 a4  [.M'PCI1.._S1D..
  0b20: 0a 01 14 09 5f 53 33 44 00 a4 0a 02 14 09 5f 53  ...._S3D......_S
  0b30: 34 44 00 a4 0a 02 14 09 5f 53 35 44 00 a4 0a 02  4D......_S5D....
  0b40: 14 0f 5f 41 44 52 00 70 0c 00 00 1e 00 60 a4 60  .._ADR.p.....`.`
  0b50: 08 5f 55 49 44 0a 07 08 5f 50 52 57 12 06 02 0a  ._UID..._PRW....
  0b60: 0b 0a 05 08 50 49 43 31 12 43 11 11 12 0f 04 0c  ....PIC1.C......
  0b70: ff ff 0c 00 0a 00 4c 4e 4b 43 0a 00 12 0f 04 0c  ......LNKC......
  0b80: ff ff 07 00 0a 00 4c 4e 4b 41 0a 00 12 0f 04 0c  ......LNKA......
  0b90: ff ff 07 00 0a 01 4c 4e 4b 42 0a 00 12 0f 04 0c  ......LNKB......
  0ba0: ff ff 07 00 0a 02 4c 4e 4b 43 0a 00 12 0f 04 0c  ......LNKC......
  0bb0: ff ff 07 00 0a 03 4c 4e 4b 44 0a 00 12 0f 04 0c  ......LNKD......
  0bc0: ff ff 08 00 0a 00 4c 4e 4b 42 0a 00 12 0f 04 0c  ......LNKB......
  0bd0: ff ff 08 00 0a 01 4c 4e 4b 43 0a 00 12 0f 04 0c  ......LNKC......
  0be0: ff ff 08 00 0a 02 4c 4e 4b 44 0a 00 12 0f 04 0c  ......LNKD......
  0bf0: ff ff 08 00 0a 03 4c 4e 4b 41 0a 00 12 0f 04 0c  ......LNKA......
  0c00: ff ff 09 00 0a 00 4c 4e 4b 43 0a 00 12 0f 04 0c  ......LNKC......
  0c10: ff ff 09 00 0a 01 4c 4e 4b 44 0a 00 12 0f 04 0c  ......LNKD......
  0c20: ff ff 09 00 0a 02 4c 4e 4b 41 0a 00 12 0f 04 0c  ......LNKA......
  0c30: ff ff 09 00 0a 03 4c 4e 4b 42 0a 00 12 0f 04 0c  ......LNKB......
  0c40: ff ff 0a 00 0a 00 4c 4e 4b 44 0a 00 12 0f 04 0c  ......LNKD......
  0c50: ff ff 0a 00 0a 01 4c 4e 4b 41 0a 00 12 0f 04 0c  ......LNKA......
  0c60: ff ff 0a 00 0a 02 4c 4e 4b 42 0a 00 12 0f 04 0c  ......LNKB......
  0c70: ff ff 0a 00 0a 03 4c 4e 4b 43 0a 00 08 41 50 49  ......LNKC...API
  0c80: 31 12 41 0f 11 12 0d 04 0c ff ff 0c 00 0a 00 0a  1.A.............
  0c90: 00 0a 12 12 0d 04 0c ff ff 07 00 0a 00 0a 00 0a  ................
  0ca0: 10 12 0d 04 0c ff ff 07 00 0a 01 0a 00 0a 11 12  ................
  0cb0: 0d 04 0c ff ff 07 00 0a 02 0a 00 0a 12 12 0d 04  ................
  0cc0: 0c ff ff 07 00 0a 03 0a 00 0a 13 12 0d 04 0c ff  ................
  0cd0: ff 08 00 0a 00 0a 00 0a 11 12 0d 04 0c ff ff 08  ................
  0ce0: 00 0a 01 0a 00 0a 12 12 0d 04 0c ff ff 08 00 0a  ................
  0cf0: 02 0a 00 0a 13 12 0d 04 0c ff ff 08 00 0a 03 0a  ................
  0d00: 00 0a 10 12 0d 04 0c ff ff 09 00 0a 00 0a 00 0a  ................
  0d10: 12 12 0d 04 0c ff ff 09 00 0a 01 0a 00 0a 13 12  ................
  0d20: 0d 04 0c ff ff 09 00 0a 02 0a 00 0a 10 12 0d 04  ................
  0d30: 0c ff ff 09 00 0a 03 0a 00 0a 11 12 0d 04 0c ff  ................
  0d40: ff 0a 00 0a 00 0a 00 0a 13 12 0d 04 0c ff ff 0a  ................
  0d50: 00 0a 01 0a 00 0a 10 12 0d 04 0c ff ff 0a 00 0a  ................
  0d60: 02 0a 00 0a 11 12 0d 04 0c ff ff 0a 00 0a 03 0a  ................
  0d70: 00 0a 12 14 1b 5f 50 52 54 00 70 41 50 49 31 60  ....._PRT.pAPI1`
  0d80: a0 0c 92 50 49 43 46 70 50 49 43 31 60 a4 60 08  ...PICFpPIC1`.`.
  0d90: 5f 43 52 53 11 4c 08 0a 88 88 0d 00 02 0c 00 00  _CRS.L..........
  0da0: 00 00 00 ff 00 00 00 00 01 47 01 f8 0c f8 0c 01  .........G......
  0db0: 08 88 0d 00 01 0c 03 00 00 00 00 f7 0c 00 00 f8  ................
  0dc0: 0c 88 0d 00 01 0c 03 00 00 00 0d ff ff 00 00 00  ................
  0dd0: f3 87 17 00 00 0c 03 00 00 00 00 00 00 0a 00 ff  ................
  0de0: ff 0b 00 00 00 00 00 00 00 02 00 87 17 00 00 0c  ................
  0df0: 03 00 00 00 00 00 80 0c 00 ff ff 0d 00 00 00 00  ................
  0e00: 00 00 80 01 00 87 17 00 00 0c 03 00 00 00 00 00  ................
  0e10: 00 00 c0 ff ff df ff 00 00 00 00 00 00 e0 3f 79  ..............?y
  0e20: 00 5b 82 42 f7 49 53 41 5f 08 5f 41 44 52 0c 00  .[.B.ISA_._ADR..
  0e30: 00 1f 00 08 5f 55 49 44 0a 0a 5b 80 50 34 30 43  ...._UID..[.P40C
  0e40: 02 0a 60 0a 04 5b 80 50 34 31 43 02 0a 68 0a 04  ..`..[.P41C..h..
  0e50: 5b 82 42 04 44 4d 41 5f 08 5f 48 49 44 0c 41 d0  [.B.DMA_._HID.A.
  0e60: 02 00 14 31 5f 43 52 53 00 08 44 4d 41 42 11 20  ...1_CRS..DMAB. 
  0e70: 0a 1d 47 01 80 00 80 00 01 20 47 01 00 00 00 00  ..G...... G.....
  0e80: 01 20 47 01 c0 00 c0 00 01 20 2a 10 12 79 00 a4  . G...... *..y..
  0e90: 44 4d 41 42 5b 82 31 46 50 55 5f 08 5f 48 49 44  DMAB[.1FPU_._HID
  0ea0: 0c 41 d0 0c 04 14 21 5f 43 52 53 00 08 46 50 55  .A....!_CRS..FPU
  0eb0: 42 11 10 0a 0d 47 01 f0 00 f0 00 01 10 22 00 20  B....G.......". 
  0ec0: 79 00 a4 46 50 55 42 5b 82 3f 50 49 43 5f 08 5f  y..FPUB[.?PIC_._
  0ed0: 48 49 44 0b 41 d0 14 31 5f 43 52 53 00 08 50 49  HID.A..1_CRS..PI
  0ee0: 43 42 11 20 0a 1d 47 01 20 00 20 00 01 20 47 01  CB. ..G. . .. G.
  0ef0: a0 00 a0 00 01 20 47 01 d0 04 d0 04 01 02 22 04  ..... G.......".
  0f00: 00 79 00 a4 50 49 43 42 5b 82 2e 53 50 4b 5f 08  .y..PICB[..SPK_.
  0f10: 5f 48 49 44 0c 41 d0 08 00 14 1e 5f 43 52 53 00  _HID.A....._CRS.
  0f20: 08 53 50 4b 42 11 0d 0a 0a 47 01 61 00 61 00 01  .SPKB....G.a.a..
  0f30: 01 79 00 a4 53 50 4b 42 5b 82 31 52 54 43 5f 08  .y..SPKB[.1RTC_.
  0f40: 5f 48 49 44 0c 41 d0 0b 00 14 21 5f 43 52 53 00  _HID.A....!_CRS.
  0f50: 08 52 54 43 42 11 10 0a 0d 47 01 70 00 70 00 01  .RTCB....G.p.p..
  0f60: 10 22 00 01 79 00 a4 52 54 43 42 5b 82 31 54 4d  ."..y..RTCB[.1TM
  0f70: 52 5f 08 5f 48 49 44 0c 41 d0 01 00 14 21 5f 43  R_._HID.A....!_C
  0f80: 52 53 00 08 54 4d 52 42 11 10 0a 0d 47 01 40 00  RS..TMRB....G.@.
  0f90: 40 00 01 20 22 01 00 79 00 a4 54 4d 52 42 5b 80  @.. "..y..TMRB[.
  0fa0: 4e 53 49 4f 01 0a 2e 0a 02 5b 81 10 4e 53 49 4f  NSIO.....[..NSIO
  0fb0: 01 49 4e 44 58 08 44 41 54 41 08 5b 86 47 05 49  .INDX.DATA.[.G.I
  0fc0: 4e 44 58 44 41 54 41 01 00 10 43 46 47 5f 08 00  NDXDATA...CFG_..
  0fd0: 20 4c 44 4e 5f 08 00 40 0c 53 49 49 44 08 00 48   LDN_..@.SIID..H
  0fe0: 07 41 43 54 52 08 00 48 17 49 4f 41 48 08 49 4f  .ACTR..H.IOAH.IO
  0ff0: 41 4c 08 00 40 07 49 4e 54 52 08 00 18 44 4d 43  AL..@.INTR...DMC
  1000: 48 08 00 48 3d 4f 50 54 31 08 4f 50 54 32 08 4f  H..H=OPT1.OPT2.O
  1010: 50 54 33 08 5b 80 43 4f 4d 5f 02 0a e0 0a 01 5b  PT3.[.COM_.....[
  1020: 81 23 5c 2f 04 5f 53 42 5f 50 43 49 30 49 53 41  .#\/._SB_PCI0ISA
  1030: 5f 43 4f 4d 5f 01 00 01 4e 53 43 42 03 00 01 4e  _COM_...NSCB...N
  1040: 53 43 41 03 5b 80 46 44 50 41 02 0a e1 0a 01 5b  SCA.[.FDPA.....[
  1050: 81 23 5c 2f 04 5f 53 42 5f 50 43 49 30 49 53 41  .#\/._SB_PCI0ISA
  1060: 5f 46 44 50 41 01 00 02 46 44 44 43 01 00 02 4c  _FDPA...FDDC...L
  1070: 50 54 4f 02 5b 01 4d 54 58 5f 01 14 18 53 49 4f  PTO.[.MTX_...SIO
  1080: 44 01 43 53 49 4f 0a 55 70 68 4c 44 4e 5f 43 53  D.CSIO.UphLDN_CS
  1090: 49 4f 0a aa 14 0c 43 53 49 4f 01 70 68 49 4e 44  IO....CSIO.phIND
  10a0: 58 5b 82 4a 2c 46 44 43 5f 08 5f 48 49 44 0c 41  X[.J,FDC_._HID.A
  10b0: d0 07 00 14 43 06 5f 53 54 41 00 08 52 45 54 5f  ....C._STA..RET_
  10c0: 00 5b 23 4d 54 58 5f ff ff 53 49 4f 44 0a 00 a0  .[#MTX_..SIOD...
  10d0: 2d 47 43 46 44 43 53 49 4f 0a 55 a0 12 41 43 54  -GCFDCSIO.U..ACT
  10e0: 52 43 53 49 4f 0a aa 70 0a 0f 52 45 54 5f a1 0e  RCSIO..p..RET_..
  10f0: 43 53 49 4f 0a aa 70 0a 0d 52 45 54 5f a1 0e 43  CSIO..p..RET_..C
  1100: 53 49 4f 0a aa 70 0a 00 52 45 54 5f 5b 27 4d 54  SIO..p..RET_['MT
  1110: 58 5f a4 52 45 54 5f 14 32 5f 44 49 53 00 5b 23  X_.RET_.2_DIS.[#
  1120: 4d 54 58 5f ff ff 53 49 4f 44 0a 00 43 53 49 4f  MTX_..SIOD..CSIO
  1130: 0a 55 70 00 49 4e 54 52 70 00 41 43 54 52 43 53  .Up.INTRp.ACTRCS
  1140: 49 4f 0a aa 5b 27 4d 54 58 5f 14 4b 11 5f 43 52  IO..['MTX_.K._CR
  1150: 53 00 08 46 44 42 30 11 1b 0a 18 47 01 f0 03 f0  S..FDB0....G....
  1160: 03 08 06 47 01 f7 03 f7 03 01 01 22 40 00 2a 04  ...G......."@.*.
  1170: 08 79 00 8c 46 44 42 30 0a 02 49 4f 4c 30 8c 46  .y..FDB0..IOL0.F
  1180: 44 42 30 0a 03 49 4f 48 30 8c 46 44 42 30 0a 04  DB0..IOH0.FDB0..
  1190: 49 4f 4c 31 8c 46 44 42 30 0a 05 49 4f 48 31 8c  IOL1.FDB0..IOH1.
  11a0: 46 44 42 30 0a 0a 49 32 4c 30 8c 46 44 42 30 0a  FDB0..I2L0.FDB0.
  11b0: 0b 49 32 48 30 8c 46 44 42 30 0a 0c 49 32 4c 31  .I2H0.FDB0..I2L1
  11c0: 8c 46 44 42 30 0a 0d 49 32 48 31 8b 46 44 42 30  .FDB0..I2H1.FDB0
  11d0: 0a 11 49 51 52 5f 8c 46 44 42 30 0a 14 44 41 4d  ..IQR_.FDB0..DAM
  11e0: 5f 5b 23 4d 54 58 5f ff ff 53 49 4f 44 0a 00 43  _[#MTX_..SIOD..C
  11f0: 53 49 4f 0a 55 70 49 4f 41 48 49 4f 48 30 70 49  SIO.UpIOAHIOH0pI
  1200: 4f 41 48 49 4f 48 31 70 49 4f 41 4c 49 4f 4c 30  OAHIOH1pIOALIOL0
  1210: 70 49 4f 41 4c 49 4f 4c 31 70 49 4f 41 48 49 32  pIOALIOL1pIOAHI2
  1220: 48 30 70 49 4f 41 48 49 32 48 31 72 49 4f 41 4c  H0pIOAHI2H1rIOAL
  1230: 0a 07 49 32 4c 30 72 49 4f 41 4c 0a 07 49 32 4c  ..I2L0rIOAL..I2L
  1240: 31 79 01 49 4e 54 52 49 51 52 5f 79 01 44 4d 43  1y.INTRIQR_y.DMC
  1250: 48 44 41 4d 5f 43 53 49 4f 0a aa 5b 27 4d 54 58  HDAM_CSIO..['MTX
  1260: 5f a4 46 44 42 30 14 4e 05 5f 50 52 53 00 08 46  _.FDB0.N._PRS..F
  1270: 44 42 31 11 4c 04 0a 48 30 47 01 f0 03 f0 03 08  DB1.L..H0G......
  1280: 06 47 01 f7 03 f7 03 01 01 22 40 00 2a 04 08 30  .G......."@.*..0
  1290: 47 01 f0 03 f0 03 08 06 47 01 f7 03 f7 03 01 01  G.......G.......
  12a0: 22 f8 10 2a 0e 08 30 47 01 70 03 70 03 08 06 47  "..*..0G.p.p...G
  12b0: 01 77 03 77 03 01 01 22 f8 10 2a 0e 08 38 79 00  .w.w..."..*..8y.
  12c0: a4 46 44 42 31 14 47 0a 5f 53 52 53 01 8c 68 0a  .FDB1.G._SRS..h.
  12d0: 02 49 4f 4c 4f 8c 68 0a 03 49 4f 48 49 8b 68 0a  .IOLO.h..IOHI.h.
  12e0: 11 49 51 52 5f 8c 68 0a 14 44 41 4d 5f 5b 23 4d  .IQR_.h..DAM_[#M
  12f0: 54 58 5f ff ff 53 49 4f 44 0a 00 43 53 49 4f 0a  TX_..SIOD..CSIO.
  1300: 55 70 49 4f 4c 4f 49 4f 41 4c 70 49 4f 48 49 49  UpIOLOIOALpIOHII
  1310: 4f 41 48 43 53 49 4f 0a aa a0 0f 93 49 4f 4c 4f  OAHCSIO.....IOLO
  1320: 0a 70 70 0a 00 46 44 44 43 a0 0f 93 49 4f 4c 4f  .pp..FDDC...IOLO
  1330: 0a f0 70 0a 01 46 44 44 43 43 53 49 4f 0a 55 82  ..p..FDDCCSIO.U.
  1340: 49 51 52 5f 60 74 60 0a 01 49 4e 54 52 82 44 41  IQR_`t`..INTR.DA
  1350: 4d 5f 60 74 60 0a 01 44 4d 43 48 70 01 41 43 54  M_`t`..DMCHp.ACT
  1360: 52 43 53 49 4f 0a aa 5b 27 4d 54 58 5f 5b 82 40  RCSIO..['MTX_[.@
  1370: 06 4b 42 44 5f 08 5f 48 49 44 0c 41 d0 03 03 14  .KBD_._HID.A....
  1380: 25 5f 53 54 41 00 08 52 45 54 5f 00 70 0a 00 52  %_STA..RET_.p..R
  1390: 45 54 5f a0 0c 47 43 4b 42 70 0a 0f 52 45 54 5f  ET_..GCKBp..RET_
  13a0: a4 52 45 54 5f 14 29 5f 43 52 53 00 08 4b 42 44  .RET_.)_CRS..KBD
  13b0: 42 11 18 0a 15 47 01 60 00 60 00 01 01 47 01 64  B....G.`.`...G.d
  13c0: 00 64 00 01 01 22 02 00 79 00 a4 4b 42 44 42 5b  .d..."..y..KBDB[
  13d0: 82 42 08 4d 4f 55 5f 08 5f 48 49 44 0c 41 d0 0f  .B.MOU_._HID.A..
  13e0: 13 14 2b 5f 53 54 41 00 08 52 45 54 5f 00 70 0a  ..+_STA..RET_.p.
  13f0: 00 52 45 54 5f a0 12 47 43 4f 4e a0 0c 47 43 4d  .RET_..GCON..GCM
  1400: 53 70 0a 0f 52 45 54 5f a4 52 45 54 5f 14 45 04  Sp..RET_.RET_.E.
  1410: 5f 43 52 53 00 08 4d 4f 55 42 11 08 0a 05 22 00  _CRS..MOUB....".
  1420: 10 79 00 08 4d 4f 4b 42 11 18 0a 15 47 01 60 00  .y..MOKB....G.`.
  1430: 60 00 01 01 47 01 64 00 64 00 01 01 22 00 10 79  `...G.d.d..."..y
  1440: 00 a0 0a 47 43 4b 42 a4 4d 4f 55 42 a1 06 a4 4d  ...GCKB.MOUB...M
  1450: 4f 4b 42 5b 82 45 22 43 4f 4d 41 08 5f 48 49 44  OKB[.E"COMA._HID
  1460: 0c 41 d0 05 01 08 5f 55 49 44 0a 01 14 43 06 5f  .A...._UID...C._
  1470: 53 54 41 00 08 52 45 54 5f 00 5b 23 4d 54 58 5f  STA..RET_.[#MTX_
  1480: ff ff 53 49 4f 44 0a 04 a0 2d 47 43 53 31 43 53  ..SIOD...-GCS1CS
  1490: 49 4f 0a 55 a0 12 41 43 54 52 43 53 49 4f 0a aa  IO.U..ACTRCSIO..
  14a0: 70 0a 0f 52 45 54 5f a1 0e 43 53 49 4f 0a aa 70  p..RET_..CSIO..p
  14b0: 0a 0d 52 45 54 5f a1 0e 43 53 49 4f 0a aa 70 0a  ..RET_..CSIO..p.
  14c0: 00 52 45 54 5f 5b 27 4d 54 58 5f a4 52 45 54 5f  .RET_['MTX_.RET_
  14d0: 14 32 5f 44 49 53 00 5b 23 4d 54 58 5f ff ff 53  .2_DIS.[#MTX_..S
  14e0: 49 4f 44 0a 04 43 53 49 4f 0a 55 70 00 49 4e 54  IOD..CSIO.Up.INT
  14f0: 52 70 00 41 43 54 52 43 53 49 4f 0a aa 5b 27 4d  Rp.ACTRCSIO..['M
  1500: 54 58 5f 14 47 0a 5f 43 52 53 00 08 43 4d 41 30  TX_.G._CRS..CMA0
  1510: 11 10 0a 0d 47 01 f8 03 f8 03 08 08 22 10 00 79  ....G......."..y
  1520: 00 8c 43 4d 41 30 0a 02 49 4f 4c 30 8c 43 4d 41  ..CMA0..IOL0.CMA
  1530: 30 0a 03 49 4f 48 30 8c 43 4d 41 30 0a 04 49 4f  0..IOH0.CMA0..IO
  1540: 4c 31 8c 43 4d 41 30 0a 05 49 4f 48 31 8b 43 4d  L1.CMA0..IOH1.CM
  1550: 41 30 0a 09 49 51 52 5f 5b 23 4d 54 58 5f ff ff  A0..IQR_[#MTX_..
  1560: 53 49 4f 44 0a 04 43 53 49 4f 0a 55 70 49 4f 41  SIOD..CSIO.UpIOA
  1570: 4c 49 4f 4c 30 70 49 4f 41 4c 49 4f 4c 31 70 49  LIOL0pIOALIOL1pI
  1580: 4f 41 48 49 4f 48 30 70 49 4f 41 48 49 4f 48 31  OAHIOH0pIOAHIOH1
  1590: 79 01 49 4e 54 52 49 51 52 5f 43 53 49 4f 0a aa  y.INTRIQR_CSIO..
  15a0: 5b 27 4d 54 58 5f a4 43 4d 41 30 14 48 04 5f 50  ['MTX_.CMA0.H._P
  15b0: 52 53 00 08 43 4d 41 31 11 36 0a 33 30 47 01 f8  RS..CMA1.6.30G..
  15c0: 03 f8 03 08 08 22 10 00 30 47 01 e8 03 e8 03 08  ....."..0G......
  15d0: 08 22 10 00 30 47 01 f8 02 f8 02 08 08 22 08 00  ."..0G......."..
  15e0: 30 47 01 e8 02 e8 02 08 08 22 08 00 38 79 00 a4  0G......."..8y..
  15f0: 43 4d 41 31 14 45 08 5f 53 52 53 01 8c 68 0a 02  CMA1.E._SRS..h..
  1600: 49 4f 4c 4f 8c 68 0a 03 49 4f 48 49 8b 68 0a 09  IOLO.h..IOHI.h..
  1610: 49 51 52 5f 5b 23 4d 54 58 5f ff ff 53 49 4f 44  IQR_[#MTX_..SIOD
  1620: 0a 04 43 53 49 4f 0a 55 70 49 4f 4c 4f 49 4f 41  ..CSIO.UpIOLOIOA
  1630: 4c 70 49 4f 48 49 49 4f 41 48 82 49 51 52 5f 60  LpIOHIIOAH.IQR_`
  1640: 74 60 0a 01 49 4e 54 52 a0 0f 93 49 4f 4c 4f 0a  t`..INTR...IOLO.
  1650: f8 70 0a 00 4e 53 43 41 a0 0f 93 49 4f 4c 4f 0a  .p..NSCA...IOLO.
  1660: e8 70 0a 03 4e 53 43 41 70 01 41 43 54 52 43 53  .p..NSCAp.ACTRCS
  1670: 49 4f 0a aa 5b 27 4d 54 58 5f 5b 82 48 24 43 4f  IO..['MTX_[.H$CO
  1680: 4d 42 08 5f 48 49 44 0c 41 d0 05 01 08 5f 55 49  MB._HID.A...._UI
  1690: 44 0a 02 14 43 06 5f 53 54 41 00 08 52 45 54 5f  D...C._STA..RET_
  16a0: 00 5b 23 4d 54 58 5f ff ff 53 49 4f 44 0a 05 a0  .[#MTX_..SIOD...
  16b0: 2d 47 43 53 32 43 53 49 4f 0a 55 a0 12 41 43 54  -GCS2CSIO.U..ACT
  16c0: 52 43 53 49 4f 0a aa 70 0a 0f 52 45 54 5f a1 0e  RCSIO..p..RET_..
  16d0: 43 53 49 4f 0a aa 70 0a 0d 52 45 54 5f a1 0e 43  CSIO..p..RET_..C
  16e0: 53 49 4f 0a aa 70 0a 00 52 45 54 5f 5b 27 4d 54  SIO..p..RET_['MT
  16f0: 58 5f a4 52 45 54 5f 14 44 04 5f 44 49 53 00 5b  X_.RET_.D._DIS.[
  1700: 23 4d 54 58 5f ff ff 53 49 4f 44 0a 05 43 53 49  #MTX_..SIOD..CSI
  1710: 4f 0a 55 70 00 49 4e 54 52 70 4f 50 54 31 60 7d  O.Up.INTRpOPT1`}
  1720: 60 0a 20 60 70 60 4f 50 54 31 70 00 41 43 54 52  `. `p`OPT1p.ACTR
  1730: 43 53 49 4f 0a aa 5b 27 4d 54 58 5f 14 47 0a 5f  CSIO..['MTX_.G._
  1740: 43 52 53 00 08 43 4d 42 30 11 10 0a 0d 47 01 f8  CRS..CMB0....G..
  1750: 03 f8 03 08 08 22 10 00 79 00 8c 43 4d 42 30 0a  ....."..y..CMB0.
  1760: 02 49 4f 4c 30 8c 43 4d 42 30 0a 03 49 4f 48 30  .IOL0.CMB0..IOH0
  1770: 8c 43 4d 42 30 0a 04 49 4f 4c 31 8c 43 4d 42 30  .CMB0..IOL1.CMB0
  1780: 0a 05 49 4f 48 31 8b 43 4d 42 30 0a 09 49 51 52  ..IOH1.CMB0..IQR
  1790: 5f 5b 23 4d 54 58 5f ff ff 53 49 4f 44 0a 05 43  _[#MTX_..SIOD..C
  17a0: 53 49 4f 0a 55 70 49 4f 41 4c 49 4f 4c 30 70 49  SIO.UpIOALIOL0pI
  17b0: 4f 41 4c 49 4f 4c 31 70 49 4f 41 48 49 4f 48 30  OALIOL1pIOAHIOH0
  17c0: 70 49 4f 41 48 49 4f 48 31 79 01 49 4e 54 52 49  pIOAHIOH1y.INTRI
  17d0: 51 52 5f 43 53 49 4f 0a aa 5b 27 4d 54 58 5f a4  QR_CSIO..['MTX_.
  17e0: 43 4d 42 30 14 48 04 5f 50 52 53 00 08 43 4d 42  CMB0.H._PRS..CMB
  17f0: 31 11 36 0a 33 30 47 01 f8 02 f8 02 08 08 22 08  1.6.30G.......".
  1800: 00 30 47 01 e8 02 e8 02 08 08 22 08 00 30 47 01  .0G......."..0G.
  1810: f8 03 f8 03 08 08 22 10 00 30 47 01 e8 03 e8 03  ......"..0G.....
  1820: 08 08 22 10 00 38 79 00 a4 43 4d 42 31 14 46 09  .."..8y..CMB1.F.
  1830: 5f 53 52 53 01 8c 68 0a 02 49 4f 4c 4f 8c 68 0a  _SRS..h..IOLO.h.
  1840: 03 49 4f 48 49 8b 68 0a 09 49 51 52 5f 5b 23 4d  .IOHI.h..IQR_[#M
  1850: 54 58 5f ff ff 53 49 4f 44 0a 05 43 53 49 4f 0a  TX_..SIOD..CSIO.
  1860: 55 70 49 4f 4c 4f 49 4f 41 4c 70 49 4f 48 49 49  UpIOLOIOALpIOHII
  1870: 4f 41 48 82 49 51 52 5f 60 74 60 0a 01 49 4e 54  OAH.IQR_`t`..INT
  1880: 52 a0 0f 93 49 4f 4c 4f 0a f8 70 0a 00 4e 53 43  R...IOLO..p..NSC
  1890: 42 a0 0f 93 49 4f 4c 4f 0a e8 70 0a 03 4e 53 43  B...IOLO..p..NSC
  18a0: 42 70 01 41 43 54 52 70 4f 50 54 31 60 7b 60 0a  Bp.ACTRpOPT1`{`.
  18b0: df 60 70 60 4f 50 54 31 43 53 49 4f 0a aa 5b 27  .`p`OPT1CSIO..['
  18c0: 4d 54 58 5f 5b 82 4f 40 50 52 54 5f 08 5f 48 49  MTX_[.O@PRT_._HI
  18d0: 44 0c 41 d0 04 01 14 43 06 5f 53 54 41 00 08 52  D.A....C._STA..R
  18e0: 45 54 5f 00 5b 23 4d 54 58 5f ff ff 53 49 4f 44  ET_.[#MTX_..SIOD
  18f0: 0a 03 a0 2d 47 43 50 50 43 53 49 4f 0a 55 a0 12  ...-GCPPCSIO.U..
  1900: 41 43 54 52 43 53 49 4f 0a aa 70 0a 0f 52 45 54  ACTRCSIO..p..RET
  1910: 5f a1 0e 43 53 49 4f 0a aa 70 0a 0d 52 45 54 5f  _..CSIO..p..RET_
  1920: a1 0e 43 53 49 4f 0a aa 70 0a 00 52 45 54 5f 5b  ..CSIO..p..RET_[
  1930: 27 4d 54 58 5f a4 52 45 54 5f 14 39 5f 44 49 53  'MTX_.RET_.9_DIS
  1940: 00 5b 23 4d 54 58 5f ff ff 53 49 4f 44 0a 03 43  .[#MTX_..SIOD..C
  1950: 53 49 4f 0a 55 70 00 49 4e 54 52 70 0a 04 44 4d  SIO.Up.INTRp..DM
  1960: 43 48 70 00 41 43 54 52 43 53 49 4f 0a aa 5b 27  CHp.ACTRCSIO..['
  1970: 4d 54 58 5f 14 4a 18 5f 43 52 53 00 08 50 54 42  MTX_.J._CRS..PTB
  1980: 30 11 1b 0a 18 47 01 78 03 78 03 08 08 47 01 78  0....G.x.x...G.x
  1990: 07 78 07 08 08 22 80 00 2a 00 08 79 00 8c 50 54  .x..."..*..y..PT
  19a0: 42 30 0a 02 49 4f 4c 30 8c 50 54 42 30 0a 03 49  B0..IOL0.PTB0..I
  19b0: 4f 48 30 8c 50 54 42 30 0a 04 49 4f 4c 31 8c 50  OH0.PTB0..IOL1.P
  19c0: 54 42 30 0a 05 49 4f 48 31 8c 50 54 42 30 0a 06  TB0..IOH1.PTB0..
  19d0: 4c 41 4c 4e 8c 50 54 42 30 0a 07 4c 4c 45 4e 8c  LALN.PTB0..LLEN.
  19e0: 50 54 42 30 0a 0a 49 32 4c 30 8c 50 54 42 30 0a  PTB0..I2L0.PTB0.
  19f0: 0b 49 32 48 30 8c 50 54 42 30 0a 0c 49 32 4c 31  .I2H0.PTB0..I2L1
  1a00: 8c 50 54 42 30 0a 0d 49 32 48 31 8c 50 54 42 30  .PTB0..I2H1.PTB0
  1a10: 0a 0e 48 41 4c 4e 8c 50 54 42 30 0a 0f 48 4c 45  ..HALN.PTB0..HLE
  1a20: 4e 8b 50 54 42 30 0a 11 49 51 52 5f 8c 50 54 42  N.PTB0..IQR_.PTB
  1a30: 30 0a 14 44 41 4d 5f 5b 23 4d 54 58 5f ff ff 53  0..DAM_[#MTX_..S
  1a40: 49 4f 44 0a 03 43 53 49 4f 0a 55 70 49 4f 41 48  IOD..CSIO.UpIOAH
  1a50: 49 4f 48 30 70 49 4f 41 48 49 4f 48 31 70 49 4f  IOH0pIOAHIOH1pIO
  1a60: 41 4c 49 4f 4c 30 70 49 4f 41 4c 49 4f 4c 31 72  ALIOL0pIOALIOL1r
  1a70: 49 4f 41 48 0a 04 49 32 48 30 72 49 4f 41 48 0a  IOAH..I2H0rIOAH.
  1a80: 04 49 32 48 31 70 49 4f 41 4c 49 32 4c 30 70 49  .I2H1pIOALI2L0pI
  1a90: 4f 41 4c 49 32 4c 31 79 01 49 4e 54 52 49 51 52  OALI2L1y.INTRIQR
  1aa0: 5f 79 01 44 4d 43 48 44 41 4d 5f a0 24 93 49 4f  _y.DMCHDAM_.$.IO
  1ab0: 4c 30 0a bc 70 0a 04 4c 41 4c 4e 70 0a 04 4c 4c  L0..p..LALNp..LL
  1ac0: 45 4e 70 0a 04 48 41 4c 4e 70 0a 04 48 4c 45 4e  ENp..HALNp..HLEN
  1ad0: a0 0e 93 44 4d 43 48 0a 04 70 00 44 41 4d 5f a0  ...DMCH..p.DAM_.
  1ae0: 0e 93 49 4e 54 52 0a 00 70 00 49 51 52 5f 43 53  ..INTR..p.IQR_CS
  1af0: 49 4f 0a aa 5b 27 4d 54 58 5f a4 50 54 42 30 14  IO..['MTX_.PTB0.
  1b00: 4f 0f 5f 50 52 53 00 08 50 54 42 31 11 4d 0e 0a  O._PRS..PTB1.M..
  1b10: e9 30 47 01 78 03 78 03 08 08 47 01 78 07 78 07  .0G.x.x...G.x.x.
  1b20: 08 08 22 80 00 2a 00 08 30 47 01 78 02 78 02 08  .."..*..0G.x.x..
  1b30: 08 47 01 78 06 78 06 08 08 22 20 00 2a 00 08 30  .G.x.x..." .*..0
  1b40: 47 01 78 03 78 03 08 08 47 01 78 07 78 07 08 08  G.x.x...G.x.x...
  1b50: 22 f8 10 2a 00 08 30 47 01 78 03 78 03 08 08 47  "..*..0G.x.x...G
  1b60: 01 78 07 78 07 08 08 22 f8 10 2a 0e 08 30 47 01  .x.x..."..*..0G.
  1b70: 78 02 78 02 08 08 47 01 78 06 78 06 08 08 22 f8  x.x...G.x.x...".
  1b80: 10 2a 00 08 30 47 01 78 02 78 02 08 08 47 01 78  .*..0G.x.x...G.x
  1b90: 06 78 06 08 08 22 f8 10 2a 0e 08 30 47 01 78 03  .x..."..*..0G.x.
  1ba0: 78 03 08 08 47 01 78 07 78 07 08 08 22 00 00 2a  x...G.x.x..."..*
  1bb0: 00 08 30 47 01 78 02 78 02 08 08 47 01 78 06 78  ..0G.x.x...G.x.x
  1bc0: 06 08 08 22 00 00 2a 00 08 30 47 01 bc 03 bc 03  ..."..*..0G.....
  1bd0: 04 04 47 01 bc 07 bc 07 04 04 22 00 00 2a 00 08  ..G......."..*..
  1be0: 30 47 01 bc 03 bc 03 04 04 47 01 bc 07 bc 07 04  0G.......G......
  1bf0: 04 22 80 00 2a 00 08 38 79 00 a4 50 54 42 31 14  ."..*..8y..PTB1.
  1c00: 45 0d 5f 53 52 53 01 8c 68 0a 02 49 4f 4c 4f 8c  E._SRS..h..IOLO.
  1c10: 68 0a 03 49 4f 48 49 8b 68 0a 11 49 51 52 5f 8c  h..IOHI.h..IQR_.
  1c20: 68 0a 14 44 41 4d 5f 5b 23 4d 54 58 5f ff ff 53  h..DAM_[#MTX_..S
  1c30: 49 4f 44 0a 03 43 53 49 4f 0a 55 70 49 4f 4c 4f  IOD..CSIO.UpIOLO
  1c40: 49 4f 41 4c 70 49 4f 48 49 49 4f 41 48 a0 0f 93  IOALpIOHIIOAH...
  1c50: 49 4f 4c 4f 0a bc 70 0a 02 4c 50 54 4f a0 28 93  IOLO..p..LPTO.(.
  1c60: 49 4f 4c 4f 0a 78 a0 0f 93 49 4f 48 49 0a 02 70  IOLO.x...IOHI..p
  1c70: 0a 01 4c 50 54 4f a0 0f 93 49 4f 48 49 0a 03 70  ..LPTO...IOHI..p
  1c80: 0a 00 4c 50 54 4f a0 0d 93 49 51 52 5f 00 70 00  ..LPTO...IQR_.p.
  1c90: 49 4e 54 52 a1 0f 82 49 51 52 5f 60 74 60 0a 01  INTR...IQR_`t`..
  1ca0: 49 4e 54 52 a0 0e 93 44 41 4d 5f 00 70 0a 04 44  INTR...DAM_.p..D
  1cb0: 4d 43 48 a1 0f 82 44 41 4d 5f 60 74 60 0a 01 44  MCH...DAM_`t`..D
  1cc0: 4d 43 48 70 01 41 43 54 52 43 53 49 4f 0a aa 5b  MCHp.ACTRCSIO..[
  1cd0: 27 4d 54 58 5f 5b 82 4e 0b 4d 42 49 4f 08 5f 48  'MTX_[.N.MBIO._H
  1ce0: 49 44 0c 41 d0 0c 01 08 5f 55 49 44 0a 0b 14 46  ID.A...._UID...F
  1cf0: 0a 5f 43 52 53 00 08 4d 49 4f 31 11 35 0a 32 47  ._CRS..MIO1.5.2G
  1d00: 01 62 00 62 00 01 02 47 01 65 00 65 00 01 0b 47  .b.b...G.e.e...G
  1d10: 01 e0 00 e0 00 01 10 47 01 00 08 00 08 01 60 47  .......G......`G
  1d20: 01 00 0c 00 0c 01 80 47 01 60 08 60 08 01 a0 79  .......G.`.`...y
  1d30: 00 08 4d 49 4f 32 11 46 04 0a 42 47 01 60 00 60  ..MIO2.F..BG.`.`
  1d40: 00 01 01 47 01 64 00 64 00 01 01 47 01 62 00 62  ...G.d.d...G.b.b
  1d50: 00 01 02 47 01 65 00 65 00 01 0b 47 01 e0 00 e0  ...G.e.e...G....
  1d60: 00 01 10 47 01 00 08 00 08 01 60 47 01 00 0c 00  ...G......`G....
  1d70: 0c 01 80 47 01 60 08 60 08 01 a0 79 00 a0 10 7d  ...G.`.`...y...}
  1d80: 47 43 4b 42 47 43 4d 53 00 a4 4d 49 4f 31 a1 06  GCKBGCMS..MIO1..
  1d90: a4 4d 49 4f 32 5b 81 29 5c 2f 04 5f 53 42 5f 50  .MIO2[.)\/._SB_P
  1da0: 43 49 30 49 53 41 5f 50 34 30 43 01 50 52 51 30  CI0ISA_P40C.PRQ0
  1db0: 08 50 52 51 31 08 50 52 51 32 08 50 52 51 33 08  .PRQ1.PRQ2.PRQ3.
  1dc0: 5b 81 29 5c 2f 04 5f 53 42 5f 50 43 49 30 49 53  [.)\/._SB_PCI0IS
  1dd0: 41 5f 50 34 31 43 01 50 52 51 34 08 50 52 51 35  A_P41C.PRQ4.PRQ5
  1de0: 08 50 52 51 36 08 50 52 51 37 08 5b 82 43 0b 4c  .PRQ6.PRQ7.[.C.L
  1df0: 4e 4b 41 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55  NKA._HID.A...._U
  1e00: 49 44 0a 0c 08 5f 50 52 53 11 09 0a 06 23 f8 9e  ID..._PRS....#..
  1e10: 18 79 00 14 1a 5f 53 54 41 00 70 0a 0b 60 a0 0d  .y..._STA.p..`..
  1e20: 7b 0a 80 50 52 51 30 61 70 0a 09 60 a4 60 14 11  {..PRQ0ap..`.`..
  1e30: 5f 44 49 53 00 7d 50 52 51 30 0a 80 50 52 51 30  _DIS.}PRQ0..PRQ0
  1e40: 14 42 04 5f 43 52 53 00 08 50 52 52 30 11 09 0a  .B._CRS..PRR0...
  1e50: 06 23 10 00 18 79 00 8b 50 52 52 30 0a 01 49 51  .#...y..PRR0..IQ
  1e60: 52 5f 70 50 52 51 30 60 a0 0c 92 95 60 0a 80 70  R_pPRQ0`....`..p
  1e70: 00 49 51 52 5f a1 08 79 01 60 49 51 52 5f a4 50  .IQR_..y.`IQR_.P
  1e80: 52 52 30 14 1c 5f 53 52 53 01 8b 68 0a 01 49 51  RR0.._SRS..h..IQ
  1e90: 52 5f 82 49 51 52 5f 60 76 60 70 60 50 52 51 30  R_.IQR_`v`p`PRQ0
  1ea0: 5b 82 43 0b 4c 4e 4b 42 08 5f 48 49 44 0c 41 d0  [.C.LNKB._HID.A.
  1eb0: 0c 0f 08 5f 55 49 44 0a 0d 08 5f 50 52 53 11 09  ..._UID..._PRS..
  1ec0: 0a 06 23 f8 9e 18 79 00 14 1a 5f 53 54 41 00 70  ..#...y..._STA.p
  1ed0: 0a 0b 60 a0 0d 7b 0a 80 50 52 51 31 61 70 0a 09  ..`..{..PRQ1ap..
  1ee0: 60 a4 60 14 11 5f 44 49 53 00 7d 50 52 51 31 0a  `.`.._DIS.}PRQ1.
  1ef0: 80 50 52 51 31 14 42 04 5f 43 52 53 00 08 50 52  .PRQ1.B._CRS..PR
  1f00: 52 31 11 09 0a 06 23 10 00 18 79 00 8b 50 52 52  R1....#...y..PRR
  1f10: 31 0a 01 49 51 52 5f 70 50 52 51 31 60 a0 0c 92  1..IQR_pPRQ1`...
  1f20: 95 60 0a 80 70 00 49 51 52 5f a1 08 79 01 60 49  .`..p.IQR_..y.`I
  1f30: 51 52 5f a4 50 52 52 31 14 1c 5f 53 52 53 01 8b  QR_.PRR1.._SRS..
  1f40: 68 0a 01 49 51 52 5f 82 49 51 52 5f 60 76 60 70  h..IQR_.IQR_`v`p
  1f50: 60 50 52 51 31 5b 82 43 0b 4c 4e 4b 43 08 5f 48  `PRQ1[.C.LNKC._H
  1f60: 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 0e 08 5f  ID.A...._UID..._
  1f70: 50 52 53 11 09 0a 06 23 f8 9e 18 79 00 14 1a 5f  PRS....#...y..._
  1f80: 53 54 41 00 70 0a 0b 60 a0 0d 7b 0a 80 50 52 51  STA.p..`..{..PRQ
  1f90: 32 61 70 0a 09 60 a4 60 14 11 5f 44 49 53 00 7d  2ap..`.`.._DIS.}
  1fa0: 50 52 51 32 0a 80 50 52 51 32 14 42 04 5f 43 52  PRQ2..PRQ2.B._CR
  1fb0: 53 00 08 50 52 52 32 11 09 0a 06 23 10 00 18 79  S..PRR2....#...y
  1fc0: 00 8b 50 52 52 32 0a 01 49 51 52 5f 70 50 52 51  ..PRR2..IQR_pPRQ
  1fd0: 32 60 a0 0c 92 95 60 0a 80 70 00 49 51 52 5f a1  2`....`..p.IQR_.
  1fe0: 08 79 01 60 49 51 52 5f a4 50 52 52 32 14 1c 5f  .y.`IQR_.PRR2.._
  1ff0: 53 52 53 01 8b 68 0a 01 49 51 52 5f 82 49 51 52  SRS..h..IQR_.IQR
  2000: 5f 60 76 60 70 60 50 52 51 32 5b 82 43 0b 4c 4e  _`v`p`PRQ2[.C.LN
  2010: 4b 44 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49  KD._HID.A...._UI
  2020: 44 0a 0f 08 5f 50 52 53 11 09 0a 06 23 f8 9e 18  D..._PRS....#...
  2030: 79 00 14 1a 5f 53 54 41 00 70 0a 0b 60 a0 0d 7b  y..._STA.p..`..{
  2040: 0a 80 50 52 51 33 61 70 0a 09 60 a4 60 14 11 5f  ..PRQ3ap..`.`.._
  2050: 44 49 53 00 7d 50 52 51 33 0a 80 50 52 51 33 14  DIS.}PRQ3..PRQ3.
  2060: 42 04 5f 43 52 53 00 08 50 52 52 33 11 09 0a 06  B._CRS..PRR3....
  2070: 23 10 00 18 79 00 8b 50 52 52 33 0a 01 49 51 52  #...y..PRR3..IQR
  2080: 5f 70 50 52 51 33 60 a0 0c 92 95 60 0a 80 70 00  _pPRQ3`....`..p.
  2090: 49 51 52 5f a1 08 79 01 60 49 51 52 5f a4 50 52  IQR_..y.`IQR_.PR
  20a0: 52 33 14 1c 5f 53 52 53 01 8b 68 0a 01 49 51 52  R3.._SRS..h..IQR
  20b0: 5f 82 49 51 52 5f 60 76 60 70 60 50 52 51 33 5b  _.IQR_`v`p`PRQ3[
  20c0: 82 43 0b 4c 4e 4b 45 08 5f 48 49 44 0c 41 d0 0c  .C.LNKE._HID.A..
  20d0: 0f 08 5f 55 49 44 0a 10 08 5f 50 52 53 11 09 0a  .._UID..._PRS...
  20e0: 06 23 f8 9e 18 79 00 14 1a 5f 53 54 41 00 70 0a  .#...y..._STA.p.
  20f0: 0b 60 a0 0d 7b 0a 80 50 52 51 34 61 70 0a 09 60  .`..{..PRQ4ap..`
  2100: a4 60 14 11 5f 44 49 53 00 7d 50 52 51 34 0a 80  .`.._DIS.}PRQ4..
  2110: 50 52 51 34 14 42 04 5f 43 52 53 00 08 50 52 52  PRQ4.B._CRS..PRR
  2120: 34 11 09 0a 06 23 10 00 18 79 00 8b 50 52 52 34  4....#...y..PRR4
  2130: 0a 01 49 51 52 5f 70 50 52 51 34 60 a0 0c 92 95  ..IQR_pPRQ4`....
  2140: 60 0a 80 70 00 49 51 52 5f a1 08 79 01 60 49 51  `..p.IQR_..y.`IQ
  2150: 52 5f a4 50 52 52 34 14 1c 5f 53 52 53 01 8b 68  R_.PRR4.._SRS..h
  2160: 0a 01 49 51 52 5f 82 49 51 52 5f 60 76 60 70 60  ..IQR_.IQR_`v`p`
  2170: 50 52 51 34 5b 82 43 0b 4c 4e 4b 46 08 5f 48 49  PRQ4[.C.LNKF._HI
  2180: 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 11 08 5f 50  D.A...._UID..._P
  2190: 52 53 11 09 0a 06 23 f8 9e 18 79 00 14 1a 5f 53  RS....#...y..._S
  21a0: 54 41 00 70 0a 0b 60 a0 0d 7b 0a 80 50 52 51 35  TA.p..`..{..PRQ5
  21b0: 61 70 0a 09 60 a4 60 14 11 5f 44 49 53 00 7d 50  ap..`.`.._DIS.}P
  21c0: 52 51 35 0a 80 50 52 51 35 14 42 04 5f 43 52 53  RQ5..PRQ5.B._CRS
  21d0: 00 08 50 52 52 35 11 09 0a 06 23 10 00 18 79 00  ..PRR5....#...y.
  21e0: 8b 50 52 52 35 0a 01 49 51 52 5f 70 50 52 51 35  .PRR5..IQR_pPRQ5
  21f0: 60 a0 0c 92 95 60 0a 80 70 00 49 51 52 5f a1 08  `....`..p.IQR_..
  2200: 79 01 60 49 51 52 5f a4 50 52 52 35 14 1c 5f 53  y.`IQR_.PRR5.._S
  2210: 52 53 01 8b 68 0a 01 49 51 52 5f 82 49 51 52 5f  RS..h..IQR_.IQR_
  2220: 60 76 60 70 60 50 52 51 35 5b 82 43 0b 4c 4e 4b  `v`p`PRQ5[.C.LNK
  2230: 47 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44  G._HID.A...._UID
  2240: 0a 12 08 5f 50 52 53 11 09 0a 06 23 f8 9e 18 79  ..._PRS....#...y
  2250: 00 14 1a 5f 53 54 41 00 70 0a 0b 60 a0 0d 7b 0a  ..._STA.p..`..{.
  2260: 80 50 52 51 36 61 70 0a 09 60 a4 60 14 11 5f 44  .PRQ6ap..`.`.._D
  2270: 49 53 00 7d 50 52 51 36 0a 80 50 52 51 36 14 42  IS.}PRQ6..PRQ6.B
  2280: 04 5f 43 52 53 00 08 50 52 52 36 11 09 0a 06 23  ._CRS..PRR6....#
  2290: 10 00 18 79 00 8b 50 52 52 36 0a 01 49 51 52 5f  ...y..PRR6..IQR_
  22a0: 70 50 52 51 36 60 a0 0c 92 95 60 0a 80 70 00 49  pPRQ6`....`..p.I
  22b0: 51 52 5f a1 08 79 01 60 49 51 52 5f a4 50 52 52  QR_..y.`IQR_.PRR
  22c0: 36 14 1c 5f 53 52 53 01 8b 68 0a 01 49 51 52 5f  6.._SRS..h..IQR_
  22d0: 82 49 51 52 5f 60 76 60 70 60 50 52 51 36 5b 82  .IQR_`v`p`PRQ6[.
  22e0: 43 0b 4c 4e 4b 48 08 5f 48 49 44 0c 41 d0 0c 0f  C.LNKH._HID.A...
  22f0: 08 5f 55 49 44 0a 13 08 5f 50 52 53 11 09 0a 06  ._UID..._PRS....
  2300: 23 f8 9e 18 79 00 14 1a 5f 53 54 41 00 70 0a 0b  #...y..._STA.p..
  2310: 60 a0 0d 7b 0a 80 50 52 51 37 61 70 0a 09 60 a4  `..{..PRQ7ap..`.
  2320: 60 14 11 5f 44 49 53 00 7d 50 52 51 37 0a 80 50  `.._DIS.}PRQ7..P
  2330: 52 51 37 14 42 04 5f 43 52 53 00 08 50 52 52 37  RQ7.B._CRS..PRR7
  2340: 11 09 0a 06 23 10 00 18 79 00 8b 50 52 52 37 0a  ....#...y..PRR7.
  2350: 01 49 51 52 5f 70 50 52 51 37 60 a0 0c 92 95 60  .IQR_pPRQ7`....`
  2360: 0a 80 70 00 49 51 52 5f a1 08 79 01 60 49 51 52  ..p.IQR_..y.`IQR
  2370: 5f a4 50 52 52 37 14 1c 5f 53 52 53 01 8b 68 0a  _.PRR7.._SRS..h.
  2380: 01 49 51 52 5f 82 49 51 52 5f 60 76 60 70 60 50  .IQR_.IQR_`v`p`P
  2390: 52 51 37                                         RQ7

FACS @ 0x3ff77000
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0xfd5a8
  0000: 46 41 43 50 74 00 00 00 01 fd 44 45 4c 4c 20 20  FACPt.....DELL  
  0010: 47 58 32 34 30 20 20 00 08 00 00 00 41 53 4c 20  GX240  .....ASL 
  0020: 61 00 00 00 00 70 f7 3f 22 3c fe ff 01 00 09 00  a....p.?"<......
  0030: b2 00 00 00 70 71 00 00 00 08 00 00 00 00 00 00  ....pq..........
  0040: 04 08 00 00 00 00 00 00 00 00 00 00 08 08 00 00  ................
  0050: 28 08 00 00 00 00 00 00 04 02 00 04 04 00 00 00  (...............
  0060: f4 01 88 13 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0070: a5 00 00 00                                      ....

SSDT @ 0xfffe5fb5
  0000: 53 53 44 54 a7 00 00 00 01 e3 44 45 4c 4c 00 00  SSDT......DELL..
  0010: 73 74 5f 65 78 00 00 00 00 10 00 00 4d 53 46 54  st_ex.......MSFT
  0020: 0d 00 00 01 14 07 55 53 45 53 00 a3 10 49 05 5c  ......USES...I.\
  0030: 00 08 5c 5f 53 30 5f 12 0a 04 0a 00 0a 00 0a 00  ..\_S0_.........
  0040: 0a 00 08 5c 5f 53 31 5f 12 0a 04 0a 04 0a 04 0a  ...\_S1_........
  0050: 00 0a 00 08 5c 5f 53 33 5f 12 0a 04 0a 03 0a 03  ....\_S3_.......
  0060: 0a 00 0a 00 08 5c 5f 53 34 5f 12 0a 04 0a 00 0a  .....\_S4_......
  0070: 00 0a 00 0a 00 08 5c 5f 53 35 5f 12 0a 04 0a 02  ......\_S5_.....
  0080: 0a 02 0a 00 0a 00 10 20 5c 2f 04 5f 53 42 5f 50  ....... \/._SB_P
  0090: 43 49 30 49 53 41 5f 4b 42 44 5f 08 5f 50 52 57  CI0ISA_KBD_._PRW
  00a0: 12 06 02 0a 08 0a 03                             .......

APIC @ 0xfd61c
  0000: 41 50 49 43 5c 00 00 00 01 4e 44 45 4c 4c 20 20  APIC\....NDELL  
  0010: 47 58 32 34 30 20 20 00 08 00 00 00 41 53 4c 20  GX240  .....ASL 
  0020: 61 00 00 00 00 00 e0 fe 01 00 00 00 00 08 01 00  a...............
  0030: 01 00 00 00 00 08 02 01 00 00 00 00 01 0c 01 00  ................
  0040: 00 00 c0 fe 00 00 00 00 02 0a 00 00 02 00 00 00  ................
  0050: 00 00 02 0a 00 09 09 00 00 00 0d 00              ............

BOOT @ 0xfd678
  0000: 42 4f 4f 54 28 00 00 00 01 ea 44 45 4c 4c 20 20  BOOT(.....DELL  
  0010: 47 58 32 34 30 20 20 00 08 00 00 00 41 53 4c 20  GX240  .....ASL 
  0020: 61 00 00 00 7a 00 00 00                          a...z...

RSDT @ 0xfd574
  0000: 52 53 44 54 34 00 00 00 01 54 44 45 4c 4c 20 20  RSDT4....TDELL  
  0010: 47 58 32 34 30 20 20 00 08 00 00 00 41 53 4c 20  GX240  .....ASL 
  0020: 61 00 00 00 a8 d5 0f 00 b5 5f fe ff 1c d6 0f 00  a........_......
  0030: 78 d6 0f 00                                      x...

RSD PTR @ 0xfd560
  0000: 52 53 44 20 50 54 52 20 28 44 45 4c 4c 20 20 00  RSD PTR (DELL  .
  0010: 74 d5 0f 00                                      t...


--0-1877047116-1180866252=:73709--
