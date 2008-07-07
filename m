Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbYGGWfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbYGGWfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYGGWe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:34:56 -0400
Received: from outbound-mail-116.bluehost.com ([69.89.22.16]:60454 "HELO
	outbound-mail-116.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754021AbYGGWez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:34:55 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Date: Mon, 7 Jul 2008 15:34:39 -0700
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, Tony Camuso <tcamuso@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807071534.39984.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull my for-linus branch:
git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

Tony noticed that a PCI fix he sent me was applied by both a PCI pull and an
x86 pull.  Unfortunately, the patches in each tree weren't identical and the
double application ended up removing some bfsort quirks for Dell machines.
Specifically it looks like the one that came in through Ingo & Thomas,
a1676072558854b95336c8f7db76b0504e909a0a, modified the end of the list, while
the one that I sent upstream, 8d64c781f0c5fbfdf8016bd1634506ff2ad1376a,
modified the entry above #ifdef __i386__, and with both applied we lose the
quirks for DL385 & DL585.

I fixed things up in my for-linus branch by reverting
a1676072558854b95336c8f7db76b0504e909a0a, matching the shortlog & diff below.

Thanks,
Jesse

Jesse Barnes (1):
      Revert "PCI: Correct last two HP entries in the bfsort whitelist"

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 940185e..6e64aaf 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -328,18 +328,18 @@ static struct dmi_system_id __devinitdata pciprobe_dmi_tab
 #endif
        {
                .callback = set_bf_sort,
-               .ident = "HP ProLiant DL360",
+               .ident = "HP ProLiant DL385 G2",
                .matches = {
                        DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-                       DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL360"),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL385 G2"),
                },
        },
        {
                .callback = set_bf_sort,
-               .ident = "HP ProLiant DL380",
+               .ident = "HP ProLiant DL585 G2",
                .matches = {
                        DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-                       DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL380"),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "ProLiant DL585 G2"),
                },
        },
        {}
