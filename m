Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbXJHL5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbXJHL5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 07:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXJHL5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 07:57:14 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:41057 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbXJHL5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 07:57:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EI1rgK6h0LIoLuwVmm5dVGRgEWd5BDzYYRulILqv9Vlx0pQkUzjgL2OxKJb2WP7lcKqKK8ZYbO5MuN16WqojOBIxb7k6bsIxI9HnPgfMwM6AsOTW9eDAwiWX0/PYTjAAfg3jdaMK7sZ2eHUqVQJAUxHdj/7aumY0ERTE/VVNtmw=
Date: Mon, 8 Oct 2007 19:52:36 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Yan Zheng <yanzheng@21cn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH]fix VM_CAN_NONLINEAR check in sys_remap_file_pages
Message-ID: <20071008115236.GB2460@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d0408630710080445j4dea115emdfe29aac26814536@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 07:45:08PM +0800, Yan Zheng wrote:
>Hi all
>
>The test for VM_CAN_NONLINEAR always fails
>
>Signed-off-by: Yan Zheng<yanzheng@21cn.com>
>----
>diff -ur linux-2.6.23-rc9/mm/fremap.c linux/mm/fremap.c
>--- linux-2.6.23-rc9/mm/fremap.c	2007-10-07 15:03:33.000000000 +0800
>+++ linux/mm/fremap.c	2007-10-08 19:33:44.000000000 +0800
>@@ -160,7 +160,7 @@
> 	if (vma->vm_private_data && !(vma->vm_flags & VM_NONLINEAR))
> 		goto out;
>
>-	if (!vma->vm_flags & VM_CAN_NONLINEAR)
>+	if (!(vma->vm_flags & VM_CAN_NONLINEAR))

Good catch!

! operator has higher priority than & operator.

Acked by me. ;-)


> 		goto out;
>
> 	if (end <= start || start < vma->vm_start || end > vma->vm_end)


