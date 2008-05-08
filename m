Return-Path: <linux-kernel-owner+w=401wt.eu-S1765529AbYEHRrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765529AbYEHRrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbYEHRnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:47773 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763468AbYEHRnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:37 -0400
Date: Thu, 8 May 2008 10:42:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Nicolas Pitre <nico@marvell.com>,
       Lennert Buytenhek <buytenh@marvell.com>
Subject: [patch 09/16] kprobes/arm: fix cache flush address for instruction
	stub
Message-ID: <20080508174216.GJ855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kprobes-arm-fix-cache-flush-address-for-instruction-stub.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Nicolas Pitre <nico@cam.org>

It is more useful to flush the cache with the actual buffer address
rather than the address containing a pointer to the buffer.

Mainline commit: 8f79ff0cb5330a92032c30ff586745d3016b34ca

Signed-off-by: Nicolas Pitre <nico@marvell.com>
Acked-by: Lennert Buytenhek <buytenh@marvell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -66,7 +66,7 @@ int __kprobes arch_prepare_kprobe(struct
 			return -ENOMEM;
 		for (is = 0; is < MAX_INSN_SIZE; ++is)
 			p->ainsn.insn[is] = tmp_insn[is];
-		flush_insns(&p->ainsn.insn, MAX_INSN_SIZE);
+		flush_insns(p->ainsn.insn, MAX_INSN_SIZE);
 		break;
 
 	case INSN_GOOD_NO_SLOT:	/* instruction doesn't need insn slot */

-- 
