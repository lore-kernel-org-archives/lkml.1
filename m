Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbXFYRp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbXFYRp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 13:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750881AbXFYRpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 13:45:51 -0400
Received: from web63503.mail.re1.yahoo.com ([69.147.97.58]:36767 "HELO
	web63503.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750718AbXFYRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 13:45:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=P3QCeDYG6U+2T6DA3ySVZMiTjVTtFL+aq2ku/gsBIyJWtWwa4/+kABf+lVaviX6mktYoraRfA7mscDAS7Si9Lno1ahKbsvR490H3vkTSkFrjDMPhI9lh1iYw1OVde0sIfNj+ksiW/zyw2x7wBy9ebah2JnoKKPsA6BvHv57/N1Y=;
X-YMail-OSG: W2y0MW0VM1ko6ObSmrikUVqUMN.eBSkG22p2RdaAiRE68tStk1GfbzL6Q0lrMzQ4zA--
Date: Mon, 25 Jun 2007 10:45:49 -0700 (PDT)
From: Ioannis Barkas <risc4all@yahoo.com>
Subject: PATCH] gadget_serial.txt: Documentation clarifications and new windows driver!
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <678206.67912.qm@web63503.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes errors and supports multiple
architectures.Corrected errors and warnings are:

Errors:
(E22.1.1003) Section [SourceDisksNames] not defined. 
(E22.1.1017) Primary revision number must be greater
than 0. 
(E22.1.1110) File "usbser.sys" is not listed in the
[SourceDisksFiles]. 

Warnings:
(W22.1.2111) [SourceDisksFiles] section not defined -
full CopyFiles checking not done. 
(W22.1.2034) No destination dir was defined for this
section. Your driver is being
copied to the DefaultDestDir location specified
(10,System32\Drivers). 




Hello we are Ioannis Barkas (risc4all@yahoo.com) and
Nikos Barkas (doubl3nuts@yahoo.com).


There are some errors in
linux-2.6.21/Documentation/usb/gadget_serial.txt.
After fixing the errors, we thought to add support in
it for newer ms OSes.

We were ...surprised on the first place to see .inf
files inside the Linux kernel!

The original text file contains a windows information
file which is not correct. 
Moreover the .inf file in it has 4 errors and 2
warnings while ours has one
error(the .cat which is commented as the driver is not
digitally signed) and no warning.
We also modified a documentation section referring to
windows 98 as the usbser.sys is not
included in any driver**.cab as the text suggests in
contrast to win Me where it is
supplied. Furthermore, the original .inf was outdated
for AMD64 and IA64 systems as it
was limited to work on 32 bit architectures while our
new one works in three architectures
[supposing that ms supplies usbser.sys in IA64
media-we do not have such media or system
for verification].The driver is suitable for Windows
98,Me,2000,XP,2003,Vista.

    Cc: Al Borchers <alborchers@steinerpoint.com>

There is the patch(we do not attach it as many people
suggest not to do so) from diff -u:

--- /linux-2.6.21/Documentation/usb/gadget_serial.txt
2007-04-26 04:08:32.000000000 +0300
+++ /linux/Documentation/usb/gadget_serial.txt
2007-06-12 13:20:12.000000000 +0300
@@ -1,6 +1,6 @@
 
-                 Linux Gadget Serial Driver v2.0
-                           11/20/2004
+                 Linux Gadget Serial Driver v3.1
+                           06/11/2007
 
 
 License and Disclaimer
@@ -37,8 +37,8 @@
 This document assumes that you are familiar with
Linux and
 Windows and know how to configure and build Linux
kernels, run
 standard utilities, use minicom and HyperTerminal,
and work with
-USB and serial devices.  It also assumes you
configure the Linux
-gadget and usb drivers as modules.
+USB and serial devices.  It also assumes that you can
configure
+the Linux gadget and usb drivers as modules.
 
 
 Overview
@@ -100,7 +100,7 @@
 To use the gadget serial driver you must configure
the Linux gadget
 side kernel for "Support for USB Gadgets", for a "USB
Peripheral
 Controller" (for example, net2280), and for the
"Serial Gadget"
-driver.  All this are listed under "USB Gadget
Support" when
+driver.  All these are listed under "USB Gadget
Support" when
 configuring the kernel.  Then rebuild and install the
kernel or
 modules.
 
@@ -137,25 +137,39 @@
 To use the Windows ACM driver you must have the files
"gserial.inf"
 and "usbser.sys" together in a folder on the Windows
machine.
 
