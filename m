Return-Path: <linux-kernel-owner+w=401wt.eu-S1763787AbXKTSeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763787AbXKTSeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761735AbXKTS1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:27:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:51959 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760578AbXKTS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:27:08 -0500
Date: Tue, 20 Nov 2007 10:24:35 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrew Hastings <abh@cray.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 19/29] x86: fix off-by-one in find_next_zero_string
Message-ID: <20071120182435.GU28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-one-off-in-find-next-zero-string.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andrew Hastings <abh@cray.com>

patch 801916c1b369b637ce799e6c71a94963ff63df79 in mainline.

x86: fix off-by-one in find_next_zero_string

Fix an off-by-one error in find_next_zero_string which prevents
allocating the last bit.

[ tglx: arch/x86 adaptation ]

Signed-off-by: Andrew Hastings <abh@cray.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86_64/lib/bitstr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86_64/lib/bitstr.c
+++ b/arch/x86_64/lib/bitstr.c
@@ -14,7 +14,7 @@ find_next_zero_string(unsigned long *bit
 	
 	/* could test bitsliced, but it's hardly worth it */
 	end = n+len;
-	if (end >= nbits) 
+	if (end > nbits)
 		return -1; 
 	for (i = n+1; i < end; i++) { 
 		if (test_bit(i, bitmap)) {  

-- 
