Return-Path: <linux-kernel-owner+w=401wt.eu-S933474AbXHAPUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474AbXHAPUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbXHAPUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:20:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:36653 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491AbXHAPUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=l017+Kxc3Sy4CCW3DfdUDzu2+uV5U/AAQGQQNvrLL5Py063P4kJlFnjZ6O+mHel6TEpdYPpfA+BsVnucIYS1ZPuaQHLPBZ0x67QJIlKkrRUiLPyjrZ5NH3jpFmqRzO3lpp9WMS6NRJWalfps09W475hvzJl5SL2JabcqQXA8B0Q=
Message-ID: <46B0A48B.3090606@googlemail.com>
Date: Wed, 01 Aug 2007 17:19:39 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH -mm] Fix a section mismatch warning
References: <20070731230932.a9459617.akpm@linux-foundation.org>
In-Reply-To: <20070731230932.a9459617.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

...

WARNING: vmlinux.o(.text+0x8b9f): Section mismatch: reference to .init.text:cache_remove_shared_cpu_map (between 'cpuid4_cache_sysfs_exit' and 'unexpected_machine_check')


...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

--- linux-2.6.23-rc1-mm/arch/i386/kernel/cpu/intel_cacheinfo.c.orig	2007-08-01 17:10:27.000000000 +0200
+++ linux-2.6.23-rc1-mm/arch/i386/kernel/cpu/intel_cacheinfo.c	2007-08-01 17:11:37.000000000 +0200
@@ -681,7 +681,7 @@ static struct kobj_type ktype_percpu_ent
 	.sysfs_ops	= &sysfs_ops,
 };
 
-static void cpuid4_cache_sysfs_exit(unsigned int cpu)
+static void __cpuinit cpuid4_cache_sysfs_exit(unsigned int cpu)
 {
 	kfree(cache_kobject[cpu]);
 	kfree(index_kobject[cpu]);
