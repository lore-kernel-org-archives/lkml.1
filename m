Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbXFCOjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbXFCOjE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 10:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbXFCOix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 10:38:53 -0400
Received: from web50103.mail.re2.yahoo.com ([206.190.38.31]:37519 "HELO
	web50103.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751773AbXFCOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 10:38:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Hl23ivDWCMr4wBiy5JJsjBFZHjnYCCPO4qsbpNNcyh2w/mIxwP33fhi64co2hhYxaNLacXpEB4BePL5E1CYHVNmVBSO/FmacqNOmg862MQMmDIzs3X0rD5zycfWSrzuvZsBiYsidFW0z1f7CXpaY3ZQWLnXGJBgEZ/ID02en40U=;
X-YMail-OSG: GLYbbOYVM1k1OIAMq5BudDKdDLGBl6jsip2XA..5rMd5hu2iUEswimVgKixR4W_taSnIkYO9f1OyprFof5EfzU_cz.fLAxMJu46gx8P6tT8SEdzmDy56b0nZt4V33KdzlLc8plKZ6H4-
Date: Sun, 3 Jun 2007 07:38:51 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: [PATCH 0/36] drivers edac new features  drivers and fixes
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <750178.84820.qm@web50103.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Douglas Thompson <dougthompson@xmisson.com>

Patches are against 2.6.22-rc3-mm1

This series of patches enhances the feature set of EDAC, fixes some
bugs and
adds some new memory drivers.

The patches do the following:

1- Various cleanups
2- Altered the file 'edac_mc.c' to be for memory controller code only.
Moved the
module startup and exit code to edac_module.c
3- The 'core' of EDAC is now the 'edac_core.ko' module
4- Added the new 'edac_device' class of EDAC controller. With this new
class, non-memory ECC hardware detectors can be manged, such as
L1/L2 ECC detectors, DMA, Central switches, Fibric switches, etc.
File 'edac_device.c' handles this new class
5- Moved sysfs related operations into their respective files,
'edac_mc_sysfs.c'
for Memory devices and 'edac_device_sysfs.c' for edac_device devices.
6- changed operation from semaphore to mutex operation
7- Modified operaton of PCI polling to be it own class instead of
built-in into
the EDAC CORE
8- Modified the CORE to use work queues instead of a dedicated kthread
for polling
9-New memory controller drivers:  Intel 5000X, Intel 30X0
10- Added sysfs controlls ability to the top level of memory and
edac_device controllers.
Low level driver can now add their own specific attributes and
controllers. 
Useful for accessing error injection hardware registers.
11- Patches that perform some cleanup via the Lindent script for code
conformance.
12- A NMI hook mechanism to provide notification to the low level
driver
if a NMI event occurred during a poll operation, and thus re-poll the
device.

The features have come from their respective developers on MIPS, PPC,
x86, and 
others.



