Return-Path: <linux-kernel-owner+w=401wt.eu-S1751264AbXGXOb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264AbXGXOb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbXGXOal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:30:41 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:38994 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210AbXGXOaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:30:39 -0400
Date: Tue, 24 Jul 2007 16:28:05 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: bjorn.helgaas@hp.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
Message-ID: <20070724162805.76ea8328@frecb000686.frec.bull.fr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/07/2007 16:35:18,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 24/07/2007 16:35:19,
	Serialize complete at 24/07/2007 16:35:19
Content-Type: multipart/mixed; boundary=MP_C4WVx6kfD1CRNiD7sHUSZje
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_C4WVx6kfD1CRNiD7sHUSZje
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline


  Hi Bjorn,

 your commit 7e92b4fc345f5b6f57585fbe5ffdb0f24d7c9b26 broke the serial cons=
ole
on my box. Adding 'legacy_serial.force=3D1' to my boot param as a workaround
solves the issue, but this may be hiding bugs in Linux PnP support or
in my firmware.

  The box is a dual HT Xeon running a vanilla 2.6.22 x86_64 kernel

  here is my .config:

CONFIG_PNP=3Dy
CONFIG_SERIAL_8250=3Dy
CONFIG_SERIAL_8250_CONSOLE=3Dy
CONFIG_SERIAL_8250_PCI=3Dy
CONFIG_SERIAL_8250_PNP=3Dy
CONFIG_SERIAL_8250_NR_UARTS=3D4
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
CONFIG_SERIAL_8250_DETECT_IRQ=3Dy

  lspci output attached.
=20
  Any ideas to help me debug this?

  If you need more info (like DSDT dump), just ask.

  Thanks,

  S=C3=A9bastien.



--MP_C4WVx6kfD1CRNiD7sHUSZje
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; name=lspci.txt
Content-Disposition: attachment; filename=lspci.txt

00:00.0 Host bridge: Intel Corporation E7520 Memory Controller Hub (rev 0c)
00:00.1 Class ff00: Intel Corporation E7525/E7520 Error Reporting Registers (rev 0c)
00:01.0 System peripheral: Intel Corporation E7520 DMA Controller (rev 0c)
00:02.0 PCI bridge: Intel Corporation E7525/E7520/E7320 PCI Express Port A (rev 0c)
00:04.0 PCI bridge: Intel Corporation E7525/E7520 PCI Express Port B (rev 0c)
00:05.0 PCI bridge: Intel Corporation E7520 PCI Express Port B1 (rev 0c)
00:06.0 PCI bridge: Intel Corporation E7520 PCI Express Port C (rev 0c)
00:07.0 PCI bridge: Intel Corporation E7520 PCI Express Port C1 (rev 0c)
00:1c.0 PCI bridge: Intel Corporation 6300ESB 64-bit PCI-X Bridge (rev 02)
00:1d.0 USB Controller: Intel Corporation 6300ESB USB Universal Host Controller (rev 02)
00:1d.1 USB Controller: Intel Corporation 6300ESB USB Universal Host Controller (rev 02)
00:1d.4 System peripheral: Intel Corporation 6300ESB Watchdog Timer (rev 02)
00:1d.5 PIC: Intel Corporation 6300ESB I/O Advanced Programmable Interrupt Controller (rev 02)
00:1d.7 USB Controller: Intel Corporation 6300ESB USB2 Enhanced Host Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 0a)
00:1f.0 ISA bridge: Intel Corporation 6300ESB LPC Interface Controller (rev 02)
00:1f.1 IDE interface: Intel Corporation 6300ESB PATA Storage Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 6300ESB SMBus Controller (rev 02)
01:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge A (rev 09)
01:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge B (rev 09)
02:01.0 Ethernet controller: Intel Corporation 82544EI Gigabit Ethernet Controller (Copper) (rev 02)
02:03.0 SCSI storage controller: Adaptec AIC-7902B U320 (rev 10)
02:03.1 SCSI storage controller: Adaptec AIC-7902B U320 (rev 10)
03:01.0 Ethernet controller: Intel Corporation 82544EI Gigabit Ethernet Controller (Copper) (rev 02)
08:01.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE]
08:02.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller
08:03.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller

--MP_C4WVx6kfD1CRNiD7sHUSZje--
