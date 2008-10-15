Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYJOA5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYJOA5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJOA4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:56:32 -0400
Received: from gw.goop.org ([64.81.55.164]:36866 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbYJOA42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:56:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 5] xen: compilation fix fo xen CPU hotplugging
X-Mercurial-Node: ad9829b5f99530f87b2bd661bdf9d7682c42f2f6
Message-Id: <ad9829b5f99530f87b2b.1224031843@abulafia.goop.org>
In-Reply-To: <patchbomb.1224031839@abulafia.goop.org>
Date: Tue, 14 Oct 2008 17:50:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

This patch fixes compilation error on ia64.
include asm/xen/hypervisor.h instead of asm-x86/xen/hypervisor.h
use xen_pv_domain() instead of is_running_on_xen()

>   CC      drivers/xen/cpu_hotplug.o
> In file included from /linux-2.6/drivers/xen/cpu_hotplug.c:5:
> /linux-2.6/include/asm-x86/xen/hypervisor.h:44:22: error: asm/desc.h: No such file or directory
> /linux-2.6/include/asm-x86/xen/hypervisor.h:66:1: warning: "MULTI_UVMFLAGS_INDEX" redefined
> In file included from /linux-2.6/include/asm-x86/xen/hypervisor.h:52,
>                  from /linux-2.6/drivers/xen/cpu_hotplug.c:5:
> /linux-2.6/arch/ia64/include/asm/xen/hypercall.h:233:1: warning: this is the location of the previous definition
> /linux-2.6/drivers/xen/cpu_hotplug.c: In function 'setup_vcpu_hotplug_event':
> /linux-2.6/drivers/xen/cpu_hotplug.c:81: error: implicit declaration of function 'is_running_on_xen'
> make[4]: *** [drivers/xen/cpu_hotplug.o] Error 1
> make[4]: *** Waiting for unfinished jobs....

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/cpu_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -2,7 +2,7 @@
 
 #include <xen/xenbus.h>
 
-#include <asm-x86/xen/hypervisor.h>
+#include <asm/xen/hypervisor.h>
 #include <asm/cpu.h>
 
 static void enable_hotplug_cpu(int cpu)


