Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYJRTU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYJRTU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJRTGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:06:00 -0400
Received: from mx1.suse.de ([195.135.220.2]:38752 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbYJRTF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:58 -0400
Date: Sat, 18 Oct 2008 11:57:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 02/14] x86: improve UP kernel when CPU-hotplug and SMP is
	enabled
Message-ID: <20081018185716.GC17196@suse.de>
References: <20081018185031.236868964@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-improve-up-kernel-when-cpu-hotplug-and-smp-is-enabled.patch"
In-Reply-To: <20081018185658.GA17196@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

commit 649c6653fa94ec8f3ea32b19c97b790ec4e8e4ac upstream

num_possible_cpus() can be > 1 when disabled CPUs have been accounted.

Disabled CPUs are not in the cpu_present_map, so we can use
num_present_cpus() as a safe indicator to switch to UP alternatives.

Reported-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -457,7 +457,7 @@ void __init alternative_instructions(voi
 					    _text, _etext);
 
 		/* Only switch to UP mode if we don't immediately boot others */
-		if (num_possible_cpus() == 1 || setup_max_cpus <= 1)
+		if (num_present_cpus() == 1 || setup_max_cpus <= 1)
 			alternatives_smp_switch(0);
 	}
 #endif

-- 
