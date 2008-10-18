Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbYJRTYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbYJRTYk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYJRTGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:06:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbYJRTGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:06:45 -0400
Date: Sat, 18 Oct 2008 11:57:45 -0700
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
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?B?Uy7DP2HEP2xhcg==?= Onur <caglar@pardus.org.tr>
Subject: [patch 14/14] x86: work around MTRR mask setting, v2
Message-ID: <20081018185745.GO17196@suse.de>
References: <20081018185031.236868964@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename="x86-work-around-mtrr-mask-setting-v2.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081018185658.GA17196@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ingo Molnar <mingo@elte.hu>

commit 9754a5b840a209bc1f192d59f63e81b698a55ac8 upstream

improve the debug printout:

- make it actually display something
- print it only once

would be nice to have a WARN_ONCE() facility, to feed such things to
kerneloops.org.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: S.Çağlar Onur <caglar@pardus.org.tr>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -251,7 +251,12 @@ static void generic_get_mtrr(unsigned in
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
