Return-Path: <linux-kernel-owner+w=401wt.eu-S1752599AbZCREMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbZCREMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbZCREMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:12:24 -0400
Received: from ozlabs.org ([203.10.76.45]:49616 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZCREMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:12:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Valdis.Kletnieks@vt.edu
Subject: Re: linux-next - request_module_nowait() breaks iptables and iwl3945
Date: Wed, 18 Mar 2009 14:42:16 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
References: <3823.1237168684@turing-police.cc.vt.edu> <200903171627.58963.rusty@rustcorp.com.au> <39126.1237328835@turing-police.cc.vt.edu>
In-Reply-To: <39126.1237328835@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903181442.16570.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 March 2009 08:57:15 Valdis.Kletnieks@vt.edu wrote:
> On Tue, 17 Mar 2009 16:27:58 +1030, Rusty Russell said:
> > On Monday 16 March 2009 12:28:04 Valdis.Kletnieks@vt.edu wrote:
> > > On recent linux-next, iptables and iwl3945 would fail to load
> > Please send .config; I can't reproduce this here.
>
> [root@turing-police ~]# /etc/init.d/iptables start
> iptables: Applying firewall rules: 
> iptables-restore v1.4.2: iptables-restore: unable to initialize table 'filter'

OK, I think this might fix it.  It's already queued, but was labelled a mere
"cleanup".

Subject: kmod: use explicit names for waiting
Date: Mon, 16 Mar 2009 10:36:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>

Impact: cleanup

As call_usermodehelper accepts enum umh_wait as a wait parameter,
use constants from this enum instead of bool in __request_module.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/kmod.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index b2a53d0..b750675 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -109,7 +109,8 @@ int __request_module(bool wait, const char *fmt, ...)
 		return -ENOMEM;
 	}
 
-	ret = call_usermodehelper(modprobe_path, argv, envp, wait);
+	ret = call_usermodehelper(modprobe_path, argv, envp,
+			wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
 	atomic_dec(&kmod_concurrent);
 	return ret;
 }
