Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916Ab0AAOwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab0AAOwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 09:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786Ab0AAOwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 09:52:19 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37946 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0AAOwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 09:52:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ya/9vZN1xfgCUQ020rEaoc70vfxcPJdrva33V5ryrDIdGllFHkzZYhIdeudJwGQqHi
         /Kj0cRp33CyqYRmFjtnDzAGzWLlpQXAXmfHgXziv7BNK5ySZN6KQ+De6+G5J+V8ZYGUQ
         Rg3qZxml6/ljNjr9ASVOHjGhkiBSm2bqBqEsE=
MIME-Version: 1.0
In-Reply-To: <20091230152958.9b6e174e.akpm@linux-foundation.org>
References: <b9df5fa10912231905t69502923gee5aaf1c1b2efa6a@mail.gmail.com>
	 <20091230152958.9b6e174e.akpm@linux-foundation.org>
Date: Fri, 1 Jan 2010 20:52:18 +0600
Message-ID: <b9df5fa11001010652j74b1208g20e28a31b08fb6ea@mail.gmail.com>
Subject: Re: [PATCH] hugetlb: Fix section mismatch warning in hugetlb.c
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/09, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> I would be better to fix it the other way.  AFACIT,
>  hugetlb_register_node() and both versions of
>  hugetlb_register_all_nodes() should be marked __init.
>

Okay. Thanks for suggestion.
-----

 Since hugetlb_sysfs_add_hstate()'s ancestor function is from __init
and isn't referencing from any other function, so we  can do it.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/mm/hugetlb.c	2010-01-01 20:31:10.000000000 +0600
+++ rakib/mm/hugetlb.c	2010-01-01 20:26:58.000000000 +0600
@@ -1650,7 +1650,7 @@ static void hugetlb_unregister_all_nodes
  * Register hstate attributes for a single node sysdev.
  * No-op if attributes already registered.
  */
-void hugetlb_register_node(struct node *node)
+void __init hugetlb_register_node(struct node *node)
 {
 	struct hstate *h;
 	struct node_hstate *nhs = &node_hstates[node->sysdev.id];
@@ -1683,7 +1683,7 @@ void hugetlb_register_node(struct node *
  * sysdevs of nodes that have memory.  All on-line nodes should have
  * registered their associated sysdev by this time.
  */
-static void hugetlb_register_all_nodes(void)
+static void __init hugetlb_register_all_nodes(void)
 {
 	int nid;

@@ -1712,7 +1712,7 @@ static struct hstate *kobj_to_node_hstat

 static void hugetlb_unregister_all_nodes(void) { }

-static void hugetlb_register_all_nodes(void) { }
+static void __init hugetlb_register_all_nodes(void) { }

 #endif
