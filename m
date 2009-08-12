Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbZHLXYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbZHLXYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 19:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZHLXYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 19:24:22 -0400
Received: from sparc.brc.ubc.ca ([137.82.2.12]:54781 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491AbZHLXYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 19:24:22 -0400
Date: Wed, 12 Aug 2009 16:46:15 -0700 (PDT)
From: "Li, Ming Chun" <macli@brc.ubc.ca>
To: David Rientjes <rientjes@google.com>
Cc: Vincent Li <macli@brc.ubc.ca>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/proc/task_mmu.c: fix clear_refs_write() input sanity
 check
In-Reply-To: <alpine.DEB.2.00.0908121522350.7135@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0908121642300.22028@mail.selltech.ca>
References: <1250114690-24829-1-git-send-email-macli@brc.ubc.ca> <alpine.DEB.2.00.0908121522350.7135@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, David Rientjes wrote:

> On Wed, 12 Aug 2009, Vincent Li wrote:
> 
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 2079969..026b532 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -494,18 +494,17 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> >  	char buffer[PROC_NUMBUF], *end;
> >  	struct mm_struct *mm;
> >  	struct vm_area_struct *vma;
> > -	int type;
> > +	long res;
> >  
> 
> What does `res' mean?  Why can't it just be left as `type'?

res mean the result parsed from userspace input, I can keep it as name 
'type'.

> 
> >  	memset(buffer, 0, sizeof(buffer));
> >  	if (count > sizeof(buffer) - 1)
> >  		count = sizeof(buffer) - 1;
> >  	if (copy_from_user(buffer, buf, count))
> >  		return -EFAULT;
> > -	type = simple_strtol(buffer, &end, 0);
> > -	if (type < CLEAR_REFS_ALL || type > CLEAR_REFS_MAPPED)
> > +	if (strict_strtol(strstrip(buffer), 10, &res)
> > +		return -EINVAL;
> 
> Please test your patch submissions (which would require that the above 
> actually compiles).
> 

I did get compiling error and warnings, I will resend the patch with 
varible name 'type' left and no compiling errors.


Vincent Li
Biomedical Research Center
University of British Columbia
