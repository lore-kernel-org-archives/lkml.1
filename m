Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYICRr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYICRr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYICRrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:47:10 -0400
Received: from ns1.suse.de ([195.135.220.2]:53328 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968AbYICRrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:47:08 -0400
Date: Wed, 3 Sep 2008 10:26:50 -0700
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
       alan@lxorguk.ukuu.org.uk, mingo@elte.hu,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [patch 40/42] x86: work around MTRR mask setting, v2
Message-ID: <20080903172650.GO7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-work-around-mtrr-mask-setting-v2.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ingo Molnar <mingo@elte.hu>

commit 9754a5b840a209bc1f192d59f63e81b698a55ac8 upstream

x86: work around MTRR mask setting, v2

improve the debug printout:

- make it actually display something
- print it only once

would be nice to have a WARN_ONCE() facility, to feed such things to
kerneloops.org.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -387,7 +387,12 @@ static void generic_get_mtrr(unsigned in
 		tmp |= ~((1<<(hi - 1)) - 1);
 
 		if (tmp != mask_lo) {
-			WARN_ON("mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+			static int once = 1;
+
+			if (once) {
+				printk(KERN_INFO "mtrr: your BIOS has set up an incorrect mask, fixing it up.\n");
+				once = 0;
+			}
 			mask_lo = tmp;
 		}
 	}

-- 
