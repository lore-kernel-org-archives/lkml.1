Return-Path: <linux-kernel-owner+w=401wt.eu-S1765229AbXF1R45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765229AbXF1R45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759676AbXF1R4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:56:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39638 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbXF1R4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:56:48 -0400
Date: Thu, 28 Jun 2007 10:56:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] ICH Force HPET: Make generic time capable of
 switching broadcast timer
Message-Id: <20070628105624.8ab42a17.akpm@linux-foundation.org>
In-Reply-To: <Line.LNX.4.64.0706280808140.11719@localhost.localdomain>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
	<20070628001221.364438ce.akpm@linux-foundation.org>
	<20070628012749.caf450f6.akpm@linux-foundation.org>
	<Line.LNX.4.64.0706280808140.11719@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007 08:12:48 -0400 (EDT) James Morris <jmorris@namei.org> wrote:

> > My fix:
> 
> This should work.
> 

uh, OK, surprised.

Completer version:

--- a/security/selinux/hooks.c~git-selinux-disable-mmap_min_addr-by-default
+++ a/security/selinux/hooks.c
@@ -112,9 +112,6 @@ int selinux_enabled = 1;
 /* Original (dummy) security module. */
 static struct security_operations *original_ops = NULL;
 
-/* Did we enable minimum mmap address checking? */
-static int enabled_mmap_min_addr;
-
 /* Minimal support for a secondary security module,
    just to allow the use of the dummy or capability modules.
    The owlsm module can alternatively be used as a secondary
@@ -4917,15 +4914,6 @@ static __init int selinux_init(void)
 					    sizeof(struct inode_security_struct),
 					    0, SLAB_PANIC, NULL, NULL);
 
-	/*
-	 * Tasks cannot mmap below this without the mmap_zero permission.
-	 * If not enabled already, do so by setting it to 64KB.
-	 */
-	if (mmap_min_addr == 0) {
-		enabled_mmap_min_addr = 1;
-		mmap_min_addr = 65536;
-	}
-
 	avc_init();
 
 	original_ops = secondary_ops = security_ops;
@@ -5076,10 +5064,6 @@ int selinux_disable(void)
 	selinux_disabled = 1;
 	selinux_enabled = 0;
 
-	/* Disable minimum mmap address check only if we enabled it */
-	if (enabled_mmap_min_addr)
-		mmap_min_addr = 0;
-
 	/* Reset security_ops to the secondary module, dummy or capability. */
 	security_ops = secondary_ops;
 
_

