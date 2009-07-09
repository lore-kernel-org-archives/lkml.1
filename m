Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZGIHEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZGIHEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760432AbZGIHCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:02:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53782 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760443AbZGIHCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:02:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A5595F3.2050609@jp.fujitsu.com>
Date: Thu, 09 Jul 2009 16:02:11 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org, "Luck, Tony" <tony.luck@intel.com>,
       "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: [PATCH v2 0/7] Patches for kdump vs. INIT
References: <4A39E247.4030908@jp.fujitsu.com>
In-Reply-To: <4A39E247.4030908@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is the updated version:
 - Better descriptions with justifiable reasons
 - Add comments to point where the mask is removed
 - Move extern to header file
 - Minor fix for style, typo
 - No changes in logic

Thanks,
H.Seto

===

Hidetoshi Seto (7):
      ia64, kdump: Mask MCA/INIT on frozen cpus
      ia64, kexec: Make INIT safe while transition to kdump/kexec kernel
      ia64, kexec: Unregister MCA handler before kexec
      ia64, kdump: Don't return APs to SAL from kdump
      ia64, kdump: Mask INIT first in panic-kdump path
      ia64, kdump: Try INIT regardless of kdump_on_init
      ia64, kdump: Short path to freeze CPUs

 arch/ia64/include/asm/mca.h        |    2 +
 arch/ia64/kernel/crash.c           |   83 ++++++++++++++++++++++++-----------
 arch/ia64/kernel/head.S            |    2 +-
 arch/ia64/kernel/machine_kexec.c   |   15 ++++++
 arch/ia64/kernel/mca.c             |   15 ++++++-
 arch/ia64/kernel/mca_asm.S         |   47 ++++++++++++++++++++
 arch/ia64/kernel/relocate_kernel.S |    2 +-
 7 files changed, 136 insertions(+), 30 deletions(-)

Hidetoshi Seto wrote:
> Hi Tony-san, and kdump folks,
> 
> I got some trouble on kdump on IPF with INIT, and my investigation
> proves there are some bugs and races in startup of kdump.
> Here are fixes based on .30, for issues I found.
> 
> Since it must be serious problem for (likely big) IPF servers if we
> could fail to retrieve crashdump via kdump, so I believe these patches
> should be applied asap.
> 
> 
> Thanks,
> H.Seto
> 
> ===
> 
> Hidetoshi Seto (7):
>       ia64, kdump: Mask MCA/INIT on freezing cpus
>       ia64, kexec: Make INIT safe while kdump/kexec
>       ia64, kexec: Unregister MCA handler before kexec
>       ia64, kdump: Don't offline APs
>       ia64, kdump: Mask INIT first in panic-kdump path
>       ia64, kdump: Try INIT regardless of kdump_on_init
>       ia64, kdump: Short path to freeze CPUs
> 
>  arch/ia64/kernel/crash.c         |   85 ++++++++++++++++++++++++++------------
>  arch/ia64/kernel/machine_kexec.c |   17 ++++++++
>  arch/ia64/kernel/mca.c           |   15 ++++++-
>  arch/ia64/kernel/mca_asm.S       |   47 +++++++++++++++++++++
>  4 files changed, 136 insertions(+), 28 deletions(-)


