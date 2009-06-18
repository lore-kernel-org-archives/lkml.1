Return-Path: <linux-kernel-owner+w=401wt.eu-S1760323AbZFRGoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323AbZFRGoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752942AbZFRGoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:44:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36586 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZFRGoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:44:24 -0400
Message-ID: <4A39E247.4030908@jp.fujitsu.com>
Date: Thu, 18 Jun 2009 15:44:23 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: [PATCH 0/7] Patches for kdump vs. INIT
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony-san, and kdump folks,

I got some trouble on kdump on IPF with INIT, and my investigation
proves there are some bugs and races in startup of kdump.
Here are fixes based on .30, for issues I found.

Since it must be serious problem for (likely big) IPF servers if we
could fail to retrieve crashdump via kdump, so I believe these patches
should be applied asap.


Thanks,
H.Seto

===

Hidetoshi Seto (7):
      ia64, kdump: Mask MCA/INIT on freezing cpus
      ia64, kexec: Make INIT safe while kdump/kexec
      ia64, kexec: Unregister MCA handler before kexec
      ia64, kdump: Don't offline APs
      ia64, kdump: Mask INIT first in panic-kdump path
      ia64, kdump: Try INIT regardless of kdump_on_init
      ia64, kdump: Short path to freeze CPUs

 arch/ia64/kernel/crash.c         |   85 ++++++++++++++++++++++++++------------
 arch/ia64/kernel/machine_kexec.c |   17 ++++++++
 arch/ia64/kernel/mca.c           |   15 ++++++-
 arch/ia64/kernel/mca_asm.S       |   47 +++++++++++++++++++++
 4 files changed, 136 insertions(+), 28 deletions(-)


