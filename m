Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYLKTU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYLKTU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbYLKTSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:12 -0500
Received: from kroah.org ([198.145.64.141]:55859 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756550AbYLKTSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:04 -0500
Date: Thu, 11 Dec 2008 11:13:46 -0800
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
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh@veritas.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/83] sparc64: Fix __copy_{to,from}_user_inatomic defines.
Message-ID: <20081211191346.GH5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0002-sparc64-Fix-__copy_-to-from-_user_inatomic-defines.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh@veritas.com>

[ Upstream commit b270ee8a9fc9547eb781ce9ccd379450bcf9a204 ]

Alexander Beregalov reports oops in __bzero() called from
copy_from_user_fixup() called from iov_iter_copy_from_user_atomic(),
when running dbench on tmpfs on sparc64: its __copy_from_user_inatomic
and __copy_to_user_inatomic should be avoiding, not calling, the fixups.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/include/asm/uaccess_64.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -265,8 +265,8 @@ extern long __strnlen_user(const char __
 
 #define strlen_user __strlen_user
 #define strnlen_user __strnlen_user
-#define __copy_to_user_inatomic __copy_to_user
-#define __copy_from_user_inatomic __copy_from_user
+#define __copy_to_user_inatomic ___copy_to_user
+#define __copy_from_user_inatomic ___copy_from_user
 
 #endif  /* __ASSEMBLY__ */
 

