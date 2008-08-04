Return-Path: <linux-kernel-owner+w=401wt.eu-S1765579AbYHDVgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765579AbYHDVgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764930AbYHDVfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:35:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:54573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764788AbYHDVfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:35:32 -0400
Date: Mon, 4 Aug 2008 14:29:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
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
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>, Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 06/25] x86: io delay - add checking for NULL early param
Message-ID: <20080804212947.GF8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-io-delay-add-checking-for-null-early-param.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Cyrill Gorcunov <gorcunov@gmail.com>

[ Upstream commit d6cd7effcc5e0047faf15ab0a54c980f1a616a07 ]

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: akpm@linux-foundation.org
Cc: andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/io_delay.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -103,6 +103,9 @@ void __init io_delay_init(void)
 
 static int __init io_delay_param(char *s)
 {
+	if (!s)
+		return -EINVAL;
+
 	if (!strcmp(s, "0x80"))
 		io_delay_type = CONFIG_IO_DELAY_TYPE_0X80;
 	else if (!strcmp(s, "0xed"))

-- 
