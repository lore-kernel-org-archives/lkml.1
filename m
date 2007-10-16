Return-Path: <linux-kernel-owner+w=401wt.eu-S1765844AbXJPFOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765844AbXJPFOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXJPFOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:14:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:51782 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbXJPFOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:14:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=FLT/DcUsAyK6iKXgX75b0S1udFsBoWWsnS76mdioFHdbXPGIhT40KHyDrUPj/iKBX
	eL/IbsuNAwIRQrfv6cx/w==
Date: Mon, 15 Oct 2007 22:11:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 7/11] maps3: move clear_refs code to task_mmu.c
In-Reply-To: <8.290135367@selenic.com>
Message-ID: <alpine.DEB.0.9999.0710152210170.10947@chino.kir.corp.google.com>
References: <8.290135367@selenic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Matt Mackall wrote:

> Index: l/fs/proc/task_mmu.c
> ===================================================================
> --- l.orig/fs/proc/task_mmu.c	2007-10-14 13:38:43.000000000 -0500
> +++ l/fs/proc/task_mmu.c	2007-10-14 13:39:00.000000000 -0500
> @@ -324,19 +324,47 @@ static int show_smap(struct seq_file *m,
>  
>  static struct mm_walk clear_refs_walk = { .pmd_entry = clear_refs_pte_range };
>  
> -void clear_refs_smap(struct mm_struct *mm)
> +static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> +				size_t count, loff_t *ppos)
>  {
> +	struct task_struct *task;
> +	char buffer[13], *end;

The #define for PROC_NUMBUF will need to be moved from fs/proc/base.c to 
include/linux/proc_fs.h and used here instead of hardcoding it.
