Return-Path: <linux-kernel-owner+w=401wt.eu-S932631AbYHRTDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631AbYHRTDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758474AbYHRTB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:01:27 -0400
Received: from ns1.suse.de ([195.135.220.2]:43773 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762199AbYHRTBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:01:24 -0400
Date: Mon, 18 Aug 2008 11:44:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Yinghal Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, maximilian attems <max@stro.at>,
       Peter Palfrader <weasel@debian.org>, dann frazier <dannf@debian.org>
Subject: [patch 41/60] x86: amd opteron TOM2 mask val fix
Message-ID: <20080818184455.GP29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-amd-opteron-tom2-mask-val-fix.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Yinghai Lu <yhlu.kernel@gmail.com>

commit 8004dd965b13b01a96def054d420f6df7ff22d53 upstream.

there is a typo in the mask value, need to remove that extra 0,
to avoid 4bit clearing.

Signed-off-by: Yinghal Lu <yhlu.kernel@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: maximilian attems <max@stro.at>
Cc: Peter Palfrader <weasel@debian.org>
Cc: dann frazier <dannf@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
 arch/x86/pci/k8-bus_64.c           |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -219,7 +219,7 @@ void __init get_mtrr_state(void)
 		tom2 = hi;
 		tom2 <<= 32;
 		tom2 |= lo;
-		tom2 &= 0xffffff8000000ULL;
+		tom2 &= 0xffffff800000ULL;
 	}
 	if (mtrr_show) {
 		int high_width;
--- a/arch/x86/pci/k8-bus_64.c
+++ b/arch/x86/pci/k8-bus_64.c
@@ -384,7 +384,7 @@ static int __init early_fill_mp_bus_info
 	/* need to take out [0, TOM) for RAM*/
 	address = MSR_K8_TOP_MEM1;
 	rdmsrl(address, val);
-	end = (val & 0xffffff8000000ULL);
+	end = (val & 0xffffff800000ULL);
 	printk(KERN_INFO "TOM: %016lx aka %ldM\n", end, end>>20);
 	if (end < (1ULL<<32))
 		update_range(range, 0, end - 1);
@@ -478,7 +478,7 @@ static int __init early_fill_mp_bus_info
 		/* TOP_MEM2 */
 		address = MSR_K8_TOP_MEM2;
 		rdmsrl(address, val);
-		end = (val & 0xffffff8000000ULL);
+		end = (val & 0xffffff800000ULL);
 		printk(KERN_INFO "TOM2: %016lx aka %ldM\n", end, end>>20);
 		update_range(range, 1ULL<<32, end - 1);
 	}

-- 
