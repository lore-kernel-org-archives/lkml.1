Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbYA2CVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbYA2CVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 21:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYA2CVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 21:21:11 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:53077 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760843AbYA2CVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 21:21:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=7FI6iYLfQLEA:10 a=eJaesg7dyJUKDnsq4nEA:9 a=ucAoU3do4fvT9_pHhvWPc1A2i-4A:4 a=bt0zGP92IBIA:10 a=9XSpoOj3B7kA:10
From: Paul Moore <paul.moore@hp.com>
Subject: [PATCH] SELinux: Fix double free in selinux_netlbl_sock_setsid()
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, selinux@tycho.nsa.gov, stable@kernel.org,
       bunk@kernel.org, jmorris@namei.org
Date: Mon, 28 Jan 2008 21:20:26 -0500
Message-ID: <20080129022026.7930.18782.stgit@flek.lan>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-MooreFamily-MailScanner-Information: Please contact pcmoore@engin.umich.edu
X-MailScanner: Found to be clean
X-MailScanner-From: paul.moore@hp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Adrian Bunk, commit 45c950e0f839fded922ebc0bfd59b1081cc71b70
caused a double-free when security_netlbl_sid_to_secattr() fails.  This patch
fixes this by removing the netlbl_secattr_destroy() call from that function
since we are already releasing the secattr memory in
selinux_netlbl_sock_setsid().

Signed-off-by: Paul Moore <paul.moore@hp.com>
---

 security/selinux/ss/services.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 4bf715d..3a16aba 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -2629,7 +2629,6 @@ int security_netlbl_sid_to_secattr(u32 sid, struct netlbl_lsm_secattr *secattr)
 
 netlbl_sid_to_secattr_failure:
 	POLICY_RDUNLOCK;
-	netlbl_secattr_destroy(secattr);
 	return rc;
 }
 #endif /* CONFIG_NETLABEL */

