Return-Path: <linux-kernel-owner+w=401wt.eu-S1752038AbYAAWWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbYAAWWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 17:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbYAAWVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 17:21:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46918 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYAAWVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 17:21:53 -0500
Date: Tue, 1 Jan 2008 23:19:55 +0000
From: Pavel Machek <pavel@ucw.cz>
To: ACPI mailing list <linux-acpi@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Kohjinsha sleep problems
Message-ID: <20080101231955.GA1931@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On kohjinsha, wakeup code does not seem to be reached at all. I tried
looking around FACS, but it seems very empty:

(none):/data/l/kohji# acpidump -t FACS
FACS @ 0x1f7bffc0
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00
FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
  0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................

(none):/data/l/kohji# iasl -d FACS.aml

Intel ACPI Component Architecture
AML Disassembler version 20060912 [Dec 20 2006]
Copyright (C) 2000 - 2006 Intel Corporation
Supports ACPI Specification Revision 3.0a

Loading Acpi table from file FACS.aml
iasl[1864]: segfault at 080e5000 eip 08062f5c esp bf9d1e50 error 4
Segmentation fault
(none):/data/l/kohji#

In dmesg I find:

DMI 2.3 present.
ACPI: RSDP 000E9010, 0014 (r0 OID_00)
ACPI: RSDT 1F7B1E40, 0030 (r1 AMD    RSDT_000 31303030 AMD  31303030)
ACPI: FACP 1F7B1D40, 0084 (r1 AMD    FACP_000 31303030 AMD  31303030)
ACPI: DSDT 1F7B0000, 1D30 (r1 INSYDE CS553x       1007 INTL 20030122)
ACPI: FACS 1F7BFFC0, 0040
ACPI: BOOT 1F7B1DD0, 0028 (r1 AMD    BOOT_000 31303030 AMD  31303030)
ACPI: DBGP 1F7B1E00, 0034 (r1 AMD    DBGP_000 31303030 AMD  31303030)
ACPI: PM-Timer IO Port: 0x9c10

What should be done to debug this? I guess FACS is strictly neccessary
for sleep support?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
