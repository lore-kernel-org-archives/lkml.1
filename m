Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYKDOxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYKDOxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbYKDOxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:53:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60508 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYKDOxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:53:33 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 11/16] kvm_x86_ops: crash_hardware_disable() operation
Date: Tue,  4 Nov 2008 12:52:39 -0200
Message-Id: <1225810364-8990-12-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmx hardware_disable() function does too much for the virt_disable
crash handler, so we will have a new operation for the crash-time
virt_disable case.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09e6c56..002023b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -426,6 +426,7 @@ struct kvm_x86_ops {
 	int (*disabled_by_bios)(void);             /* __init */
 	void (*hardware_enable)(void *dummy);      /* __init */
 	void (*hardware_disable)(void *dummy);
+	void (*crash_hardware_disable)(void *dummy);
 	void (*check_processor_compatibility)(void *rtn);
 	int (*hardware_setup)(void);               /* __init */
 	void (*hardware_unsetup)(void);            /* __exit */
-- 
1.5.5.GIT

