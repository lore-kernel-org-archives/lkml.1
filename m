Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXJHRFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXJHRFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 13:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXJHRFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 13:05:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56150 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbXJHRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 13:05:44 -0400
Date: Mon, 8 Oct 2007 10:04:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yan Zheng" <yanzheng@21cn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH]fix VM_CAN_NONLINEAR check in sys_remap_file_pages
Message-Id: <20071008100456.dbe826d0.akpm@linux-foundation.org>
In-Reply-To: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com>
References: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2007 19:45:08 +0800 "Yan Zheng" <yanzheng@21cn.com> wrote:

> Hi all
> 
> The test for VM_CAN_NONLINEAR always fails
> 
> Signed-off-by: Yan Zheng<yanzheng@21cn.com>
> ----
> diff -ur linux-2.6.23-rc9/mm/fremap.c linux/mm/fremap.c
> --- linux-2.6.23-rc9/mm/fremap.c	2007-10-07 15:03:33.000000000 +0800
> +++ linux/mm/fremap.c	2007-10-08 19:33:44.000000000 +0800
> @@ -160,7 +160,7 @@
>  	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
>  		goto out;
> 
> -	if (!vma->vm_flags & VM_CAN_NONLINEAR)
> +	if (!(vma->vm_flags & VM_CAN_NONLINEAR))
>  		goto out;
> 
>  	if (end <= start || start < vma->vm_start || end > vma->vm_end)

Lovely.  From this we can deduce that nobody has run remap_file_pages() since
2.6.23-rc1 and that nobody (including the developer who made that change) ran it
while that change was in -mm.

I'm surprise that LTP doesn't have any remap_file_pages() tests.

Have you runtime tested this change?

Thanks.
