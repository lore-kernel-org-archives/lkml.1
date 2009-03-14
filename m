Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZCNAng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZCNAng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZCNATo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:44 -0400
Received: from kroah.org ([198.145.64.141]:34916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753816AbZCNATc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:49 2009
Message-Id: <20090314000749.798501539@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:19 -0700
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
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 71/96] x86: tone down mtrr_trim_uncached_memory() warning
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=x86-tone-down-mtrr_trim_uncached_memory-warning.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ingo Molnar <mingo@elte.hu>

commit bf3647c44bc76c43c4b2ebb4c37a559e899ac70e upstream.

kerneloops.org is reporting a lot of these warnings that come due to
vmware not setting up any MTRRs for emulated CPUs:

| Reported 709 times (14696 total reports)
| BIOS bug (often in VMWare) where the MTRR's are set up incorrectly
| or not at all
|
| This warning was last seen in version 2.6.29-rc2-git1, and first
| seen in 2.6.24.
|
| More info:
|   http://www.kerneloops.org/searchweek.php?search=mtrr_trim_uncached_memory

Keep a one-liner KERN_INFO about it - so that we have so notice if empty
MTRRs are caused by native hardware/BIOS weirdness.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mtrr/main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1496,8 +1496,7 @@ int __init mtrr_trim_uncached_memory(uns
 
 	/* kvm/qemu doesn't have mtrr set right, don't trim them all */
 	if (!highest_pfn) {
-		WARN(!kvm_para_available(), KERN_WARNING
-				"WARNING: strange, CPU MTRRs all blank?\n");
+		printk(KERN_INFO "CPU MTRRs all blank - virtualized system.\n");
 		return 0;
 	}
 


