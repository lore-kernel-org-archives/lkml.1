Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZCQQx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZCQQx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZCQQxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:53:19 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:50953 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbZCQQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IYqh2iIDTE1uOZMO04nOQselEEdw0gjN8Cy1wgsiCVETNugr+9llyN6Rg1USQnplOX
         wzZ4HW5PSF3y/bs/y5yWCY7JdMYgCWgDvKoqSU4VjGCvyXxAJlz5dfZ6xKGLSHAh08VM
         3ADAkzgQUsfCvcABALLCH8+faYBCIWXlF/MSQ=
Date: Tue, 17 Mar 2009 20:00:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, r0bertz@gentoo.org, viro@ZenIV.linux.org.uk
Subject: Re: [GIT] /proc/*/task getdents fixlet
Message-ID: <20090317170023.GA2479@x200.localdomain>
References: <20090317160638.GA2246@x200.localdomain> <alpine.LFD.2.00.0903170913250.3082@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903170913250.3082@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 09:15:46AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 17 Mar 2009, Alexey Dobriyan wrote:
> > 
> > Linus, please from
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc-linus
> > 
> > to get the following patch:
> > 
> > Zhang Le (1):
> >       proc: update ->f_pos correctly in proc_task_readdir()
> 
> Grr. I already took the previous patch.
> 
> I assume the only difference is to avoid using a "switch()" on a 64-bit 
> variable, and just cast it to "unsigned long". No?

Yes,

	+	switch ((unsigned long)filp->f_pos) {
