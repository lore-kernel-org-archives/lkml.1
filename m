Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbYHRS5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbYHRS5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761301AbYHRS4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:56:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:36166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758966AbYHRS4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:56:10 -0400
Date: Mon, 18 Aug 2008 11:44:07 -0700
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
       alan@lxorguk.ukuu.org.uk, Mikael Pettersson <mikpe@it.uu.se>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 28/60] sparc64: FUTEX_OP_ANDN fix
Message-ID: <20080818184407.GC29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc64-futex_op_andn-fix.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikael Pettersson <mikpe@it.uu.se>

[ Upstream commit d72609e17fd93bb2f7e0f7e1bdc70b6d20e43843 ]

Correct sparc64's implementation of FUTEX_OP_ANDN to do a
bitwise negate of the oparg parameter before applying the
AND operation. All other archs that support FUTEX_OP_ANDN
either negate oparg explicitly (frv, ia64, mips, sh, x86),
or do so indirectly by using an and-not instruction (powerpc).
Since sparc64 has and-not, I chose to use that solution.

I've not found any use of FUTEX_OP_ANDN in glibc so the
impact of this bug is probably minor. But other user-space
components may try to use it so it should still get fixed.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-sparc64/futex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-sparc64/futex.h
+++ b/include/asm-sparc64/futex.h
@@ -59,7 +59,7 @@ static inline int futex_atomic_op_inuser
 		__futex_cas_op("or\t%2, %4, %1", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_ANDN:
-		__futex_cas_op("and\t%2, %4, %1", ret, oldval, uaddr, oparg);
+		__futex_cas_op("andn\t%2, %4, %1", ret, oldval, uaddr, oparg);
 		break;
 	case FUTEX_OP_XOR:
 		__futex_cas_op("xor\t%2, %4, %1", ret, oldval, uaddr, oparg);

-- 
