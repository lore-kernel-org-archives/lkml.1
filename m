Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbXJ1HDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbXJ1HDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 03:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbXJ1HDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 03:03:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:44658 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbXJ1HDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 03:03:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=fIaT2srVIB+kYcAO+5LbUMCIurtcao5Fx9cWFGDD+SXkHVOjDMrwqKYq683MRakeVt0DzvKtiV9atz38JUnRjvfwu0Iu7ltFQmC+wxOoDEaBYbKM7a+ksg0ESbWNUR8O2rfO11G06vQZo62y//YNh8KZhNZQ6AGXoXdLdCv5UeA=
Date: Sun, 28 Oct 2007 10:02:26 +0300
To: Joe Perches <joe@perches.com>
Cc: akpm@osdl.org, torvalds@osdl.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] proc_fs.h redux
Message-ID: <20071028070226.GA23097@martell.zuzino.mipt.ru>
References: <20071027194758.GD9816@martell.zuzino.mipt.ru> <1193524804.26695.103.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193524804.26695.103.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 03:40:04PM -0700, Joe Perches wrote:
> On Sat, 2007-10-27 at 23:47 +0400, Alexey Dobriyan wrote:
> > Remove proc_fs.h from headers that doesn't really need it.
> 
> > --- a/arch/powerpc/kernel/process.c
> > +++ b/arch/powerpc/kernel/process.c
> > @@ -17,6 +17,7 @@
> >  #include <linux/errno.h>
> >  #include <linux/sched.h>
> >  #include <linux/kernel.h>
> > +#include <linux/fs.h>
> 
> Your code doesn't match your patch description.
> 
> You've got new includes of:
> 
> <linux/fs.h>
> <linux/proc_fs.h>
> <linux/err.h>
> <linux/kref.h>
> 
> and forward declarations of
> 
> struct proc_dir_entry;
> struct file_operations;

Removal of header A from header B creates compilation breakages for
files which were getting A indirectly. So you have to complensate in all
such cases.

> As a general rule, I think it better to use includes
> than use naked forward declarations.

Well, we also want faster compilation and less time wasted when
test-compiling patches.
