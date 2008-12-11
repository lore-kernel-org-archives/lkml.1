Return-Path: <linux-kernel-owner+w=401wt.eu-S1761333AbYLKTmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761333AbYLKTmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYLKTTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:21 -0500
Received: from kroah.org ([198.145.64.141]:56630 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757573AbYLKTTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:19 -0500
Date: Thu, 11 Dec 2008 11:16:20 -0800
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
       alan@lxorguk.ukuu.org.uk, Matt Fleming <mjf@gentoo.org>, mingo@elte.hu,
       venkatesh.pallipadi@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 68/83] x86: HPET: convert WARN_ON to WARN_ON_ONCE
Message-ID: <20081211191620.GP5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-hpet-convert-warn_on-to-warn_on_once.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matt Fleming <mjf@gentoo.org>

commit 1de5b0854623d30d01d72cd4ea323eb5f39d1f16 upstream.

It is possible to flood the console with call traces if the WARN_ON
condition is true because of the frequency with which this function is
called.

Signed-off-by: Matt Fleming <mjf@gentoo.org>
Cc: mingo@elte.hu
Cc: venkatesh.pallipadi@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -283,7 +283,7 @@ static int hpet_legacy_next_event(unsign
 	 * what we wrote hit the chip before we compare it to the
 	 * counter.
 	 */
-	WARN_ON((u32)hpet_readl(HPET_T0_CMP) != cnt);
+	WARN_ON_ONCE((u32)hpet_readl(HPET_T0_CMP) != cnt);
 
 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }

