Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZIOFxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZIOFxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 01:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbZIOFxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 01:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312AbZIOFxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 01:53:24 -0400
Message-Id: <200909150553.n8F5rMBQ009793@int-mx05.intmail.prod.int.phx2.redhat.com>
Date: Tue, 15 Sep 2009 01:53:21 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Steve French <sfrench@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] [CIFS] Re-enable Lanman security
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CIFS] Re-enable Lanman security

commit ac68392460ffefed13020967bae04edc4d3add06 ("[CIFS] Allow raw 
ntlmssp code to be enabled with sec=ntlmssp") added a new bit to the
allowed security flags mask but seems to have inadvertently removed
Lanman security from the allowed flags. Add it back.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- linux-2.6.30.noarch.orig/fs/cifs/cifsglob.h
+++ linux-2.6.30.noarch/fs/cifs/cifsglob.h
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
