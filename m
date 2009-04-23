Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbZDWW0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbZDWW0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZDWW0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:26:24 -0400
Received: from smtp-out.google.com ([216.239.45.13]:42755 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbZDWW0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:26:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Mm+ocYqF6H98hPPkkZ53x9fBdIqYiCxlv8CjiyX18yXQFQKg3l9y2OSZH4mrKHyWE
	nP4KITQRMXxrRsZ6iy2hg==
Date: Thu, 23 Apr 2009 15:26:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: add
 Documentation/ABI/testing/sysfs-kernel-slab
In-Reply-To: <alpine.DEB.2.00.0904231137440.20852@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0904231510020.30545@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com> <alpine.DEB.2.00.0904231137440.20852@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, David Rientjes wrote:

> Adds documentation for the slub ABI.
> 
> This is placed in the `testing' directory since the meanings of these
> files are still subject to change as slub is developed.
> 

I just noticed that slqb also uses /sys/kernel/slab for its sysfs API, so 
this isn't going to work unless

 - slqb uses /sys/kernel/slab as well and we simply add its files in
   sysfs-kernel-slab and leave it to userspace to test for which allocator
   is actually being used.  Both allocators share many of the same
   fundamental attributes but some are only applicable to one,

 - slqb moves to /sys/kernel/slqb since slub is already resident in
   /sys/kernel/slab and the mm/slab.c allocator actually has no sysfs
   interface, or

 - this file is renamed to sysfs-kernel-slub and a sysfs-kernel-slab file
   is created that simply points users to the correct ABI file depending
   on their configuration.

I'd be included to suggest that slqb moves to /sys/kernel/slqb despite the 
naming disparity between slub and its ABI in /sys/kernel/slab.

Opinions?


slqb: move sysfs API into slqb directory

SLUB already has a sysfs API in the `slab' directory, so SLQB must use 
`slqb'.

Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
diff --git a/mm/slqb.c b/mm/slqb.c
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -3536,7 +3536,7 @@ static int __init slab_sysfs_init(void)
 	struct kmem_cache *s;
 	int err;
 
-	slab_kset = kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);
+	slab_kset = kset_create_and_add("slqb", &slab_uevent_ops, kernel_kobj);
 	if (!slab_kset) {
 		printk(KERN_ERR "Cannot register slab subsystem.\n");
 		return -ENOSYS;
