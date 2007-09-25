Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbXIYWFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbXIYWFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbXIYWFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:05:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:47058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbXIYWFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:05:07 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Torvalds, Linus" <torvalds@linux-foundation.org>
Subject: [GIT PATCH] ACPI patches for 2.6.23-rc8
Date: Tue, 25 Sep 2007 18:04:23 -0400
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709251804.23357.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.23/acpi-release-20070126-2.6.23-rc8.diff.gz

 drivers/acpi/sleep/Makefile |    2 -
 drivers/acpi/sleep/main.c   |   46 +++++++++++++++++---------------
 drivers/char/hpet.c         |    6 ++--
 include/acpi/acpi_drivers.h |    4 --
 4 files changed, 29 insertions(+), 29 deletions(-)

through these commits:

Alexey Starikovskiy (2):
      ACPI: suspend: build-fix for CONFIG_SUSPEND=n and CONFIG_HIBERNATION=y
      ACPI: CONFIG_ACPI_SLEEP=n power off regression in 2.6.23-rc8 (NOT in rc7)

Zhao Yakui (1):
      ACPI: hpet: ACPI Error (utglobal-0126): Unknown exception code: 0xFFFFFFF0

with this log:

commit 78e1ca49c7ead5cd00882ed0c776260857613122
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Sep 20 21:23:13 2007 -0400

    ACPI: hpet: ACPI Error (utglobal-0126): Unknown exception code: 0xFFFFFFF0
    
    If hpet has been initialized before registering hpet driver, the callback
    function of hpet_resources will return the status code of -EBUSY, which is
    not defined in the ACPI exception table.  So when ACPI checks the status
    code of callback function, it will report the unknown exception code.
    
    So the status code in ACPI is used instead of the generic error code in the
    ACPI callback function of hpet_resources.
    For example: -EBUSY is replaced by AE_ALREADY_EXISTS
    	     -EINVAL is replaced by AE_NO_MEMORY
    
    http://bugzilla.kernel.org/show_bug.cgi?id=8630
    
    Signed-off-by: Zhao Yakui  <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 853298bc03ef65e3eb392f5d61265605214ee8fb
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Tue Sep 25 18:45:15 2007 +0400

    ACPI: CONFIG_ACPI_SLEEP=n power off regression in 2.6.23-rc8 (NOT in rc7)
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 2f3f22269bdf702311342c5d106dfdd7347d1c3e
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Mon Sep 24 14:33:21 2007 +0200

    ACPI: suspend: build-fix for CONFIG_SUSPEND=n and CONFIG_HIBERNATION=y
    
    This fixes compilation with CONFIG_SUSPEND unset and CONFIG_HIBERNATION set
    (raf. http://marc.info/?l=linux-acpi&m=119055289723895&w=4).
    
    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>
