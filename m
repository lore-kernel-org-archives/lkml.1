Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbYBXQfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbYBXQfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYBXQfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:35:38 -0500
Received: from ns.store20.com ([212.7.7.16]:37325 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbYBXQfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:35:37 -0500
Subject: Re: [PATCH] x86: fix build on non-C locales.
From: Priit Laes <plaes@plaes.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080224090324.GA8169@uranus.ravnborg.org>
References: <1203807950.12128.4.camel@localhost>
	 <20080224090324.GA8169@uranus.ravnborg.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Sun, 24 Feb 2008 18:36:05 +0200
Message-Id: <1203870965.17891.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ühel kenal päeval, P, 2008-02-24 kell 10:03, kirjutas Sam Ravnborg:
> Hi Prit.
> 
> Could we just use [[:alnum:]] and drop the setting of LC_ALL?
Yes, it works. Reverted the previous patch and did this:

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index f385a4b..b8bd0c4 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -48,7 +48,7 @@ obj-$(VDSO64-y)                       += vdso-syms.lds
 # Match symbols in the DSO that look like VDSO*; produce a file of
constants.
 #
 sed-vdsosym := -e 's/^00*/0/' \
-       -e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
+       -e 's/^\([[:xdigit:]]*\) . \(VDSO[[:alnum:]_]*\)$$/\2 = 0x\1;/p'
 quiet_cmd_vdsosym = VDSOSYM $@
       cmd_vdsosym = $(NM) $< | sed -n $(sed-vdsosym) | LC_ALL=C sort >
$@

