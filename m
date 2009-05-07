Return-Path: <linux-kernel-owner+w=401wt.eu-S1762293AbZEGN6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762293AbZEGN6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbZEGNus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:50:48 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:52131
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757916AbZEGNu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:50:29 -0400
X-BigFish: VPS-12(zz154dM111aL4015Lzz1202hzzz32i63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KJA12V-01-QXI-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 00/21 v3] amd64_edac: EDAC module for AMD64
Date: Thu, 7 May 2009 15:49:22 +0200
Message-ID: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
X-OriginalArrivalTime: 07 May 2009 13:49:47.0734 (UTC) FILETIME=[AF810F60:01C9CF1A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here's v3 of the EDAC module for AMD k8, Fam10h and Fam11h processors.
Among the changes from the previous version are a split of the
driver into several .c files based on functionality, removal of
StinkyIdentifiers and bunch of cleanups all over the place.

Thanks again to all the reviewers for their constructive comments, as
always give it a good stare and flame away :).

There's also a git repo with the patchset based on Linus' branch from
yesterday:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/amd64_edac.git

Changelog:

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
 drivers/edac/Makefile               |   13 +
 drivers/edac/amd64_edac.c           | 3759 +++++++++++++++++++++++++++++++++++
 drivers/edac/amd64_edac.h           |  951 +++++++++
 drivers/edac/amd64_edac_dbg.c       |  291 +++
 drivers/edac/amd64_edac_err_types.c |  163 ++
 drivers/edac/amd64_edac_inj.c       |  203 ++
 11 files changed, 5580 insertions(+), 98 deletions(-)

