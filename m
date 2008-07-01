Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbYGAPY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbYGAPY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbYGAPWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:22:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760626AbYGAPWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:22:35 -0400
Date: Tue, 1 Jul 2008 08:19:21 -0700
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
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Max Asbock <masbock@linux.vnet.ibm.com>,
       Glauber Costa <gcosta@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 9/9] x86: shift bits the right way in native_read_tscp
Message-ID: <20080701151921.GJ3536@suse.de>
References: <20080701151057.930340322@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-shift-bits-the-right-way-in-native_read_tscp.patch"
In-Reply-To: <20080701151835.GA3536@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Max Asbock <masbock@us.ibm.com>

Commit 41aefdcc98fdba47459eab67630293d67e855fc3 upstream

x86: shift bits the right way in native_read_tscp

native_read_tscp shifts the bits in the high order value in the
wrong direction, the attached patch fixes that.

Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>
Acked-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-x86/msr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -18,7 +18,7 @@ static inline unsigned long long native_
 	unsigned long low, high;
 	asm volatile (".byte 0x0f,0x01,0xf9"
 		      : "=a" (low), "=d" (high), "=c" (*aux));
-	return low | ((u64)high >> 32);
+	return low | ((u64)high << 32);
 }
 
 /*

-- 
