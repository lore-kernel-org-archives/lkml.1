Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZG1PLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZG1PLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZG1PLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:11:06 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:57659 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbZG1PGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:40 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i203h64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KNHZAO-01-0O3-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [RFC PATCH 0/20 v2] marry mcheck to EDAC
Date: Tue, 28 Jul 2009 17:06:00 +0200
Message-ID: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 28 Jul 2009 15:06:22.0191 (UTC) FILETIME=[F7E30FF0:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the second version of the mcheck/EDAC marriage patches. Changes
from the first version include:

* MCE decoding has moved into the EDAC core and is being unconditionally
enabled on AMD hardware when EDAC is compiled in.

* The amd64_edac module registers a bus error handler with the EDAC MCE
code which does the additional decoding of bank 4 errors (CECC/UECCs)
and mapping to DIMMs.

I've also added the topology patches by Andreas for reference here.
amd64_edac needs the node id (cpuinfo_x86.cpu_node_id) an MCE has
happened on (and thus the respective memory controller) in order to get
that node's DRAM configuration before further decoding any error info.

As always, give them a good critical look and let me know of any issues.

 arch/x86/kernel/cpu/mcheck/mce.c    |   12 +-
 drivers/edac/Makefile               |    6 +-
 drivers/edac/amd64_edac.c           |  324 +++++++++-------------------
 drivers/edac/amd64_edac.h           |   71 +------
 drivers/edac/amd64_edac_dbg.c       |    2 +-
 drivers/edac/amd64_edac_err_types.c |  161 --------------
 drivers/edac/edac_mce_amd.c         |  412 +++++++++++++++++++++++++++++++++++
 drivers/edac/edac_mce_amd.h         |   68 ++++++
 8 files changed, 604 insertions(+), 452 deletions(-)

-- 
Thanks,
  Boris.

