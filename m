Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYCXGNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYCXGNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 02:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYCXGNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 02:13:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64783 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbYCXGNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 02:13:10 -0400
Message-ID: <47E74608.7080007@cn.fujitsu.com>
Date: Mon, 24 Mar 2008 14:11:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: vladislav.yasevich@hp.com, sri@us.ibm.com,
       lksctp-developers@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] SCTP: fix compile warning building without CONFIG_IPV6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/net/sctp/sctp.h: In function ‘sctp_v6_pf_init’:
include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void

This warning repeats several times.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/net/sctp/sctp.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 57ed3e3..ea80673 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -389,7 +389,7 @@ void sctp_v6_del_protocol(void);
 
 #else /* #ifdef defined(CONFIG_IPV6) */
 
-static inline void sctp_v6_pf_init(void) { return 0; }
+static inline void sctp_v6_pf_init(void) { return; }
 static inline void sctp_v6_pf_exit(void) { return; }
 static inline int sctp_v6_protosw_init(void) { return 0; }
 static inline void sctp_v6_protosw_exit(void) { return; }
-- 
1.5.4.rc3
