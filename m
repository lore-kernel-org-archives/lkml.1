Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbYKTOLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbYKTOLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYKTOLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:11:25 -0500
Received: from koto.vergenet.net ([210.128.90.7]:48236 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbYKTOLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:11:24 -0500
X-Greylist: delayed 1821 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2008 09:11:24 EST
Date: Thu, 20 Nov 2008 17:33:31 +0900
From: Simon Horman <horms@verge.net.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 30 of 38] xen: implement io_apic_ops
Message-ID: <20081120083329.GA13996@verge.net.au>
References: <patchbomb.1226603398@abulafia.goop.org> <d103c0da2fa147ac31af.1226603428@abulafia.goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d103c0da2fa147ac31af.1226603428@abulafia.goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it seems that if CONFIG_XEN is set by CONFIG_XEN_DOM0 is not set,
then the call to xen_init_apic() in xen_start_kernel() causes the
build to fail.

One possible soluion to this is to provide a dummy
version of xen_init_apic() in the !CONFIG_XEN_DOM0 case.

Another possible solution would be to add #ifdef CONFIG_XEN_DOM0
inside xen_start_kernel()

#make gcc --version
gcc (Debian 4.3.2-1) 4.3.2
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# make
[snip]
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/x86/xen/built-in.o: In function `xen_start_kernel':
(.init.text+0x8ef): undefined reference to `xen_init_apic'

Index: linux-2.6/arch/x86/xen/xen-ops.h
===================================================================
--- linux-2.6.orig/arch/x86/xen/xen-ops.h	2008-11-20 17:23:14.000000000 +0900
+++ linux-2.6/arch/x86/xen/xen-ops.h	2008-11-20 17:24:28.000000000 +0900
@@ -64,7 +64,11 @@ static inline void xen_smp_init(void) {}
 #endif
 
 
+#ifdef CONFIG_XEN_DOM0
 void xen_init_apic(void);
+#else
+static inline void xen_init_apic(void) { ; }
+#endif
 
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
