Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbZIWUhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbZIWUhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 16:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZIWUht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 16:37:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282AbZIWUht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 16:37:49 -0400
Date: Wed, 23 Sep 2009 13:37:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com
Subject: Re: [PATCH] ksm: change default values to better fit into mainline
 kernel
Message-Id: <20090923133735.dbe5dcec.akpm@linux-foundation.org>
In-Reply-To: <1253736347-3779-1-git-send-email-ieidus@redhat.com>
References: <1253736347-3779-1-git-send-email-ieidus@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 23:05:47 +0300
Izik Eidus <ieidus@redhat.com> wrote:

> +static void __init ksm_init_max_kernel_pages(void)
> +{
> +	ksm_max_kernel_pages = nr_free_buffer_pages() / 4;
> +}
> +
>  static int __init ksm_slab_init(void)
>  {
>  	rmap_item_cache = KSM_KMEM_CACHE(rmap_item, 0);
> @@ -1667,6 +1673,8 @@ static int __init ksm_init(void)
>  	struct task_struct *ksm_thread;
>  	int err;
>  
> +	ksm_init_max_kernel_pages();

Was it really worth creating a new function for this?

--- a/mm/ksm.c~ksm-change-default-values-to-better-fit-into-mainline-kernel-fix
+++ a/mm/ksm.c
@@ -184,11 +184,6 @@ static DEFINE_SPINLOCK(ksm_mmlist_lock);
 		sizeof(struct __struct), __alignof__(struct __struct),\
 		(__flags), NULL)
 
-static void __init ksm_init_max_kernel_pages(void)
-{
-	ksm_max_kernel_pages = nr_free_buffer_pages() / 4;
-}
-
 static int __init ksm_slab_init(void)
 {
 	rmap_item_cache = KSM_KMEM_CACHE(rmap_item, 0);
@@ -1673,7 +1668,7 @@ static int __init ksm_init(void)
 	struct task_struct *ksm_thread;
 	int err;
 
-	ksm_init_max_kernel_pages();
+	ksm_max_kernel_pages = nr_free_buffer_pages() / 4;
 
 	err = ksm_slab_init();
 	if (err)
_

oh well, whatever.
