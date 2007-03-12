Return-Path: <linux-kernel-owner+w=401wt.eu-S964856AbXCLATv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856AbXCLATv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 20:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964974AbXCLATv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 20:19:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964856AbXCLATu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 20:19:50 -0400
To: "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: _proxy_pda still makes linking modules fail
References: <1173315479.12472.9.camel@qrnik>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 Mar 2007 02:19:05 +0100
In-Reply-To: <1173315479.12472.9.camel@qrnik>
Message-ID: <p73lki39s3a.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Marcin 'Qrczak' Kowalczyk <qrczak@knm.org.pl> writes:
> 
> I've heard that it now builds with gcc-4.2.0 snapshots. This is strange:
> if the problem has been fixed for gcc-4.2.0, why doesn't it work for
> gcc-4.1.2? arch/i386/kernel/vmlinux.lds.S does contain _proxy_pda = 0;

Hmm, it probably needs a EXPORT_SYMBOL. The previous change only
fixed the in kernel build.

Does it work with this patch?

-Andi

Export _proxy_pda for gcc 4.2

The symbol is not actually used, but the compiler unforunately generates
a (unused) reference to it. This can happen even in modules. So export it.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/i386_ksyms.c
===================================================================
--- linux.orig/arch/i386/kernel/i386_ksyms.c
+++ linux/arch/i386/kernel/i386_ksyms.c
@@ -28,3 +28,5 @@ EXPORT_SYMBOL(__read_lock_failed);
 #endif
 
 EXPORT_SYMBOL(csum_partial);
+
+EXPORT_SYMBOL(_proxy_pda);
Index: linux/arch/x86_64/kernel/x8664_ksyms.c
===================================================================
--- linux.orig/arch/x86_64/kernel/x8664_ksyms.c
+++ linux/arch/x86_64/kernel/x8664_ksyms.c
@@ -61,3 +61,4 @@ EXPORT_SYMBOL(empty_zero_page);
 EXPORT_SYMBOL(init_level4_pgt);
 EXPORT_SYMBOL(load_gs_index);
 
+EXPORT_SYMBOL(_proxy_pda);
