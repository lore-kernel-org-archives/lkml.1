Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbXHOJJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbXHOJJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbXHOJI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:08:59 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44333 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756834AbXHOJI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:08:57 -0400
Message-ID: <387168935.12266@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 15 Aug 2007 17:08:55 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] seqfile: fix uninitialized memory allocation in
	mounts_open()
Message-ID: <20070815090855.GB19293@mail.ustc.edu.cn>
References: <387168197.02674@ustc.edu.cn> <b6fcc0a0708150204k16997328s9ff723b2a809be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6fcc0a0708150204k16997328s9ff723b2a809be@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 01:04:05PM +0400, Alexey Dobriyan wrote:
> On 8/15/07, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > proc_mounts.m.buf is not explicitly zeroed at allocation time, which
> > may later confuse the seqfile code and triggle an kfree(m->buf).
> 
> It's cleared in seq_open().

So it is :)

> > --- linux.orig/fs/proc/base.c
> > +++ linux/fs/proc/base.c
> > @@ -380,7 +380,7 @@ static int mounts_open(struct inode *ino
> >
> >  	if (ns) {
> >  		ret = -ENOMEM;
> > -		p = kmalloc(sizeof(struct proc_mounts), GFP_KERNEL);
> > +		p = kzalloc(sizeof(struct proc_mounts), GFP_KERNEL);
> >  		if (p) {
> >  			file->private_data = &p->m;
> >  			ret = seq_open(file, &mounts_op);

