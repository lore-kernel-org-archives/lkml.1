Return-Path: <linux-kernel-owner+w=401wt.eu-S1763619AbXHOJET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763619AbXHOJET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbXHOJEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:04:09 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:1466 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbXHOJEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W4TVcVHbdFCr8OJsHIH2TsseaPmuhZ148nTOmNVlovV4YJuQdzgFeLUZDKxG9OGIADD/vGT4L/Ci0hSTSbUIZF82T9Hx2W1TNctizNCebXnRuWRHdHhs3NROxTmR/bTJ84DdwMRKxZt4GjutJgcqX+irvnR4NDxjEZ9iviqHS+k=
Message-ID: <b6fcc0a0708150204k16997328s9ff723b2a809be@mail.gmail.com>
Date: Wed, 15 Aug 2007 13:04:05 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH] seqfile: fix uninitialized memory allocation in mounts_open()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Al Viro" <viro@ftp.linux.org.uk>
In-Reply-To: <387168197.02674@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <387168197.02674@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> proc_mounts.m.buf is not explicitly zeroed at allocation time, which
> may later confuse the seqfile code and triggle an kfree(m->buf).

It's cleared in seq_open().

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
