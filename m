Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbXLBTum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbXLBTum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756675AbXLBTuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:50:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:51428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638AbXLBTuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:50:06 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PATCH] ACPI patches for 2.6.24-rc3 -- part 2
Date: Sun, 2 Dec 2007 14:49:50 -0500
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712021449.51082.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Before rc4, please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

This fixes the Thinkpad T61 OOPS regression due to the -rc3 thermal changes.
It also fixes a boot crash in the AML interpreter that has been with us forever,
but has recently been exposed by acpi-cpufreq on some new platforms.

This will update the files shown below.

thanks!

-Len

ps. individual patches are available on linux-acpi@vger.kernel.org
and a consolidated plain patch is available here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/patches/release/2.6.24/acpi-release-20070126-2.6.24-rc3.diff.gz

 drivers/acpi/dispatcher/dsobject.c  |   91 ++++++++++++++++++++++--
 drivers/acpi/processor_throttling.c |   36 +++++++--
 2 files changed, 113 insertions(+), 14 deletions(-)

through these commits:

Bob Moore (1):
      ACPICA: fix acpi-cpufreq boot crash due to _PSD return-by-reference

Zhao Yakui (1):
      ACPI: Delete the IRQ operation in throttling controll via PTC

with this log:

commit 6ac47735cdba6ac8c64cb7595762a75fdcafaa6d
Merge: 7ac3ae3... 152c300...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Dec 2 14:33:33 2007 -0500

    Pull bugzilla-9429 into release branch

commit 7ac3ae32d170cea8cb8e7822acc29ed8f1b1018d
Merge: 92d499d... 357dc4c...
Author: Len Brown <len.brown@intel.com>
Date:   Sun Dec 2 14:33:21 2007 -0500

    Pull thermal into release branch

commit 152c300d007c70c4a1847dad39ecdaba22e7d457
Author: Bob Moore <robert.moore@intel.com>
Date:   Wed Oct 17 16:10:18 2007 -0400

    ACPICA: fix acpi-cpufreq boot crash due to _PSD return-by-reference
    
    Changed resolution of named references in packages
    
    Fixed a problem with the Package operator where all named
    references were created as object references and left otherwise
    unresolved. According to the ACPI specification, a Package can
    only contain Data Objects or references to control methods. The
    implication is that named references to Data Objects (Integer,
    Buffer, String, Package, BufferField, Field) should be resolved
    immediately upon package creation. This is the approach taken
    with this change. References to all other named objects (Methods,
    Devices, Scopes, etc.) are all now properly created as reference objects.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=5328
    http://bugzilla.kernel.org/show_bug.cgi?id=9429
    
    Signed-off-by: Bob Moore <robert.moore@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

commit 357dc4c3f13cb5c1e3b40a09cbe6ff1b0df2c7c3
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Thu Nov 29 16:22:43 2007 +0800

    ACPI: Delete the IRQ operation in throttling controll via PTC
    
    The IRQ operation(enable/disable) should be avoided when throttling is
    controlled via PTC method. It is replaced by the migration of task.
    
    This fixes an oops on T61 -- a regression due to
    f79f06ab9f86 b/c FixedHW support tried to read remote MSR with interrupts disabled.
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
