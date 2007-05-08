Return-Path: <linux-kernel-owner+w=401wt.eu-S969479AbXEHXIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969479AbXEHXIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968588AbXEHXIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:08:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36028 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967609AbXEHXIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:08:45 -0400
Date: Tue, 8 May 2007 16:08:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Kevin Winchester <kjwinchester@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot
In-Reply-To: <4640FE35.2070605@gmail.com>
Message-ID: <Pine.LNX.4.64.0705081608160.15979@schroedinger.engr.sgi.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
 <4640FE35.2070605@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that a uevent notification fails.

Does this patch fix it?

---
 mm/slub.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-05-08 16:06:54.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-05-08 16:07:11.000000000 -0700
@@ -3438,7 +3438,6 @@ static int sysfs_slab_add(struct kmem_ca
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
 	if (err)
 		return err;
-	kobject_uevent(&s->kobj, KOBJ_ADD);
 	if (!unmergeable) {
 		/* Setup first alias */
 		sysfs_slab_alias(s, s->name);

