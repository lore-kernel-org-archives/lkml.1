Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZJAXng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZJAXng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 19:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbZJAXiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 19:38:06 -0400
Received: from kroah.org ([198.145.64.141]:42015 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbZJAXiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 19:38:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 16:33:19 2009
Message-Id: <20091001233319.687218132@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 16:31:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [patch 06/30] [CIFS] Re-enable Lanman security
References: <20091001233116.947658905@mini.kroah.org>
Content-Disposition: inline; filename=re-enable-lanman-security.patch
In-Reply-To: <20091001233504.GA17709@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chuck Ebbert <cebbert@redhat.com>

commit 20d1752f3d6bd32beb90949559e0d14a0b234445 upstream.

commit ac68392460ffefed13020967bae04edc4d3add06 ("[CIFS] Allow raw
ntlmssp code to be enabled with sec=ntlmssp") added a new bit to the
allowed security flags mask but seems to have inadvertently removed
Lanman security from the allowed flags. Add it back.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsglob.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -544,9 +544,9 @@ require use of the stronger protocol */
 #define   CIFSSEC_MUST_LANMAN	0x10010
 #define   CIFSSEC_MUST_PLNTXT	0x20020
 #ifdef CONFIG_CIFS_UPCALL
-#define   CIFSSEC_MASK          0xAF0AF /* allows weak security but also krb5 */
+#define   CIFSSEC_MASK          0xBF0BF /* allows weak security but also krb5 */
 #else
-#define   CIFSSEC_MASK          0xA70A7 /* current flags supported if weak */
+#define   CIFSSEC_MASK          0xB70B7 /* current flags supported if weak */
 #endif /* UPCALL */
 #else /* do not allow weak pw hash */
 #ifdef CONFIG_CIFS_UPCALL


