Return-Path: <linux-kernel-owner+w=401wt.eu-S1764485AbXHAOXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764485AbXHAOXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbXHAOXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:23:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:53553 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbXHAOXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CYNIT9lVdVS3hPXY6WMTRXdsRg2yDx6GlAxDF1yhf2L4IU+1RdJPvOq6xLWbyHjlzkeDBRnXKsHCXlC1uA8Ix5bYxExFOkhBTCbtODf3QtsKmndailC3jiECVZj6DyiCHCeU4b4zIWZvO6u/m4fJ+YjjCAx1u6nFBZ6rwgD3Q/8=
Message-ID: <46B0974E.3030703@googlemail.com>
Date: Wed, 01 Aug 2007 16:23:10 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       Yaniv Kamay <yaniv@qumranet.com>
Subject: [PATCH -mm] Fix defined but not used warning in drivers/kvm/vmx.c
References: <20070731230932.a9459617.akpm@linux-foundation.org>
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

move_msr_up() is used only on X86_64 and generates a warning on !X86_64

...

drivers/kvm/vmx.c:548: warning: 'move_msr_up' defined but not used

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

PS: Btw Avi why do you think I'm mysterious ?:)
...

git-kvm.patch:    Noted by the mysterious Gabriel C.

...

--- linux-2.6.23-rc1-mm/drivers/kvm/vmx.c.orig	2007-08-01 15:56:41.000000000 +0200
+++ linux-2.6.23-rc1-mm/drivers/kvm/vmx.c	2007-08-01 15:58:24.000000000 +0200
@@ -544,6 +544,7 @@ static void vmx_inject_gp(struct kvm_vcp
 /*
  * Swap MSR entry in host/guest MSR entry array.
  */
+#ifdef CONFIG_X86_64
 static void move_msr_up(struct vcpu_vmx *vmx, int from, int to)
 {
 	struct kvm_msr_entry tmp;
@@ -555,6 +556,7 @@ static void move_msr_up(struct vcpu_vmx 
 	vmx->host_msrs[to] = vmx->host_msrs[from];
 	vmx->host_msrs[from] = tmp;
 }
+#endif
 
 /*
  * Set up the vmcs to automatically save and restore system
