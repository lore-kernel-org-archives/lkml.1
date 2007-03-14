Return-Path: <linux-kernel-owner+w=401wt.eu-S1752197AbXCNROZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbXCNROZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 13:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbXCNROZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 13:14:25 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:11568 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751597AbXCNROY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 13:14:24 -0400
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2007 13:14:24 EDT
Subject: [PATCH 1/1] Allow i386 crash kernels to handle x86_64 dumps
From: Ian Campbell <Ian.Campbell@XenSource.com>
To: vgoyal@in.ibm.com, hbabu@us.ibm.com
Cc: fastboot@lists.osdl.org, linux-kernel@vger.kernel.org,
       Horms <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 17:00:09 +0000
Message-Id: <1173891609.8591.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2007 17:00:15.0317 (UTC) FILETIME=[3C9A1850:01C7665A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The specific case I am encountering is kdump under Xen with a 64 bit
hypervisor and 32 bit kernel/userspace. The dump created is a 64 bit due
to the hypervisor but the dump kernel is 32 bit to match the domain 0
kernel.

It's possibly less likely to be useful in a purely native scenario but I
see no reason to disallow it.

Signed-off-by: Ian Campbell <ian.campbell@xensource.com>

--- pristine-linux-2.6.18/include/asm-i386/elf.h	2006-09-20 04:42:06.000000000 +0100
+++ linux-2.6.18-xen/include/asm-i386/elf.h	2007-03-14 16:42:30.000000000 +0000
@@ -36,7 +36,7 @@
  * This is used to ensure we don't load something for the wrong architecture.
  */
 #define elf_check_arch(x) \
-	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
+	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486) || ((x)->e_machine == EM_X86_64))
 
 /*
  * These are used to set parameters in the core dumps.


