Return-Path: <linux-kernel-owner+w=401wt.eu-S1762164AbYCGM0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762164AbYCGM0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYCGM0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:26:13 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:24687 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYCGM0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:26:12 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Subject: headersinstall of kvm.h does not work
Date: Fri, 7 Mar 2008 13:26:06 +0100
User-Agent: KMail/1.9.7
Cc: Sam Ravnborg <sam@ravnborg.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803071326.06682.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Avi,

in commit fb56dbb31c4738a3918db81fd24da732ce3b4ae6 you changed 
include/linux/Kbuild:
----snip----
KVM: Export include/linux/kvm.h only if $ARCH actually supports KVM
Currently, make headers_check barfs due to <asm/kvm.h>, which <linux/kvm.h>
includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export 
kvm.h only if the arch actually supports it.
[...]
 unifdef-y += keyboard.h
-unifdef-y += kvm.h
+unifdef-$(CONFIG_HAVE_KVM) += kvm.h
 unifdef-y += llc.h
 unifdef-y += loop.h
----snip------

This patch does not work. Kbuild (scripts/Makefile.headersinst) does not 
check the config file, so kvm.h is never installed.

Sam is there an easy way to allow constructs like "unifdef-$(CONFIG_FOO)"?

Thanks

Christian

