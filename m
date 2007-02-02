Return-Path: <linux-kernel-owner+w=401wt.eu-S1423133AbXBBGWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423133AbXBBGWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 01:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423135AbXBBGWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 01:22:54 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:55807 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423133AbXBBGWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 01:22:53 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Willy Tarreau <w@1wt.eu>
Subject: Re: epoll handling in the alpha port
Date: Fri, 2 Feb 2007 01:22:50 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, rth@twiddle.net,
       linux-kernel@vger.kernel.org, alpha@gentoo.org
References: <200702011520.46723.vapier@gentoo.org> <200702020019.36248.vapier@gentoo.org> <20070202054828.GE24090@1wt.eu>
In-Reply-To: <20070202054828.GE24090@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1389656.s5TCqhpphT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702020122.51226.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1389656.s5TCqhpphT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 02 February 2007, Willy Tarreau wrote:
> I think it would be reasonable to use the NR_epoll* names first, and to
> declare NR_sys_epoll* aliases which will point to NR_epoll*. You would
> then add a comment with the date of the change, stating that you keep
> them just in case there are some old apps. Then, someone coming on the
> comment in 3 or 4 years could reasonably suggest removing those aliases.

fair enough, sounds like a plan man ... patch attached to do that

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/asm-alpha/unistd.h b/include/asm-alpha/unistd.h
index 84313d1..e58a427 100644
--- a/include/asm-alpha/unistd.h
+++ b/include/asm-alpha/unistd.h
@@ -342,9 +342,14 @@
 #define __NR_io_cancel			402
 #define __NR_exit_group			405
 #define __NR_lookup_dcookie		406
-#define __NR_sys_epoll_create		407
-#define __NR_sys_epoll_ctl		408
-#define __NR_sys_epoll_wait		409
+#define __NR_epoll_create		407
+#define __NR_epoll_ctl			408
+#define __NR_epoll_wait			409
+/* Feb 2007: These three sys_epoll defines shouldn't be here but culling
+ * them would break userspace apps ... we'll kill them off in 2010 :) */
+#define __NR_sys_epoll_create		__NR_epoll_create
+#define __NR_sys_epoll_ctl		__NR_epoll_ctl
+#define __NR_sys_epoll_wait		__NR_epoll_wait
 #define __NR_remap_file_pages		410
 #define __NR_set_tid_address		411
 #define __NR_restart_syscall		412

--nextPart1389656.s5TCqhpphT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iQIVAwUARcLYu0FjO5/oN/WBAQKSDA//fJRbFML4WIz9VDoDntDwPcffvXDRGQA1
zrGP8ya28w6O269dA0zLJnI0mVps9WdOUIzcPpXeRrPAFKOX830IASXJHtryea4P
zuOMFAw1qxwrrBAAi3DJaktTzS6rNYLLwbav1fRpbG9LA/y8HbGxQ5YB540oYIf1
SmAWi4NzrJWqu0z7qDuoIENznOSNhxTgPJZf8y4e9m8yGFFTcZn2M6e6086a/hUm
laq3VVj5ZpwXC9UnELAivrj6Zylq2WZAor5iIZ1Anauw7dORELMYb0FmGBDrmLhe
+7EG5iTP8EvqL++kdpbwGTlvL9FcP2I8PiJN6kEtkA7LnHtHn4kX4mg2a0Rb0SYP
zmsCMcvzkd7VG3SjQ01+MsF0FMi3jL9v7x1SZOH6oXyNLX0r+/sdAVfrPOnJh5de
o+1eSeqPGlI6t1u3HJnZL+JBT2gHC5037iZ68ayBb9Y4WJ4LCEXBs1f/oB4m7kCi
pp84JTvuVdXTpLtWa67uK9HK5fMT4WE8G8kdY01R6DlAG1T6cC/UxQywfbtWh0Gq
4hPnHzTcLYH0EHEGmUEpgYhFxr45Hva2jEiPCLcaYZgZkxk5JsUOn3HldyXO6V3Y
c+gxPEY6FdA5lBWAnWDxUb2Brcl93mtw0TO8R23JjlHkrz9KUGll2yjAydK/18C0
uzDib3tBj8k=
=myWK
-----END PGP SIGNATURE-----

--nextPart1389656.s5TCqhpphT--
