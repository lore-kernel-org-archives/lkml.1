Return-Path: <linux-kernel-owner+w=401wt.eu-S932641AbXCXHli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbXCXHli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 03:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932406AbXCXHli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 03:41:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60597 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbXCXHlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 03:41:37 -0400
Date: Sat, 24 Mar 2007 07:41:29 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Ken Chen <kenchen@google.com>
Cc: Adam Litke <agl@us.ibm.com>, William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] hugetlb: add /dev/hugetlb char device
Message-ID: <20070324074129.GB18408@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Ken Chen <kenchen@google.com>, Adam Litke <agl@us.ibm.com>,
	William Lee Irwin III <wli@holomorphy.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <b040c32a0703231545h79d45d0eof1edd225ef3d8ee9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b040c32a0703231545h79d45d0eof1edd225ef3d8ee9@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +int hugetlb_zero_setup(struct file *file, struct vm_area_struct *vma)
> +{
> +	file = hugetlb_file_setup(vma->vm_end - vma->vm_start, 0);
> +	if (IS_ERR(file))
> +		return PTR_ERR(file);
> +
> +	if (vma->vm_file)
> +		fput(vma->vm_file);
> +	vma->vm_file = file;
> +	return hugetlbfs_file_mmap(file, vma);
> +}

Setting vma->vm_file to something that is not the file we called mmap
on and even refers to a different inode seems rather dangerous.

