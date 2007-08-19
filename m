Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbXHSIpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbXHSIpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 04:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXHSIph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 04:45:37 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:28670 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXHSIpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 04:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Hu5SmbWHL+LqSknTZGRG47FwLk7zekr07azM4tBv/dUYW/2Gvg1aFPQ2BaVyvnnCDL+Oc7HKfrJXx9vIn2qLjevg/CB2xCVTt2Arnykdo4LkjsAU7vKbfbFeS6wAjtdhQ+4z+ODha64MNchNRo0VwUIMIaTzbJn4ZsBgU0bjjaI=
Message-ID: <34d269d40708190145m7a17ed35g190f0a5fabc4776e@mail.gmail.com>
Date: Sun, 19 Aug 2007 02:45:33 -0600
From: "Alex Hunsaker" <badalex@gmail.com>
To: astarikovskiy@suse.de, len.brown@intel.com
Subject: [ACPI] Regression 2.6.23-rc3 fails to boot (acpi)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hangs on boot with:
ACPI: EC: GPE = 0x4, I/O: command/status = 0x66, data = 0x62
ACPI: Interpreter enabled
ACPI: (supports S0 S3)
ACPI: Using PIC for interrupt routing
ACIP: EC: GPE = 0x4, I/O: command/status = 0x66, data = 0x62

2.6.23-rc2 is ok
2.6.23-rc3 bad
2.6.23-rc3-latest (7c010de7506954e973abfab5c5999c5a97f7a73e) bad

git-bisect narrowed it down to:

7c010de7506954e973abfab5c5999c5a97f7a73e
ACPI: EC: Switch from boot_ec as soon as we find its desc in DSDT.
Alexey Starikovskiy [Fri, 3 Aug 2007 21:57:53 +0000 (17:57 -0400)]
Some ASUS laptops fail to use boot time EC
and need to eventually switch to one described in DSDT.

http://bugzilla.kernel.org/show_bug.cgi?id=8709

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>

Reverting the above commit fixes the problem.
