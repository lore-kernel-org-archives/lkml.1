Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZITIVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZITIVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 04:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZITIVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 04:21:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:11531 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbZITIVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 04:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=pfdFL4TSC+XGUydew9gWiSUPwuTkx4+o5U2fkPWIo1sLeNLv/HCg9feuI3Alhlbafa
         /lO5YtwgNL6k6E6W+QAoJPsTtqRzTjOezZGgdHbHrtObT7Hm+ZzvuOl4HmRQEvuBGvP4
         JOBWHMMg5ejA59vpUU3me84ifkbrsZOHCmNOw=
MIME-Version: 1.0
From: wixor <wixorpeek@gmail.com>
Date: Sun, 20 Sep 2009 10:20:57 +0200
Message-ID: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
Subject: it87 sensors need an ACPI driver (2.6.31)
To: lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
with recent upgrade to 2.6.31 I get

it87: Found IT8712F chip at 0x290, revision 7
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__
[0x295-0x296]
ACPI: Device needs an ACPI driver
FATAL: Error inserting it87
(/lib/modules/2.6.31/kernel/drivers/hwmon/it87.ko): Device or resource
busy

when trying to load it87 module. On previous kernels the module worked
fine. I tried grepping for IP__ in acpi dump and found this:

OperationRegion (IP, SystemIO, 0x0295, 0x02)
Field (IP, ByteAcc, NoLock, Preserve)
{
    INDX,   8,
    DAT0,   8
}

I have also discovered that dsdt contains description of what is
connected to each it87 input. Maybe it has also some code to access
the chip? In /proc/acpi I can read only one temperature, while the
chip measures three temperatures, fan speeds and voltages. This is
desktop pc with ASUS A8N1-E maniboard, athlon64 and nforce4 chipset.

Thanks for your time.
