Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbYHLRkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbYHLRkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYHLRka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:40:30 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:34245 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYHLRk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=tpvVQMXZjo209xCpTY/vYf/DKIWfXulkTAuQSOVOh6BYBGuFjowShLP2mV3oOZC4Zm
         /3fJjK2lSXv6DmjqckMZRVx017aghYYq68YbbWOMPfdNkQx/LJ4CaMGZfvFasR3hG9Q1
         Fr7hcOEsY8b5xEdBS3p+8CSaNs42rJmA6WKQM=
Date: Wed, 13 Aug 2008 01:40:27 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] enable sparsemem without CONFIG_NUMA
Message-ID: <Pine.LNX.4.64.0808130126250.9140@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

While testing for more than 8 cpus, I couldn't select sparsemem when 
CONFIG_X86_GENERICARCH is selected instead of CONFIG_X86_PC.

Here's a patch to enable sparsemem independent of NUMA instead of just 
flatmem ... unless there a reason for sparsemem to depend on NUMA for 
more than 8 CPUs?


Thanks,
Jeff


--- ./arch/x86/Kconfig.org	2008-08-06 18:41:08 +0800
+++ ./arch/x86/Kconfig	2008-08-06 18:48:13 +0800
@@ -1035,7 +1035,7 @@

  config ARCH_FLATMEM_ENABLE
  	def_bool y
-	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC && !NUMA
+	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && !NUMA

  config ARCH_DISCONTIGMEM_ENABLE
  	def_bool y
@@ -1051,7 +1051,7 @@

  config ARCH_SPARSEMEM_ENABLE
  	def_bool y
-	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC)
+	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC) || X86_GENERICARCH
  	select SPARSEMEM_STATIC if X86_32
  	select SPARSEMEM_VMEMMAP_ENABLE if X86_64

