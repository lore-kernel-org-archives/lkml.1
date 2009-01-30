Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZA3WpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZA3WpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbZA3Wou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:44:50 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:10005 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZA3Wot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:44:49 -0500
From: Myron Stowe <myron.stowe@hp.com>
Subject: [PATCH 0/2] ACPICA: Fix truncation message calculation
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       myron.stowe@hp.com
Date: Fri, 30 Jan 2009 15:44:48 -0700
Message-ID: <20090130223832.24329.5434.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len:

The following two item patch series fixes a calculation in
./drivers/acpi/tables/tbutils.c::acpi_tb_parse_root_table() that
determines how many ACPI table entries will be truncated when the
number of RSDT/XSDT entries is greater than the statically allocated
'initial_tables[]' array.

As currently implemented, the calculation will always yield a value
of 0.  The following output shows the issue (Note the line with
"...: Truncating ..." which incorrectly indicates 0):
  ACPI: RSDP 32A82014, 0024 (r2 HP    )
  ACPI: XSDT 32A82580, 0494 (r1 HP     XXXXXX          0       1000013)
  ACPI Error (tbinstal-0207): Resize of Root Table Array is not allowed [20070126]
  ACPI Warning (tbutils-0519): Truncating 0 table entries! [20070126]
  ACPI: FACP 32A6C000, 00F4 (r3 HP     XXXXXX          0   HP        0)
  ACPI: DSDT 32A52000, 8E83 (r2 HP     XXXXXX          8 INTL 20061109)
  ...

With the patch applied, the output correctly shows the number of
(missing) truncated entries:
  ACPI: RSDP 32A82014, 0024 (r2 HP    )
  ACPI: XSDT 32A82580, 0494 (r1 HP     XXXXXX          0       1000013)
  ACPI Error (tbinstal-0207): Resize of Root Table Array is not allowed [20070126]
  ACPI Warning (tbutils-0519): Truncating 5 table entries! [20070126]
  ACPI: FACP 32A6C000, 00F4 (r3 HP     XXXXXX          0   HP        0)
  ACPI: DSDT 32A52000, 8E83 (r2 HP     XXXXXX          8 INTL 20061109)
  ...


[PATCH 1/2] fixes the truncation message related calculation.

[PATCH 2/2] is non-functional white space fixes - 80 column adherence -
for the same file. 


The underlying code affected is common to both x86 and ia64.  I have
tested the patch on an ia64 platform.

All comments welcome.

Myron
---

Myron Stowe (2):
      ACPICA: 80 column adherence (no functional change)
      ACPICA: Fix table entry truncation calculation


 drivers/acpi/acpica/tbutils.c |   43 +++++++++++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 15 deletions(-)

