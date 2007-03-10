Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbXCJHBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbXCJHBY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 02:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933496AbXCJHBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 02:01:24 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:49513 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933502AbXCJHBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 02:01:22 -0500
Message-ID: <45F257C1.4070904@vmware.com>
Date: Fri, 09 Mar 2007 23:01:21 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: PATCH: Fix VMI and COMPAT_VDSO for 2.6.21
References: <45F2578E.3060907@vmware.com>
In-Reply-To: <45F2578E.3060907@vmware.com>
Content-Type: multipart/mixed;
 boundary="------------090606070209090205050408"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090606070209090205050408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Zachary Amsden wrote:
> VMI is broken under COMPAT_VDSO, as Xen and other non hardware 
> assisted hypervisors will be.  I have been working on a fix for this 
> which works for older glibcs that panic when the new relocatable VDSO 
> is used.  However, I believe at this time that the fix is going to be 
> too radical to consider at this stage in the release of 2.6.21.  We 
> don't expect this config option to be turned on by vendors for new 
> distributions, so at this point we are willing to drop support for it 
> when VMI is compiled in, and work on a patch for 2.6.22 which more 
> fully addresses the problem.
>
> Please apply, thanks.

I suppose it would be better if I attached the patch.

Zach

--------------090606070209090205050408
Content-Type: text/plain;
 name="vmi-depends-on-not-compat-vdso.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmi-depends-on-not-compat-vdso.patch"

Signed-off-by: Zachary Amsden <zach@vmware.com>

Index: linux-2.6.21/arch/i386/Kconfig
===================================================================
--- linux-2.6.21.orig/arch/i386/Kconfig	2007-03-06 18:51:33.000000000 -0800
+++ linux-2.6.21/arch/i386/Kconfig	2007-03-09 22:36:15.000000000 -0800
@@ -220,7 +220,7 @@ config PARAVIRT
 
 config VMI
 	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT
+	depends on PARAVIRT && !COMPAT_VDSO
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not

--------------090606070209090205050408--
