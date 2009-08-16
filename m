Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZHPJ7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZHPJ7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZHPJ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:59:39 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:54155 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZHPJ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=YYXnQZTZvsanJ5j1mOlw6MNTuOIw+visdIzMtBvNC02iNssRrzcI4Pykem6OkUSLQO
         8dZDxbf/8Odz5tLUZ3NYK/JUdl6KXd/GgMU0dWg6LArA9qfIPcv52hzGqDB17ZGQBLNG
         p3CncrdyYvjxN5VsQ+QQg7dFNXEUJmxUHfen0=
MIME-Version: 1.0
Date: Sun, 16 Aug 2009 10:59:38 +0100
Message-ID: <6278d2220908160259v38c34c4ck6db2853ae886492@mail.gmail.com>
Subject: [2.6.31-rc6] ACPI region conflict regression...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting 2.6.31-rc6 on some x86-64 hardware with fan control and
monitoring via the Winbond 83627 chip, 2.6.31-rc6 prevents the module
using an I/O region [1] described in the ACPI DSDT table [2] - which
didn't occur in -rc5.

Is there a way to relax this, or does it require adding
acpi_bus_register_driver(struct acpi_driver) and the needed code this
late in the game?

Thanks,
  Daniel

--- [1]

w83627ehf: Found W83627EHG chip at 0x290
ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region
SEN1 [0x295-0x296]
ACPI: Device needs an ACPI driver

--- [2]

    OperationRegion (SEN1, SystemIO, 0x0295, 0x02)
    Field (SEN1, ByteAcc, NoLock, Preserve)
    {
        SEI0,   8,
        SED0,   8
    }
-- 
Daniel J Blueman
