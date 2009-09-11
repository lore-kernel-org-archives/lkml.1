Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZIKAcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZIKAcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbZIKAcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:32:41 -0400
Received: from kroah.org ([198.145.64.141]:38074 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbZIKA3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:10 2009
Message-Id: <20090911002410.490751860@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:22:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 10/22] sparc: sys32.S incorrect compat-layer splice() system call
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=sparc-sys32.s-incorrect-compat-layer-splice-system-call.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

[ Upstream commit e2c6cbd9ace61039d3de39e717195e38f1492aee ]

I think arch/sparc/kernel/sys32.S has an incorrect splice definition:

SIGN2(sys32_splice, sys_splice, %o0, %o1)

The splice() prototype looks like :

       long splice(int fd_in, loff_t *off_in, int fd_out,
                   loff_t *off_out, size_t len, unsigned int flags);

So I think we should have :

SIGN2(sys32_splice, sys_splice, %o0, %o2)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/sys32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/sys32.S
+++ b/arch/sparc/kernel/sys32.S
@@ -134,7 +134,7 @@ SIGN1(sys32_getpeername, sys_getpeername
 SIGN1(sys32_getsockname, sys_getsockname, %o0)
 SIGN2(sys32_ioprio_get, sys_ioprio_get, %o0, %o1)
 SIGN3(sys32_ioprio_set, sys_ioprio_set, %o0, %o1, %o2)
-SIGN2(sys32_splice, sys_splice, %o0, %o1)
+SIGN2(sys32_splice, sys_splice, %o0, %o2)
 SIGN2(sys32_sync_file_range, compat_sync_file_range, %o0, %o5)
 SIGN2(sys32_tee, sys_tee, %o0, %o1)
 SIGN1(sys32_vmsplice, compat_sys_vmsplice, %o0)