-The "gserial.inf" file is given here.
+The "gserial.inf" file for windows
98,Me,2000,XP,2003,Vista is given
+below and has passed chkinf 2.5 tests.  It supports
x86, AMD64, IA64
+systems now!  It has 1 non important error about
missing WHQL digital
+signature catalog (.cat) file directive.  If anyone
wants to pay ms
+for digital signature, remove the ";" in front of the
CatalogFile.
 
 -------------------- CUT HERE --------------------
 [Version]
-Signature="$Windows NT$"
-Class=Ports
-ClassGuid={4D36E978-E325-11CE-BFC1-08002BE10318}
-Provider=%LINUX%
-DriverVer=08/17/2004,0.0.2.0
+Signature    = "$Chicago$"
+Class        = Ports
+ClassGuid    = {4D36E978-E325-11CE-BFC1-08002BE10318}
+Provider     = %TUX%
+DriverVer    = 06/11/2007,3.1.0.0
+;CatalogFile  = Gserial.cat
+
 ; Copyright (C) 2004 Al Borchers
(alborchers@steinerpoint.com)
+; Copyright (C) 2007 Ioannis Barkas
(risc4all@yahoo.com)
+; Copyright (C) 2007 Nikos Barkas
(doubl3nuts@yahoo.com)
 
 [Manufacturer]
-%LINUX%=GSerialDeviceList
+%TUX%=GSerialDeviceList, NTx86, NTamd64, NTia64
 
 [GSerialDeviceList]
 %GSERIAL%=GSerialInstall, USB\VID_0525&PID_A4A7
 
-[DestinationDirs]
-DefaultDestDir=10,System32\Drivers
+[GSerialDeviceList.NTx86]
+%GSERIAL%=GSerialInstall, USB\VID_0525&PID_A4A7
+
+[GSerialDeviceList.NTamd64]
+%GSERIAL%=GSerialInstall, USB\VID_0525&PID_A4A7
+
+[GSerialDeviceList.NTia64]
+%GSERIAL%=GSerialInstall, USB\VID_0525&PID_A4A7
 
 [GSerialInstall]
 CopyFiles=GSerialCopyFiles
@@ -164,6 +178,16 @@
 [GSerialCopyFiles]
 usbser.sys
 
+[SourceDisksFiles]
+usbser.sys=1
+
+[SourceDisksNames]
+1=%Linux_Gadget_Rocks%,,,
+
+[DestinationDirs]
+DefaultDestDir           = 10
+GSerialCopyFiles         = 12
+
 [GSerialAddReg]
 HKR,,DevLoader,,*ntkern
 HKR,,NTMPDriver,,usbser.sys
@@ -181,9 +205,10 @@
 LoadOrderGroup = Base
 
 [Strings]
-LINUX = "Linux"
-GSERIAL = "Gadget Serial"
+TUX                  = "Linux"
+GSERIAL              = "Gadget Serial"
 GSERIAL_DISPLAY_NAME = "USB Gadget Serial Driver"
+LINUX_GADGET_ROCKS   = "Linux USB Gadget Serial
Driver"
 -------------------- CUT HERE --------------------
 
 The "usbser.sys" file comes with various versions of
Windows.
@@ -191,8 +216,8 @@
 
   C:\WINDOWS\Driver Cache\i386\driver.cab
 
-Or it can be found on the Windows 98SE CD in the
"win98" folder
-in the "DRIVER11.CAB" through "DRIVER20.CAB" cab
files.  You will
+Or it can be found on the Windows Me CD in the
"win9x" folder
+in the "DRIVER5.CAB" through "DRIVER7.CAB" cab files.
 You will
 need the DOS "expand" program, the Cygwin
"cabextract" program, or
 a similar program to unpack these cab files and
extract "usbser.sys".
 
@@ -203,10 +228,11 @@
 
 (Thanks to Nishant Kamat for pointing out this DOS
command.)
 
-When the gadget serial driver is loaded and the USB
device connected
-to the Windows host with a USB cable, Windows should
recognize the
-gadget serial device and ask for a driver.  Tell
Windows to find the
-driver in the folder that contains "gserial.inf" and
"usbser.sys".
+When the gadget serial driver is loaded and the USB
device is
+connected to the Windows host with a USB cable,
Windows should
+recognize the gadget serial device and ask for a
driver.  Tell
+Windows to find the driver in the folder that
contains "gserial.inf"
+and "usbser.sys".
 
 For example, on Windows XP, when the gadget serial
device is first
 plugged in, the "Found New Hardware Wizard" starts
up.  Select


 
____________________________________________________________________________________
Bored stiff? Loosen up... 
Download and play hundreds of games for free on Yahoo! Games.
http://games.yahoo.com/games/front
