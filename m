Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbZAVLA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbZAVLA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 06:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZAVLAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 06:00:13 -0500
Received: from h4320.serverkompetenz.net ([81.169.172.102]:35631 "EHLO
	www.deb-support.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333AbZAVLAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 06:00:11 -0500
Date: Thu, 22 Jan 2009 11:00:04 +0000
From: Michael Bramer <michael@debsupport.de>
To: Niels de Vos <niels.devos@wincor-nixdorf.com>
Cc: Tosoni <jp.tosoni@acksys.fr>, "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Paulius Zaleckas'" <paulius.zaleckas@teltonika.lt>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/8250_pci.c (add support for '8-port RS-232 MIC-3620 from advantech'
Message-ID: <20090122110003.GA24450@deb-support.de>
References: <6E0880DF84464BF2AA0275ABFFCCDAF2@acksys.local> <49783679.8010005@wincor-nixdorf.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49783679.8010005@wincor-nixdorf.com>
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: grisu@deb-support.de
X-SA-Exim-Scanned: No (on www.deb-support.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 10:03:53AM +0100, Niels de Vos wrote:
> Tosoni wrote:
> >> On Wed, Jan 21, 2009 at 12:32:15PM +0000, Alan Cox wrote:
> >>>>>>  static struct pci_device_id serial_pci_tbl[] = {
> >>>>>> +       {       PCI_VENDOR_ID_ADVANTECH,
> >> PCI_DEVICE_ID_ADVANTECH_PCI3620,
> >>>>>> +               0x3620, PCI_ANY_ID, 0, 0,
> >>>> Why not use PCI_VENDOR_ID_ADVANTECH as PCI_SUBVENDOR_ID too?
> >>> The Advantech vendor id is not 0x3620. This confused me as
> >> well which is
> >>> why I asked for an lspci. Advantech has stuck the device id in the
> >>> subvendor bits and '1' in the subdevice (so it should be 1 not
> >>> PCI_ANY_ID).
> >> is this better?
> >>
> >> +       {       PCI_VENDOR_ID_ADVANTECH,
> >> PCI_DEVICE_ID_ADVANTECH_PCI3620,
> >> +               PCI_DEVICE_ID_ADVANTECH_PCI3620, 1, 0, 0,
> > 
> > Since the name describes a device id where it should be a (sub)vendor id,
> > I would suggest that you add a line of comment to explain the case.
> > So that no one will be tempted to change it back to PCI_VENDOR_ID_ADVANTECH
> > in the future.
> 
> Definitely!

Is the patch now ok?

----
This Patch add the device information for the
MIC-3620 8-port RS-232 cPCI card from Advantech Co. Ltd.

Signed-off-by: Michael Bramer <grisu@deb-support.de>
--- a/drivers/serial/8250_pci.c	2008-07-13 23:51:29.000000000 +0200
+++ b/drivers/serial/8250_pci.c	2009-01-17 21:37:37.000000000 +0100
@@ -769,6 +768,8 @@
 #define PCI_SUBDEVICE_ID_OCTPRO422	0x0208
 #define PCI_SUBDEVICE_ID_POCTAL232	0x0308
 #define PCI_SUBDEVICE_ID_POCTAL422	0x0408
+#define PCI_VENDOR_ID_ADVANTECH         0x13fe
+#define PCI_DEVICE_ID_ADVANTECH_PCI3620 0x3620
 
 /*
  * Master list of serial port init/setup/exit quirks.
@@ -2054,6 +2041,10 @@
 #endif
 
 static struct pci_device_id serial_pci_tbl[] = {
+	// Advantech use PCI_DEVICE_ID_ADVANTECH_PCI3620 (0x3620) as 'PCI_SUBVENDOR_ID'
+	{	PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
+		PCI_DEVICE_ID_ADVANTECH_PCI3620, 1, 0, 0,
+		pbn_b2_8_921600 },
 	{	PCI_VENDOR_ID_V3, PCI_DEVICE_ID_V3_V960,
 		PCI_SUBVENDOR_ID_CONNECT_TECH,
 		PCI_SUBDEVICE_ID_CONNECT_TECH_BH8_232, 0, 0,
----


Gruss
Grisu
-- 
Michael Bramer  -- http://www.feuerwehr.kreuzau.de/wiki/
PGP: finger grisu@db.debian.org  -- Linux Sysadmin   -- Use Debian Linux
"Wenn ich die Folgen geahnt hätte, wäre ich Uhrmacher geworden!"
                                                 --- Albert Einstein
