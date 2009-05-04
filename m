Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbZEDReT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbZEDReT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZEDReF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:34:05 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:34495
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752911AbZEDReE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:34:04 -0400
X-BigFish: VPS7(zzzz1202hzzz32i6bh15fn61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ4RG9-02-P26-01
Date: Mon, 4 May 2009 19:33:30 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] x86: adapt CPU topology detection for AMD Magny-Cours
Message-ID: <20090504173330.GF28728@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 May 2009 17:33:51.0874 (UTC) FILETIME=[7D98C620:01C9CCDE]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Following patches add support for AMD Magny-Cours CPU.

I slightly change struct cpuinfo where I'd like to introduce
cpu_node_id to reflect CPU topology for AMD Magny-Cours CPU which
consists of two internal-nodes.

For all cores on the same multi-node CPU (Magny-Cours) /proc/cpuinfo
will show:
- same phys_proc_id
- cpu_node_id of the internal node (0 or 1)
- cpu_core_id (e.g. in range of 0 to 5)

I also change identification of core siblings (and thread siblings)
which will also be based on cpu_node_id in addition to phys_proc_id.

Furthermore I adapt the L3 cache information to reflect the cache
characteristics of one internal node instead of the entire package.

Primarily this changes are needed to correct core sibling information
for Magny-Cours. This CPU has two NBs on one physical package -- each
internal node has its own processor configuration space (i.e. set of
northbridge PCI functions).

Patches are against tip/master as of today.
Please consider patches 1 and 2 for .30.
Patch 3 should be applied to tip/x86/cpu where all the recent
cacheinfo changes reside (e.g. commit
6265ff19ca08df0d96c859ae5e4dc2d9ad07070e).


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


