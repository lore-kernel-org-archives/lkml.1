Return-Path: <linux-kernel-owner+w=401wt.eu-S934332AbXCXANB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332AbXCXANB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 20:13:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbXCXANB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 20:13:01 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:50744 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbXCXANA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 20:13:00 -0400
Date: Sat, 24 Mar 2007 01:06:28 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Ken Chen <kenchen@google.com>
cc: Nish Aravamudan <nish.aravamudan@gmail.com>, Adam Litke <agl@us.ibm.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] hugetlb: add resv argument to hugetlb_file_setup
In-Reply-To: <b040c32a0703231553k6e1790c0v22de49af2e437675@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0703240106110.10028@yvahk01.tjqt.qr>
References: <b040c32a0703231542r77030723o214255a5fa591dec@mail.gmail.com> 
 <29495f1d0703231548k377e3f8ds5f2ae529c34e4380@mail.gmail.com>
 <b040c32a0703231553k6e1790c0v22de49af2e437675@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 23 2007 15:53, Ken Chen wrote:
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 8c718a3..981886f 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -734,7 +734,7 @@ static int can_do_hugetlb_shm(void)
> 			can_do_mlock());
> }
>
> -struct file *hugetlb_zero_setup(size_t size)
> +struct file *hugetlb_file_setup(size_t size, int resv)
> {
> int error = -ENOMEM;
> struct file *file;
> @@ -771,7 +771,7 @@ struct file *hugetlb_zero_setup(size_t s
> goto out_file;
>
> 	error = -ENOMEM;
> -	if (hugetlb_reserve_pages(inode, 0, size >> HPAGE_SHIFT))
> +	if (resv && hugetlb_reserve_pages(inode, 0, size >> HPAGE_SHIFT))
> goto out_inode;
>
> 	d_instantiate(dentry, inode);

Could not this be made a bool, then?




Jan
-- 
