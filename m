Return-Path: <linux-kernel-owner+w=401wt.eu-S932904AbXCFH1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904AbXCFH1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 02:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbXCFH1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 02:27:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58085 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750AbXCFH1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 02:27:12 -0500
Date: Tue, 6 Mar 2007 07:27:06 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [S390] system call cleanup.
Message-ID: <20070306072706.GA22458@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
References: <20070305224320.GL22630@skybase>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305224320.GL22630@skybase>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	struct pt_regs *regs = task_pt_regs(current);
> +	char *filename;
> +	unsigned long result;
> +	int rc;
> +
> +	filename = getname(compat_ptr(regs->orig_gpr2));
> +	if (IS_ERR(filename)) {
> +		result = PTR_ERR(filename);
>                  goto out;

The old code here..

> +	struct pt_regs *regs = task_pt_regs(current);
>          unsigned long clone_flags;
>          unsigned long newsp;
>  	int __user *parent_tidptr, *child_tidptr;

..and here..

> +asmlinkage long sys_clone(void)
>  {
> +	struct pt_regs *regs = task_pt_regs(current);
>          unsigned long clone_flags;
>          unsigned long newsp;
>  	int __user *parent_tidptr, *child_tidptr;

..and here used spaces instead of tabs, it would be nice to clean this
up while you're at it.

