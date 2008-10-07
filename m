Return-Path: <linux-kernel-owner+w=401wt.eu-S1757523AbYJGAoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbYJGAoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756557AbYJGAlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:41:37 -0400
Received: from ns1.suse.de ([195.135.220.2]:46537 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbYJGAlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:41:36 -0400
Date: Mon, 6 Oct 2008 17:37:49 -0700
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
       alan@lxorguk.ukuu.org.uk, "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [patch 10/71] smb.h: do not include linux/time.h in userspace
Message-ID: <20081007003749.GK3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="smb.h-do-not-include-linux-time.h-in-userspace.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Kirill A. Shutemov <kirill@shutemov.name>

commit c32a162fd420fe8dfb049db941b2438061047fcc upstream

linux/time.h conflicts with time.h from glibc

It breaks building smbmount from samba.  It's regression introduced by
commit 76308da (" smb.h: uses struct timespec but didn't include
linux/time.h").

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/smb.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/smb.h
+++ b/include/linux/smb.h
@@ -11,7 +11,9 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#ifdef __KERNEL__
 #include <linux/time.h>
+#endif
 
 enum smb_protocol { 
 	SMB_PROTOCOL_NONE, 

-- 
