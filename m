Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbZEOMXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbZEOMXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZEOMWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:22:48 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:1269 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZEOMWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:22:48 -0400
X-BigFish: VPS-15(zz154dM14ffO4015Lzz1202hzzz32i63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KJOQDO-01-0BP-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 00/21 v4] amd64_edac: EDAC module for AMD64
Date: Fri, 15 May 2009 14:22:11 +0200
Message-ID: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
X-OriginalArrivalTime: 15 May 2009 12:22:38.0540 (UTC) FILETIME=[D5F760C0:01C9D557]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here's the newest reworked patchset of the EDAC module for AMD k8,
Fam10h and Fam11h processors with a _LOT_ of changes all over the
place, among which are removal of NUMA dependency, several bugfixes,
reworking error paths/labels in code flow, sysfs attributes renaming, a
substantial comments fix/cleanup and many more. The diffstat speaks for
itself and additional changes are described in each commit message.

Bunch of thanks to Ingo for his diligent review.

The git repo with the patchset based on Linus' branch from yesterday is
at:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Changelog:

- v3:
Split the driver into several .c files based on functionality, removal
of StinkyIdentifiers and bunch of cleanups all over the place.

- v2:
Highlights are the addition of two helpers to read/write MSRs on several
CPUs, denoted by a cpumask and using an array of MSR values per-CPU, as
hpa suggested. Since IMHO they look generic enough I've added them to
arch/x86/lib/msr-on-cpu.c (now renamed to msr.c).

Thanks,
Boris.

 arch/x86/include/asm/msr.h          |   21 +
 arch/x86/lib/Makefile               |    2 +-
 arch/x86/lib/msr-on-cpu.c           |   97 -
 arch/x86/lib/msr.c                  |  152 ++
 drivers/edac/Kconfig                |   26 +
 drivers/edac/Makefile               |    7 +
 drivers/edac/amd64_edac.c           | 3361 +++++++++++++++++++++++++++++++++++
 drivers/edac/amd64_edac.h           |  657 +++++++
 drivers/edac/amd64_edac_dbg.c       |  255 +++
 drivers/edac/amd64_edac_err_types.c |  161 ++
 drivers/edac/amd64_edac_inj.c       |  185 ++
 drivers/edac/edac_core.h            |    9 +-
 12 files changed, 4831 insertions(+), 102 deletions(-)

