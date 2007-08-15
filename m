Return-Path: <linux-kernel-owner+w=401wt.eu-S1765458AbXHOJB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765458AbXHOJB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbXHOJBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:01:20 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:38122 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755620AbXHOJBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:01:19 -0400
Message-ID: <387168476.07132@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 15 Aug 2007 17:01:16 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] seqfile: fix uninitialized memory allocation in
	mounts_open()
Message-ID: <20070815090116.GA19893@mail.ustc.edu.cn>
References: <20070815085637.GA19293@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815085637.GA19293@mail.ustc.edu.cn>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 04:56:37PM +0800, Fengguang Wu wrote:
> proc_mounts.m.buf is not explicitly zeroed at allocation time, which
> may later confuse the seqfile code and triggle an kfree(m->buf).

It's weird it did not show up in real world.  Could I be wrong?

> --- linux.orig/fs/proc/base.c
> +++ linux/fs/proc/base.c
> @@ -380,7 +380,7 @@ static int mounts_open(struct inode *ino
>  
>  	if (ns) {
>  		ret = -ENOMEM;
> -		p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
> +		p = kzalloc(sizeof(struct proc_mounts), GFP_KERNEL);
>  		if (p) {
>  			file->private_data = &p->m;
>  			ret = seq_open(file, &mounts_op);
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

