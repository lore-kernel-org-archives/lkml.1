Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXGWCSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXGWCSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 22:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbXGWCSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 22:18:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38733
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751401AbXGWCSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 22:18:12 -0400
Date: Sun, 22 Jul 2007 19:18:11 -0700 (PDT)
Message-Id: <20070722.191811.15587624.davem@davemloft.net>
To: roland@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070722085940.7E3DE4D05C1@magilla.localdomain>
References: <20070722.012321.79430375.davem@davemloft.net>
	<20070722085940.7E3DE4D05C1@magilla.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>
Date: Sun, 22 Jul 2007 01:59:40 -0700 (PDT)

> Maybe:
> 
> --- a/arch/sparc64/kernel/vmlinux.lds.S
> +++ b/arch/sparc64/kernel/vmlinux.lds.S
> @@ -19,6 +19,7 @@ SECTIONS
>      SCHED_TEXT
>      LOCK_TEXT
>      KPROBES_TEXT
> +    NOTES
>      *(.gnu.warning)
>    } =0
>    _etext = .;

This generates a syntax error.

The following fix works and is what I'll merge in to fix this
problem, thanks!

diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 4758388..15109c1 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -35,6 +35,8 @@ SECTIONS
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;
 
+  NOTES
+
   . = ALIGN(4096);
   __init_begin = .;
   _sinittext = .;
diff --git a/arch/sparc64/kernel/vmlinux.lds.S b/arch/sparc64/kernel/vmlinux.lds.S
index 4818617..b982fa3 100644
--- a/arch/sparc64/kernel/vmlinux.lds.S
+++ b/arch/sparc64/kernel/vmlinux.lds.S
@@ -45,6 +45,8 @@ SECTIONS
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;
 
+  NOTES
+
   . = ALIGN(PAGE_SIZE);
   __init_begin = .;
   .init.text : { 
